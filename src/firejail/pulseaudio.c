/*
 * Copyright (C) 2014-2024 Firejail Authors
 *
 * This file is part of firejail project
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/
#include "firejail.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/statvfs.h>
#include <sys/mount.h>
#include <dirent.h>
#include <errno.h>
#include <sys/wait.h>
#include <glob.h>

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif

#define PULSE_CLIENT_SYSCONF "/etc/pulse/client.conf"



static void disable_rundir_pipewire(const char *path) {
	assert(path);

	// globbing for path/pipewire-*
	char *pattern;
	if (asprintf(&pattern, "%s/pipewire-*", path) == -1)
		errExit("asprintf");

	glob_t globbuf;
	int globerr = glob(pattern, GLOB_NOCHECK | GLOB_NOSORT, NULL, &globbuf);
	if (globerr) {
		fprintf(stderr, "Error: failed to glob pattern %s\n", pattern);
		exit(1);
	}

	size_t i;
	for (i = 0; i < globbuf.gl_pathc; i++) {
		char *dir = globbuf.gl_pathv[i];
		assert(dir);

		// don't disable symlinks - disable_file_or_dir will bind-mount an empty directory on top of it!
		if (is_link(dir))
			continue;
		disable_file_or_dir(dir);
	}
	globfree(&globbuf);
	free(pattern);
}



// disable pipewire socket
void pipewire_disable(void) {
	if (arg_debug)
		printf("disable pipewire\n");
	// blacklist user config directory
	disable_file_path(cfg.homedir, ".config/pipewire");

	// blacklist pipewire in XDG_RUNTIME_DIR
	const char *name = env_get("XDG_RUNTIME_DIR");
	if (name)
		disable_rundir_pipewire(name);

	// try the default location anyway
	char *path;
	if (asprintf(&path, "/run/user/%d", getuid()) == -1)
		errExit("asprintf");
	disable_rundir_pipewire(path);
	free(path);
}

// disable pulseaudio socket
void pulseaudio_disable(void) {
	if (arg_debug)
		printf("disable pulseaudio\n");
	// blacklist user config directory
	disable_file_path(cfg.homedir, ".config/pulse");


	// blacklist pulseaudio socket in XDG_RUNTIME_DIR
	const char *name = env_get("XDG_RUNTIME_DIR");
	if (name)
		disable_file_path(name, "pulse/native");

	// try the default location anyway
	char *path;
	if (asprintf(&path, "/run/user/%d", getuid()) == -1)
		errExit("asprintf");
	disable_file_path(path, "pulse");
	free(path);



	// blacklist any pulse* file in /tmp directory
	DIR *dir;
	if (!(dir = opendir("/tmp"))) {
		// sleep 2 seconds and try again
		sleep(2);
		if (!(dir = opendir("/tmp"))) {
			return;
		}
	}

	struct dirent *entry;
	while ((entry = readdir(dir))) {
		if (strncmp(entry->d_name, "pulse-", 6) == 0) {
			disable_file_path("/tmp", entry->d_name);
		}
	}

	closedir(dir);
}

// disable shm in pulseaudio (issue #69)
void pulseaudio_init(void) {
	// do we have pulseaudio in the system?
	if (access(PULSE_CLIENT_SYSCONF, R_OK)) {
		if (arg_debug)
			printf("Cannot read %s\n", PULSE_CLIENT_SYSCONF);
		return;
	}

	// create ~/.config/pulse directory if not present
	char *homeusercfg = NULL;
	if (asprintf(&homeusercfg, "%s/.config", cfg.homedir) == -1)
		errExit("asprintf");
	if (create_empty_dir_as_user(homeusercfg, 0700))
		fs_logger2("create", homeusercfg);

	free(homeusercfg);
	if (asprintf(&homeusercfg, "%s/.config/pulse", cfg.homedir) == -1)
		errExit("asprintf");
	if (create_empty_dir_as_user(homeusercfg, 0700))
		fs_logger2("create", homeusercfg);

	// create the new user pulseaudio directory
	// that will be mounted over ~/.config/pulse
	if (mkdir(RUN_PULSE_DIR, 0700) == -1)
		errExit("mkdir");
	selinux_relabel_path(RUN_PULSE_DIR, homeusercfg);
	fs_remount(RUN_PULSE_DIR, MOUNT_NOEXEC, 0);
	// create the new client.conf file
	char *pulsecfg = NULL;
	if (asprintf(&pulsecfg, "%s/client.conf", RUN_PULSE_DIR) == -1)
		errExit("asprintf");
	if (copy_file(PULSE_CLIENT_SYSCONF, pulsecfg, -1, -1, 0644)) // root needed
		errExit("copy_file");
	FILE *fp = fopen(pulsecfg, "ae");
	if (!fp)
		errExit("fopen");
	fprintf(fp, "%s", "\nenable-shm = no\n");
	SET_PERMS_STREAM(fp, getuid(), getgid(), 0644);
	fclose(fp);
	// hand over the directory to the user
	if (set_perms(RUN_PULSE_DIR, getuid(), getgid(), 0700))
		errExit("set_perms");

	// if ~/.config/pulse exists and there are no symbolic links, mount the new directory
	// else set environment variable
	EUID_USER();
	int fd = safer_openat(-1, homeusercfg, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	EUID_ROOT();
	if (fd == -1) {
		fwarning("not mounting tmpfs on %s\n", homeusercfg);
		env_store_name_val("PULSE_CLIENTCONFIG", pulsecfg, SETENV);
		goto out;
	}
	// preserve a read-only mount
	struct statvfs vfs;
	if (fstatvfs(fd, &vfs) == -1)
		errExit("fstatvfs");
	if ((vfs.f_flag & MS_RDONLY) == MS_RDONLY)
		fs_remount(RUN_PULSE_DIR, MOUNT_READONLY, 0);
	// mount via the link in /proc/self/fd
	if (arg_debug)
		printf("Mounting %s on %s\n", RUN_PULSE_DIR, homeusercfg);
	if (bind_mount_path_to_fd(RUN_PULSE_DIR, fd))
		errExit("mount pulseaudio");
	// check /proc/self/mountinfo to confirm the mount is ok
	MountData *mptr = get_last_mount();
	if (strcmp(mptr->dir, homeusercfg) != 0 || strcmp(mptr->fstype, "tmpfs") != 0)
		errLogExit("invalid pulseaudio mount");
	fs_logger2("tmpfs", homeusercfg);
	close(fd);

	char *p;
	if (asprintf(&p, "%s/client.conf", homeusercfg) == -1)
		errExit("asprintf");
	env_store_name_val("PULSE_CLIENTCONFIG", p, SETENV);
	fs_logger2("create", p);
	free(p);

	// RUN_PULSE_DIR not needed anymore, mask it
	if (mount("tmpfs", RUN_PULSE_DIR, "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
		errExit("mount pulseaudio");
	fs_logger2("tmpfs", RUN_PULSE_DIR);

out:
	free(pulsecfg);
	free(homeusercfg);
}
