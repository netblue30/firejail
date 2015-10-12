/*
 * Copyright (C) 2014, 2015 Firejail Authors
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

static void disable_file(const char *file) {
	assert(file);
	
	struct stat s;
	char *fname;
	if (asprintf(&fname, "/tmp/%s", file) == -1)
		errExit("asprintf");
	if (stat(fname, &s) == -1)
		return;
	if (S_ISDIR(s.st_mode)) {
		if (mount(RO_DIR, fname, "none", MS_BIND, "mode=400,gid=0") < 0)
			errExit("disable file");
	}
	else {
		if (mount(RO_FILE, fname, "none", MS_BIND, "mode=400,gid=0") < 0)
			errExit("disable file");
	}
}

// disable pulseaudio socket
void pulseaudio_disable(void) {
	//**************************************
	// blacklist any pulse* file in /tmp directory
	//**************************************
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
			if (arg_debug)
				printf("Disable %s\n", entry->d_name);
			disable_file(entry->d_name);
		}
	}

	closedir(dir);

	//**************************************
	// blacklist XDG_RUNTIME_DIR
	//**************************************
	char *name = getenv("XDG_RUNTIME_DIR");
	if (name) {
		if (arg_debug)
			printf("Disable %s\n", name);
		disable_file(name);
	}
}


// disable shm in pulseaudio
void pulseaudio_init(void) {
	struct stat s;
	
	// do we have pulseaudio in the system?
	if (stat("/etc/pulse/client.conf", &s) == -1)
		return;

	// crate the new user pulseaudio directory
	char *pulsedir;
	if (asprintf(&pulsedir, "%s/pulse", MNT_DIR) == -1)
		errExit("asprintf");
	int rv = mkdir(pulsedir, S_IRWXU | S_IRWXG | S_IRWXO);
	if (rv == -1)
		errExit("mkdir");
	if (chown(pulsedir, getuid(), getgid()) < 0)
		errExit("chown");
	if (chmod(pulsedir, 0700) < 0)
		errExit("chmod");

	// create the new client.conf file
	char *pulsecfg = NULL;
	if (asprintf(&pulsecfg, "%s/client.conf", pulsedir) == -1)
		errExit("asprintf");
	if (copy_file("/etc/pulse/client.conf", pulsecfg))
		errExit("copy_file");
	FILE *fp = fopen(pulsecfg, "a+");
	if (!fp)
		errExit("fopen");
	fprintf(fp, "\nenable-shm = no\n");
	fclose(fp);
	if (chmod(pulsecfg, 0644) == -1)
		errExit("chmod");
	if (chown(pulsecfg, getuid(), getgid()) == -1)
		errExit("chown");


	// set environment
	if (setenv("PULSE_CLIENTCONFIG", pulsecfg, 1) < 0)
		errExit("setenv");
	

	free(pulsecfg);
	free(pulsedir);		
}
