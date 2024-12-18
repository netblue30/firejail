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

#include "firecfg.h"

void sound(void) {
	struct passwd *pw = getpwuid(getuid());
	if (!pw) {
		goto errexit;
	}
	char *home = pw->pw_dir;
	if (!home) {
		goto errexit;
	}

	// the input file is /etc/pulse/client.conf
	FILE *fpin = fopen("/etc/pulse/client.conf", "r");
	if (!fpin) {
		fprintf(stderr, "PulseAudio is not available on this platform, there is nothing to fix...\n");
		return;
	}

	// the dest is PulseAudio user config file
	char *fname;
	if (asprintf(&fname, "%s/.config/pulse/client.conf", home) == -1)
		errExit("asprintf");
	printf("Writing file %s\n", fname);
	FILE *fpout = fopen(fname, "w");
	if (!fpout) {
		perror("fopen");
		goto errexit;
	}
	free(fname);

	// copy default config
	char buf[MAX_BUF];
	while (fgets(buf, MAX_BUF, fpin))
		fputs(buf, fpout);

	// disable shm
	fprintf(fpout, "\nenable-shm = no\n");
	fclose(fpin);
	fclose(fpout);
	printf("PulseAudio configured, please logout and login back again\n");
	return;

errexit:
	fprintf(stderr, "Error: cannot configure sound file\n");
	exit(1);
}
