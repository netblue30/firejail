/*
 * Copyright (C) 2014-2018 Firejail Authors
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
#include <sys/mount.h>
#include <dirent.h>
#include <sys/wait.h>

// disable pulseaudio socket
void pulseaudio_disable(void) {
	if (arg_debug)
		printf("disable pulseaudio\n");
	// blacklist user config directory
	disable_file_path(cfg.homedir, ".config/pulse");


	// blacklist pulseaudio socket in XDG_RUNTIME_DIR
	char *name = getenv("XDG_RUNTIME_DIR");
	if (name)
		disable_file_path(name, "pulse/native");

	// try the default location anyway
	char *path;
	if (asprintf(&path, "/run/user/%d", getuid()) == -1)
		errExit("asprintf");
	disable_file_path(path, "pulse/native");
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


// disable shm in pulseaudio
void pulseaudio_init(void) {
	struct stat s;

	// do we have pulseaudio in the system?
	if (stat("/etc/pulse/client.conf", &s) == -1)
		return;

 	// create the new user pulseaudio directory
	int rv = mkdir(RUN_PULSE_DIR, 0700);
	(void) rv; // in --chroot mode the directory can already be there
	if (set_perms(RUN_PULSE_DIR, getuid(), getgid(), 0700))
		errExit("set_perms");

	// create the new client.conf file
	char *pulsecfg = NULL;
	if (asprintf(&pulsecfg, "%s/client.conf", RUN_PULSE_DIR) == -1)
		errExit("asprintf");
	if (copy_file("/etc/pulse/client.conf", pulsecfg, -1, -1, 0644)) // root needed
		errExit("copy_file");
	FILE *fp = fopen(pulsecfg, "a+");
	if (!fp)
		errExit("fopen");
	fprintf(fp, "%s", "\nenable-shm = no\n");
	SET_PERMS_STREAM(fp, getuid(), getgid(), 0644);
	fclose(fp);

	// create ~/.config/pulse directory if not present
	char *dir1;
	if (asprintf(&dir1, "%s/.config", cfg.homedir) == -1)
		errExit("asprintf");
	if (stat(dir1, &s) == -1) {
		pid_t child = fork();
		if (child < 0)
			errExit("fork");
		if (child == 0) {
			// drop privileges
			drop_privs(0);

			int rv = mkdir(dir1, 0755);
			if (rv == 0) {
				if (set_perms(dir1, getuid(), getgid(), 0755))
					{;} // do nothing
			}
#ifdef HAVE_GCOV
			__gcov_flush();
#endif
			_exit(0);
		}
		// wait for the child to finish
		waitpid(child, NULL, 0);
		fs_logger2("create", dir1);
	}
	else {
		// make sure the directory is owned by the user
		if (s.st_uid != getuid()) {
			fprintf(stderr, "Error: user .config directory is not owned by the current user\n");
			exit(1);
		}
	}
	free(dir1);

	if (asprintf(&dir1, "%s/.config/pulse", cfg.homedir) == -1)
		errExit("asprintf");
	if (stat(dir1, &s) == -1) {
		pid_t child = fork();
		if (child < 0)
			errExit("fork");
		if (child == 0) {
			// drop privileges
			drop_privs(0);

			int rv = mkdir(dir1, 0700);
			if (rv == 0) {
				if (set_perms(dir1, getuid(), getgid(), 0700))
					{;} // do nothing
			}
#ifdef HAVE_GCOV
			__gcov_flush();
#endif
			_exit(0);
		}
		// wait for the child to finish
		waitpid(child, NULL, 0);
		fs_logger2("create", dir1);
	}
	else {
		// make sure the directory is owned by the user
		if (s.st_uid != getuid()) {
			fprintf(stderr, "Error: user .config/pulse directory is not owned by the current user\n");
			exit(1);
		}
	}
	free(dir1);

	// if we have ~/.config/pulse mount the new directory, else set environment variable
	char *homeusercfg;
	if (asprintf(&homeusercfg, "%s/.config/pulse", cfg.homedir) == -1)
		errExit("asprintf");
	if (stat(homeusercfg, &s) == 0) {
		if (is_link(homeusercfg)) {
			fprintf(stderr, "Error: user .config/pulse is a symbolic link\n");
			exit(1);
		}
		if (mount(RUN_PULSE_DIR, homeusercfg, "none", MS_BIND, NULL) < 0 ||
		    mount(NULL, homeusercfg, NULL, MS_NOEXEC|MS_NODEV|MS_NOSUID|MS_BIND|MS_REMOUNT, NULL) < 0)
			errExit("mount pulseaudio");
		fs_logger2("tmpfs", homeusercfg);

		// check /proc/self/mountinfo to confirm the mount is ok
		MountData *mptr = get_last_mount();
		if (strcmp(mptr->dir, homeusercfg) != 0)
			errLogExit("invalid pulseaudio mount");
		if (strcmp(mptr->fstype, "tmpfs") != 0)
			errLogExit("invalid pulseaudio mount");

		char *p;
		if (asprintf(&p, "%s/client.conf", homeusercfg) == -1)
			errExit("asprintf");
		fs_logger2("create", p);
		free(p);
	}

	else {
		// set environment
		if (setenv("PULSE_CLIENTCONFIG", pulsecfg, 1) < 0)
			errExit("setenv");
	}

	free(pulsecfg);
	free(homeusercfg);
}
