/*
 * Copyright (C) 2014, 2015 netblue30 (netblue30@yahoo.com)
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
#include <sched.h>

// converts a numeric cpu value in the corresponding bit mask
static void set_cpu(const char *str) {
	if (strlen(str) == 0)
		return;
	
	int val = atoi(str);
	if (val < 0 || val >= 32) {
		fprintf(stderr, "Error: invalid cpu number. Accepted values are between 0 and 31.\n");
		exit(1);
	}
	
	uint32_t mask = 1;
	int i;
	for (i = 0; i < val; i++, mask <<= 1);
	cfg.cpus |= mask;
}

void read_cpu_list(const char *str) {
	char *tmp = strdup(str);
	if (tmp == NULL)
		errExit("strdup");
	
	char *ptr = tmp;
	while (*ptr != '\0') {
		if (*ptr == ',' || isdigit(*ptr))
			;
		else {
			fprintf(stderr, "Error: invalid cpu list\n");
			exit(1);
		}
		ptr++;
	}
	
	char *start = tmp;
	ptr = tmp;
	while (*ptr != '\0') {
		if (*ptr == ',') {
			*ptr = '\0';
			set_cpu(start);
			start = ptr + 1;
		}
		ptr++;
	}
	set_cpu(start);
	free(tmp);
}

void save_cpu(void) {
	if (cfg.cpus == 0)
		return;

	char *fname;
	if (asprintf(&fname, "%s/cpu", MNT_DIR) == -1)
		errExit("asprintf");
	FILE *fp = fopen(fname, "w");
	if (fp) {
		fprintf(fp, "%x\n", cfg.cpus);
		fclose(fp);
		if (chown(fname, 0, 0) < 0)
			errExit("chown");
	}
	else {
		fprintf(stderr, "Error: cannot save cpu affinity mask\n");
		free(fname);
		exit(1);
	}
	
	free(fname);
}

void load_cpu(const char *fname) {
	if (!fname)
		return;

	FILE *fp = fopen(fname, "r");
	if (fp) {
		unsigned tmp;
		int rv = fscanf(fp, "%x", &tmp);
		if (rv)
			cfg.cpus = (uint32_t) tmp;
		fclose(fp);
	}
	else
		fprintf(stderr, "Warning: cannot load cpu affinity mask\n");
}

void set_cpu_affinity(void) {
	// set cpu affinity
	cpu_set_t mask;
	CPU_ZERO(&mask);
	
	int i;
	uint32_t m = 1;
	for (i = 0; i < 32; i++, m <<= 1) {
		if (cfg.cpus & m)
			CPU_SET(i, &mask);
	}
	
        	if (sched_setaffinity(0, sizeof(mask), &mask) == -1) {
        		fprintf(stderr, "Warning: cannot set cpu affinity\n");
        		fprintf(stderr, "  ");
        		perror("sched_setaffinity");
        	}
        	
        	// verify cpu affinity
	cpu_set_t mask2;
	CPU_ZERO(&mask2);
        	if (sched_getaffinity(0, sizeof(mask2), &mask2) == -1) {
        		fprintf(stderr, "Warning: cannot verify cpu affinity\n");
        		fprintf(stderr, "   ");
        		perror("sched_getaffinity");
        	}
        	else {
	        	if (CPU_EQUAL(&mask, &mask2))
        			printf("CPU affinity set\n");
		else
        			printf("CPU affinity not set\n");
        	}
}
