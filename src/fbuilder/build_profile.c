/*
 * Copyright (C) 2014-2021 Firejail Authors
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

#define TRACE_OUTPUT "/tmp/firejail-trace.XXXXXX"
#define STRACE_OUTPUT "/tmp/firejail-strace.XXXXXX"

/* static char *cmdlist[] = { */
/* 	"/usr/bin/firejail", */
/* 	"--quiet", */
/* 	"--output=" TRACE_OUTPUT, */
/* 	"--noprofile", */
/* 	"--caps.drop=all", */
/* 	"--nonewprivs", */
/* 	"--trace", */
/* 	"--shell=none", */
/* 	"/usr/bin/strace", // also used as a marker in build_profile() */
/* 	"-c", */
/* 	"-f", */
/* 	"-o" STRACE_OUTPUT, */
/* }; */

void build_profile(int argc, char **argv, int index, FILE *fp) {
	// next index is the application name
	if (index >= argc) {
		fprintf(stderr, "Error: application name missing\n");
		exit(1);
	}

	char trace_output[] = "/tmp/firejail-trace.XXXXXX";
	char strace_output[] = "/tmp/firejail-strace.XXXXXX";

	int tfile = mkstemp(trace_output);
	int stfile = mkstemp(strace_output);
	if(tfile == -1 || stfile == -1)
		errExit("mkstemp");

	// close the files, firejail/strace will overwrite them!
	close(tfile);
	close(stfile);


	char *output;
	char *stroutput;
	if(asprintf(&output,"--trace=%s",trace_output) == -1)
		errExit("asprintf");
	if(asprintf(&stroutput,"-o%s",strace_output) == -1)
		errExit("asprintf");

	char *cmdlist[] = {
	  BINDIR "/firejail",
	  "--quiet",
	  "--noprofile",
	  "--caps.drop=all",
	  "--nonewprivs",
	  output,
	  "--shell=none",
	  "/usr/bin/strace", // also used as a marker in build_profile()
	  "-c",
	  "-f",
	  stroutput,
	};

	// detect strace and check if Yama LSM allows us to use it
	int have_strace = 0;
	int have_yama_permission = 1;
	if (access("/usr/bin/strace", X_OK) == 0) {
		have_strace = 1;
		FILE *ps = fopen("/proc/sys/kernel/yama/ptrace_scope", "r");
		if (ps) {
			unsigned val;
			if (fscanf(ps, "%u", &val) == 1)
				have_yama_permission = (val < 2);
			fclose(ps);
		}
	}

	// calculate command length
	unsigned len = (int) sizeof(cmdlist) / sizeof(char*) + argc - index + 1;
	if (arg_debug)
		printf("command len %d + %d + 1\n", (int) (sizeof(cmdlist) / sizeof(char*)), argc - index);
	char *cmd[len];
	cmd[0] = cmdlist[0];	// explicit assignment to clean scan-build error

	// build command
	// skip strace if not installed, or no permission to use it
	int skip_strace = !(have_strace && have_yama_permission);
	unsigned i = 0;
	for (i = 0; i < (int) sizeof(cmdlist) / sizeof(char*); i++) {
		if (skip_strace && strcmp(cmdlist[i], "/usr/bin/strace") == 0)
			break;
		cmd[i] = cmdlist[i];
	}

	int i2 = index;
	for (; i < (len - 1); i++, i2++)
		cmd[i] = argv[i2];
	assert(i < len);
	cmd[i] = NULL;

	if (arg_debug) {
		for (i = 0; i < len; i++)
			printf("%s%s\n", (i)?"\t":"", cmd[i]);
	}

	// fork and execute
	pid_t child = fork();
	if (child == -1)
		errExit("fork");
	if (child == 0) {
		assert(cmd[0]);
		int rv = execvp(cmd[0], cmd);
		(void) rv;
		errExit("execv");
	}

	// wait for all processes to finish
	int status;
	if (waitpid(child, &status, 0) != child)
		errExit("waitpid");

	if (WIFEXITED(status) && WEXITSTATUS(status) == 0) {
		if (fp == stdout)
			printf("--- Built profile beings after this line ---\n");
		fprintf(fp, "# Firejail profile for %s\n", argv[index]);
		fprintf(fp, "# Persistent local customizations\n");
		fprintf(fp, "#include %s.local\n", argv[index]);
		fprintf(fp, "# Persistent global definitions\n");
		fprintf(fp, "#include globals.local\n");
		fprintf(fp, "\n");

		fprintf(fp, "### basic blacklisting\n");
		fprintf(fp, "include disable-common.inc\n");
		fprintf(fp, "#include disable-devel.inc\n");
		fprintf(fp, "#include disable-exec.inc\n");
		fprintf(fp, "#include disable-interpreters.inc\n");
		fprintf(fp, "include disable-passwdmgr.inc\n");
		fprintf(fp, "#include disable-programs.inc\n");
		fprintf(fp, "#include disable-xdg.inc\n");
		fprintf(fp, "\n");

		fprintf(fp, "### home directory whitelisting\n");
		build_home(trace_output, fp);

		fprintf(fp, "\n### /usr/share:\n");
		build_share(trace_output, fp);
		fprintf(fp, "\n### /var:\n");
		build_var(trace_output, fp);
		fprintf(fp, "\n### /bin:\n");
		build_bin(trace_output, fp);
		fprintf(fp, "\n### /dev:\n");
		build_dev(trace_output, fp);
		fprintf(fp, "\n### /etc:\n");
		build_etc(trace_output, fp);
		fprintf(fp, "\n### /tmp:\n");
		build_tmp(trace_output, fp);

		fprintf(fp, "\n### security filters\n");
		fprintf(fp, "caps.drop all\n");
		fprintf(fp, "nonewprivs\n");
		fprintf(fp, "seccomp\n");
		if (!have_strace) {
			fprintf(fp, "# If you install strace on your system, Firejail will also create a\n");
			fprintf(fp, "# whitelisted seccomp filter.\n");
		}
		else if (!have_yama_permission)
			fprintf(fp, "# Yama security module prevents creation of a whitelisted seccomp filter\n");
		else
			build_seccomp(strace_output, fp);

		fprintf(fp, "\n### network\n");
		build_protocol(trace_output, fp);

		fprintf(fp, "\n### environment\n");
		fprintf(fp, "shell none\n");

		if (!arg_debug) {
			unlink(trace_output);
			unlink(strace_output);
		}
	}
	else {
		fprintf(stderr, "Error: cannot run the sandbox\n");
		exit(1);
	}
}
