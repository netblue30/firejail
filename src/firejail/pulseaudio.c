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

// disable shm in pulse audio
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
