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
#include "faudit.h"

void pid_test(void) {
	char *kern_proc[] = {
		"kthreadd",
		"ksoftirqd",
		"kworker",
		"rcu_sched",
		"rcu_bh",
		NULL	// NULL terminated list
	};
	int i;

	// look at the first 10 processes
	for (i = 1; i <= 10; i++) { 
		struct stat s;
		char *fname;
		if (asprintf(&fname, "/proc/%d/comm", i) == -1)
			errExit("asprintf");
		if (stat(fname, &s) == -1) {
			free(fname);
			continue;
		}
		
		// open file
		/* coverity[toctou] */
		FILE *fp = fopen(fname, "r");
		if (!fp) {
			fprintf(stderr, "Warning: cannot open %s\n", fname);
			free(fname);
			continue;
		}
		
		// read file
		char buf[100];
		if (fgets(buf, 10, fp) == NULL) {
			fprintf(stderr, "Warning: cannot read %s\n", fname);
			fclose(fp);
			free(fname);
			continue;
		}
		// clean /n
		char *ptr;
		if ((ptr = strchr(buf, '\n')) != NULL)
			*ptr = '\0';
		
		// check process name against the kernel list
		int j = 0;
		while (kern_proc[j] != NULL) {
			if (strncmp(buf, kern_proc[j], strlen(kern_proc[j])) == 0) {
				fclose(fp);
				free(fname);
				printf("BAD: Process PID %d, not running in a PID namespace\n", getpid());
				printf("Are you sure you're running in a sandbox?\n");
				return;
			}
			j++;
		}
		
		fclose(fp);
		free(fname);
	}


	printf("GOOD: process PID %d, running in a PID namespace\n", getpid());
	
	// try to guess the type of container/sandbox
	char *str = getenv("container");
	if (str)
		printf("INFO: container/sandbox %s\n", str);
}
