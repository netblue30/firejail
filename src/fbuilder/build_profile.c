/*
 * Copyright (C) 2014-2017 Firejail Authors
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

#include "fbuilder.h"
#include <sys/wait.h>
#include <fcntl.h>

#define TRACE_OUTPUT "/tmp/firejail-trace"
#define STRACE_OUTPUT "/tmp/firejail-strace"

static char *cmdlist[] = {
	"/usr/bin/firejail",
	"--quiet",
	"--output=" TRACE_OUTPUT,
	"--noprofile",
	"--caps.drop=all",
	"--nonewprivs",
	"--trace",
	"--shell=none",
	"/usr/bin/strace", // also used as a marker in build_profile()
	"-c",
	"-f",
	"-o" STRACE_OUTPUT,
};

static void clear_tmp_files(void) {
	unlink(STRACE_OUTPUT);
	unlink(TRACE_OUTPUT);
	
	// run all the rest
	int i;
	for (i = 1; i <= 5; i++) {
		char *newname;
		if (asprintf(&newname, "%s.%d", TRACE_OUTPUT, i) == -1)
			errExit("asprintf");
		unlink(newname);
		free(newname);
	}

}

void build_profile(int argc, char **argv, int index) {
	// next index is the application name
	if (index >= argc) {
		fprintf(stderr, "Error: application name missing\n");
		exit(1);
	}
	
	// clean /tmp files
	clear_tmp_files();
	
	// detect strace
	int have_strace = 0;
	if (access("/usr/bin/strace", X_OK) == 0)
		have_strace = 1;
	
	// calculate command length
	int len = (int) sizeof(cmdlist) / sizeof(char*) + argc - index + 1;
	if (arg_debug)
		printf("command len %d + %d + 1\n", (int) (sizeof(cmdlist) / sizeof(char*)), argc - index);
	char *cmd[len]; 
	
	// build command
	int i = 0;
	for (i = 0; i < (int) sizeof(cmdlist) / sizeof(char*); i++) {
		// skip strace if not installed
		if (have_strace == 0 && strcmp(cmdlist[i], "/usr/bin/strace") == 0)
			break;
		cmd[i] = cmdlist[i];
	}

	int i2 = index;
	for (; i < (len - 1); i++, i2++)
		cmd[i] = argv[i2];
	cmd[i] = NULL;

	if (arg_debug) {
		for (i = 0; i < len; i++)
			printf("\t%s\n", cmd[i]);
	}
	
	// fork and execute
	pid_t child = fork();
	if (child == -1)
		errExit("fork");
	if (child == 0) {
		int rv = execvp(cmd[0], cmd);
		errExit("execv");
	}
	
	// wait for all processes to finish
	int status;
	if (waitpid(child, &status, 0) != child)
		errExit("waitpid");

	if (WIFEXITED(status) && WEXITSTATUS(status) == 0) {
		printf("\n\n\n");
		printf("############################################\n");
		printf("# %s profile\n", argv[index]);
		printf("############################################\n");
		printf("# Persistent global definitions\n");
		printf("# include /etc/firejail/globals.local\n");
		printf("\n");
		
		printf("### basic blacklisting\n");
		printf("include /etc/firejail/disable-common.inc\n");
		printf("# include /etc/firejail/disable-devel.inc\n");
		printf("include /etc/firejail/disable-passwdmgr.inc\n");
		printf("# include /etc/firejail/disable-programs.inc\n");
		printf("\n");
		
		printf("### home directory whitelisting\n");
		build_home(TRACE_OUTPUT);
		printf("\n");
		
		printf("### filesystem\n");
		build_tmp(TRACE_OUTPUT);
		build_dev(TRACE_OUTPUT);
		build_etc(TRACE_OUTPUT);
		build_var(TRACE_OUTPUT);
		build_bin(TRACE_OUTPUT);
		printf("\n");

		printf("### security filters\n");
		printf("caps.drop all\n");
		printf("nonewprivs\n");
		printf("seccomp\n");
		if (have_strace)
			build_seccomp(STRACE_OUTPUT);
		else {
			printf("# If you install strace on your system, Firejail will also create a\n");
			printf("# whitelisted seccomp filter.\n");
		}
		printf("\n");

		printf("### network\n");
		build_protocol(TRACE_OUTPUT);
		printf("\n");
		
		printf("### environment\n");
		printf("shell none\n");

	}
	else {
		fprintf(stderr, "Error: cannot run the sandbox\n");
		exit(1);
	}
}
