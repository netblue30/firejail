/*
 * Copyright (C) 2014-2017 netblue30 (netblue30@yahoo.com)
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

// run it as "rvtest 2>/dev/null | grep TESTING"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <signal.h>

#define MAXBUF 1024	// line buffer
#define TIMEOUT 30	// timeout time in seconds

static pid_t pid;
static void catch_alarm(int sig) {
	kill(pid, SIGTERM);
	sleep(1);
	kill(pid, SIGKILL);
	printf("TESTING ERROR: SIGALARM triggered\n");
	exit(1);
}

static void usage(void) {
	printf("Usage: rvtest testfile\n");
	printf("\n");
	printf("Testfile format:\n");
	printf("\tretval command\n");
	printf("\n");
	printf("Testfile example:\n");
	printf("\n");
	printf("0 firejail --net=none exit\n");
	printf("1 firejail --private=/etc sleep 1\n");
	printf("1 firejail --blablabla\n");
}

int main(int argc, char **argv) {
	if (argc != 2) {
		fprintf(stderr, "Error: test file missing\n");
		usage();
		return 1;
	}

	signal (SIGALRM, catch_alarm);

	// open test file
	char *fname = argv[1];
	FILE *fp = fopen(fname, "r");
	
	// read test file
	char buf[MAXBUF];
	int line = 0;
	while (fgets(buf, MAXBUF, fp)) {
		line++;
		// skip blanks
		char *start = buf;
		while (*start == ' ' || *start == '\t')
			start++;
		// remove '\n'
		char *ptr = strchr(start, '\n');
		if (ptr)
			*ptr ='\0';
		if (*start == '\0')
			continue;
		
		// skip comments
		if (*start == '#')
			continue;
		ptr = strchr(start, '#');
		if (ptr)
			*ptr = '\0';
					
		// extract exit status		
		int status;
		int rv = sscanf(start, "%d\n", &status);
		if (rv != 1) {
			fprintf(stderr, "Error: invalid line %d in %s\n", line, fname);
			exit(1);
		}
		
		// extract command
		char *cmd = strchr(start, ' ');
		if (!cmd) {
			fprintf(stderr, "Error: invalid line %d in %s\n", line, fname);
			exit(1);
		}

		// execute command
		printf("TESTING %s\n", cmd);
		fflush(0);
		pid = fork();
		if (pid == -1) {
			perror("fork");
			exit(1);
		}

		// child
		if (pid == 0) {
			char *earg[50];
			earg[0] = "/bin/bash";
			earg[1] = "-c";
			earg[2] = cmd;
			earg[3] = NULL;
			execvp(earg[0], earg);
		}
		// parent
		else {
			int exit_status;
			
			alarm(TIMEOUT);
			pid = waitpid(pid, &exit_status, 0);
			if (pid == -1) {
				perror("waitpid");
				exit(1);
			}
			
			if (WEXITSTATUS(exit_status) != status)
				printf("ERROR TESTING: %s\n", cmd);
		}
		
		fflush(0);
	}
	fclose(fp);
	
	return 0;
}