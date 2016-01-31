/*
 * Copyright (C) 2014-2016 Firejail Authors
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

static void disable_file(const char *path, const char *file) {
	assert(file);
	assert(path);
	
	struct stat s;
	char *fname;
	if (asprintf(&fname, "%s/%s", path, file) == -1)
		errExit("asprintf");
	if (stat(fname, &s) == -1)
		goto doexit;
		
	if (arg_debug)
		printf("Disable%s\n", fname);
		
	if (S_ISDIR(s.st_mode)) {
		if (mount(RUN_RO_DIR, fname, "none", MS_BIND, "mode=400,gid=0") < 0)
			errExit("disable file");
	}
	else {
		if (mount(RUN_RO_FILE, fname, "none", MS_BIND, "mode=400,gid=0") < 0)
			errExit("disable file");
	}
	fs_logger2("blacklist", fname);

doexit:
	free(fname);
}

// disable pulseaudio socket
void pulseaudio_disable(void) {
	// blacklist user config directory
	disable_file(cfg.homedir, ".config/pulse");

	// blacklist any pulse* file in /tmp directory
	DIR *dir;
	if (!(dir = opendir("/tmp"))) {
		// sleep 2 seconds and try again
		sleep(2);
		if (!(dir = opendir("/tmp"))) {
			fprintf(stderr, "Warning: cannot open /tmp directory. PulseAudio sockets are not disabled\n");
			return;
		}
	}

	struct dirent *entry;
	while ((entry = readdir(dir))) {
		if (strncmp(entry->d_name, "pulse-", 6) == 0) {
			disable_file("/tmp", entry->d_name);
		}
	}

	closedir(dir);

	// blacklist XDG_RUNTIME_DIR
	char *name = getenv("XDG_RUNTIME_DIR");
	if (name)
		disable_file(name, "pulse/native");
}


// disable shm in pulseaudio
void pulseaudio_init(void) {
	struct stat s;
	
	// do we have pulseaudio in the system?
	if (stat("/etc/pulse/client.conf", &s) == -1)
		return;
	 
 	// create the new user pulseaudio directory
	 fs_build_mnt_dir();
	int rv = mkdir(RUN_PULSE_DIR, 0700);
	(void) rv; // in --chroot mode the directory can already be there
	if (chown(RUN_PULSE_DIR, getuid(), getgid()) < 0)
		errExit("chown");
	if (chmod(RUN_PULSE_DIR, 0700) < 0)
		errExit("chmod");

	// create the new client.conf file
	char *pulsecfg = NULL;
	if (asprintf(&pulsecfg, "%s/client.conf", RUN_PULSE_DIR) == -1)
		errExit("asprintf");
	if (is_link("/etc/pulse/client.conf")) {
		fprintf(stderr, "Error: invalid /etc/pulse/client.conf file\n");
		exit(1);
	}
	if (copy_file("/etc/pulse/client.conf", pulsecfg))
		errExit("copy_file");
	FILE *fp = fopen(pulsecfg, "a+");
	if (!fp)
		errExit("fopen");
	fprintf(fp, "%s", "\nenable-shm = no\n");
	fclose(fp);
	if (chmod(pulsecfg, 0644) == -1)
		errExit("chmod");
	if (chown(pulsecfg, getuid(), getgid()) == -1)
		errExit("chown");

	// set environment
	if (setenv("PULSE_CLIENTCONFIG", pulsecfg, 1) < 0)
		errExit("setenv");
	
	free(pulsecfg);
}
