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
#include <sys/stat.h>

#define MAX_READ 8192				  // line buffer for profile files

static int initialized = 0;
static int cfg_val[CFG_MAX];

int checkcfg(int val) {
	EUID_ASSERT();
	assert(val < CFG_MAX);
	int line = 0;

	if (!initialized) {
		// initialize defaults
		int i;
		for (i = 0; i < CFG_MAX; i++)
			cfg_val[i] = 1; // most of them are enabled by default
		
		// open configuration file
		char *fname;
		if (asprintf(&fname, "%s/firejail.config", SYSCONFDIR) == -1)
			errExit("asprintf");

		FILE *fp = fopen(fname, "r");
		if (!fp) {
			fprintf(stderr, "Error: Firejail configuration file %s not found\n", fname);
			exit(1);
		}
		
		// read configuration file
		char buf[MAX_READ];
		while (fgets(buf,MAX_READ, fp)) {
			line++;
			if (*buf == '#' || *buf == '\n') 
				continue;

			// parse line				
			line_remove_spaces(buf);
			if (strncmp(buf, "file-transfer ", 14) == 0) {
				if (strcmp(buf + 14, "yes") == 0)
					cfg_val[CFG_FILE_TRANSFER] = 1;
				else if (strcmp(buf + 14, "no") == 0)
					cfg_val[CFG_FILE_TRANSFER] = 0;
				else
					goto errout;
			}
			else
				goto errout;
		}

		fclose(fp);
		free(fname);
		initialized = 1;
	}
	
	return cfg_val[val];
	
errout:
	fprintf(stderr, "Error: invalid line %d in firejail configuration file\n", line );
	exit(1);
}

