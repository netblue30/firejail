/*
 * Copyright (C) 2014-2021 Firejail Authors
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

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif

#define PULSE_CLIENT_SYSCONF "/etc/pulse/client.conf"

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

static void pulseaudio_fallback(const char *path) {
	assert(path);

	fmessage("Cannot mount tmpfs on %s/.config/pulse\n", cfg.homedir);
	env_store_name_val("PULSE_CLIENTCONFIG", path, SETENV);
}

// disable shm in pulseaudio (issue #69)
void pulseaudio_init(void) {
	struct stat s;

	// do we have pulseaudio in the system?
	if (stat(PULSE_CLIENT_SYSCONF, &s) == -1) {
		if (arg_debug)
			printf("%s not found\n", PULSE_CLIENT_SYSCONF);
		return;
	}

	// create the new user pulseaudio directory
	if (mkdir(RUN_PULSE_DIR, 0700) == -1)
		errExit("mkdir");
	selinux_relabel_path(RUN_PULSE_DIR, RUN_PULSE_DIR);
	// mount it nosuid, noexec, nodev
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

	// if ~/.config/pulse exists and there are no symbolic links, mount the new directory
	// else set environment variable
	int fd = safe_fd(homeusercfg, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1) {
		pulseaudio_fallback(pulsecfg);
		goto out;
	}
	// confirm the actual mount destination is owned by the user
	if (fstat(fd, &s) == -1) { // FUSE
		if (errno != EACCES)
			errExit("fstat");
		close(fd);
		pulseaudio_fallback(pulsecfg);
		goto out;
	}
	if (s.st_uid != getuid()) {
		close(fd);
		pulseaudio_fallback(pulsecfg);
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
	char *proc;
	if (asprintf(&proc, "/proc/self/fd/%d", fd) == -1)
		errExit("asprintf");
	if (mount(RUN_PULSE_DIR, proc, "none", MS_BIND, NULL) < 0)
		errExit("mount pulseaudio");
	// check /proc/self/mountinfo to confirm the mount is ok
	MountData *mptr = get_last_mount();
	if (strcmp(mptr->dir, homeusercfg) != 0 || strcmp(mptr->fstype, "tmpfs") != 0)
		errLogExit("invalid pulseaudio mount");
	fs_logger2("tmpfs", homeusercfg);
	free(proc);
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
