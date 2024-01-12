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
#include "firejail.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <unistd.h>
#include <grp.h>

#define MAX_BUF 4096

int is_container(const char *str) {
	assert(str);
	if (strcmp(str, "lxc") == 0 ||
	    strcmp(str, "docker") == 0 ||
	    strcmp(str, "lxc-libvirt") == 0 ||
	    strcmp(str, "systemd-nspawn") == 0 ||
	    strcmp(str, "rkt") == 0)
		return 1;
	return 0;
}

// returns 1 if we are running under LXC
int check_namespace_virt(void) {
	EUID_ASSERT();

	// check container environment variable
	const char *str = env_get("container");
	if (str && is_container(str))
		return 1;

	// check PID 1 container environment variable
	EUID_ROOT();
	FILE *fp = fopen("/proc/1/environ", "re");
	EUID_USER();
	if (fp) {
		int c = 0;
		while (c != EOF) {
			// read one line
			char buf[MAX_BUF];
			int i = 0;
			while ((c = fgetc(fp)) != EOF) {
				if (c == 0)
					break;
				buf[i] = (char) c;
				if (++i == (MAX_BUF - 1))
					break;
			}
			buf[i] = '\0';

			// check env var name
			if (strncmp(buf, "container=", 10) == 0) {
				// found it
				if (is_container(buf + 10)) {
					fclose(fp);
					return 1;
				}
			}
//			printf("i %d c %d, buf #%s#\n", i, c, buf);
		}

		fclose(fp);
	}

	return 0;
}

// check process space for kernel processes
// return 1 if found, 0 if not found
int check_kernel_procs(void) {
	// we run this function with EUID set in order to detect grsecurity
	// only user processes are available in /proc when running grsecurity
	// EUID_ASSERT();

	static char *kern_proc[] = {
		"kthreadd",
		"ksoftirqd",
		"kworker",
		"rcu_sched",
		"rcu_bh",
		NULL	// NULL terminated list
	};
	int i;

	if (arg_debug)
		printf("Looking for kernel processes\n");

	// look at the first 10 processes
	// if a kernel process is found, return 1
	for (i = 1; i <= 10; i++) {
		char *fname;
		if (asprintf(&fname, "/proc/%d/comm", i) == -1)
			errExit("asprintf");

		// open file
		FILE *fp = fopen(fname, "re");
		if (!fp) {
			if (errno != ENOENT)
				fwarning("cannot open %s\n", fname);
			free(fname);
			continue;
		}

		// read file
		char buf[100];
		if (fgets(buf, 100, fp) == NULL) {
			fwarning("cannot read %s\n", fname);
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
				if (arg_debug)
					printf("Found %s process, we are not running in a sandbox\n", buf);
				fclose(fp);
				free(fname);
				return 1;
			}
			j++;
		}

		fclose(fp);
		free(fname);
	}

	if (arg_debug)
		printf("No kernel processes found, we are already running in a sandbox\n");

	return 0;
}

void run_no_sandbox(int argc, char **argv) {
	EUID_ASSERT();
	// drop privileges
	if (setresgid(-1, getgid(), getgid()) != 0)
		errExit("setresgid");
	if (setresuid(-1, getuid(), getuid()) != 0)
		errExit("setresuid");

	// process limited subset of options
	// and find first non option arg:
	//	- first argument not starting with --,
	//	- whatever follows after -c (example: firejail -c ls)
	int prog_index = 0;
	int i;
	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "--debug") == 0)
			arg_debug = 1;
		else if (strncmp(argv[i], "--shell=", 8) == 0)
			fwarning("shell-related command line options are disregarded\n");
		else if (strcmp(argv[i], "-c") == 0) {
			prog_index = i + 1;
			if (prog_index == argc) {
				fprintf(stderr, "Error: option -c requires an argument\n");
				exit(1);
			}
			break;
		}
		// check first argument not starting with --
		else if (strncmp(argv[i],"--",2) != 0) {
			prog_index = i;
			break;
		}
	}

	if (prog_index == 0) {
		assert(cfg.command_line == NULL);
		cfg.window_title = cfg.usershell;
	} else {
		// this sandbox might not allow execution of a shell
		build_cmdline(&cfg.command_line, &cfg.window_title, argc, argv, prog_index, true);
	}

	fwarning("an existing sandbox was detected. "
		"%s will run without any additional sandboxing features\n", prog_index ? argv[prog_index] : cfg.usershell);

	cfg.original_argv = argv;
	cfg.original_program_index = prog_index;

	arg_quiet = 1;

	start_application(1, -1, NULL);
}
