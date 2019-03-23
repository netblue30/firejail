/*
 * Copyright (C) 2014-2019 Firejail Authors
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
#include <sys/wait.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

#include <sys/prctl.h>
#ifndef PR_SET_NO_NEW_PRIVS
# define PR_SET_NO_NEW_PRIVS 38
#endif

static int apply_caps = 0;
static uint64_t caps = 0;
static unsigned display = 0;
#define BUFLEN 4096

static void signal_handler(int sig){
	flush_stdin();

	exit(sig);
}

static void install_handler(void) {
	struct sigaction sga;

	// handle SIGTERM
	sigemptyset(&sga.sa_mask);
	sga.sa_handler = signal_handler;
	sga.sa_flags = 0;
	sigaction(SIGTERM, &sga, NULL);
}

static void extract_x11_display(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "%s/%d", RUN_FIREJAIL_X11_DIR, pid) == -1)
		errExit("asprintf");

	FILE *fp = fopen(fname, "r");
	free(fname);
	if (!fp)
		return;

	if (1 != fscanf(fp, "%u", &display)) {
		fprintf(stderr, "Error: cannot read X11 display file\n");
		fclose(fp);
		return;
	}
	fclose(fp);

	// check display range
	if (display < X11_DISPLAY_START || display > X11_DISPLAY_END) {
		fprintf(stderr, "Error: invalid X11 display range\n");
		return;
	}

	// store the display number for join process in /run/firejail/x11
	EUID_ROOT();
	set_x11_run_file(getpid(), display);
	EUID_USER();
}

static void extract_command(int argc, char **argv, int index) {
	EUID_ASSERT();
	if (index >= argc)
		return;

	// doubledash followed by positional parameters
	if (strcmp(argv[index], "--") == 0) {
		arg_doubledash = 1;
		index++;
		if (index >= argc)
			return;
	}

	// first argv needs to be a valid command
	if (arg_doubledash == 0 && *argv[index] == '-') {
		fprintf(stderr, "Error: invalid option %s after --join\n", argv[index]);
		exit(1);
	}

	// build command
	build_cmdline(&cfg.command_line, &cfg.window_title, argc, argv, index);
}

static void extract_nogroups(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "/proc/%d/root%s", pid, RUN_GROUPS_CFG) == -1)
		errExit("asprintf");

	struct stat s;
	if (stat(fname, &s) == -1) {
		free(fname);
		return;
	}

	arg_nogroups = 1;
	free(fname);
}

static void extract_nonewprivs(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "/proc/%d/root%s", pid, RUN_NONEWPRIVS_CFG) == -1)
		errExit("asprintf");

	struct stat s;
	if (stat(fname, &s) == -1) {
		free(fname);
		return;
	}

	arg_nonewprivs = 1;
	free(fname);
}

static void extract_cpu(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "/proc/%d/root%s", pid, RUN_CPU_CFG) == -1)
		errExit("asprintf");

	struct stat s;
	if (stat(fname, &s) == -1) {
		free(fname);
		return;
	}

	// there is a CPU_CFG file, load it!
	load_cpu(fname);
	free(fname);
}

static void extract_cgroup(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "/proc/%d/root%s", pid, RUN_CGROUP_CFG) == -1)
		errExit("asprintf");

	struct stat s;
	if (stat(fname, &s) == -1) {
		free(fname);
		return;
	}

	// there is a cgroup file CGROUP_CFG, load it!
	load_cgroup(fname);
	free(fname);
}

static void extract_caps(pid_t pid) {
	// open stat file
	char *file;
	if (asprintf(&file, "/proc/%u/status", pid) == -1) {
		perror("asprintf");
		exit(1);
	}
	FILE *fp = fopen(file, "r");
	if (!fp)
		goto errexit;

	char buf[BUFLEN];
	while (fgets(buf, BUFLEN - 1, fp)) {
		if (strncmp(buf, "CapBnd:", 7) == 0) {
			char *ptr = buf + 7;
			unsigned long long val;
			if (sscanf(ptr, "%llx", &val) != 1)
				goto errexit;
			apply_caps = 1;
			caps = val;
		}
		else if (strncmp(buf, "NoNewPrivs:", 11) == 0) {
			char *ptr = buf + 11;
			int val;
			if (sscanf(ptr, "%d", &val) != 1)
				goto errexit;
			if (val)
				arg_nonewprivs = 1;
		}
	}
	fclose(fp);
	free(file);
	return;

errexit:
	fprintf(stderr, "Error: cannot read stat file for process %u\n", pid);
	exit(1);
}

static void extract_user_namespace(pid_t pid) {
	// test user namespaces available in the kernel
	struct stat s1;
	struct stat s2;
	struct stat s3;
	if (stat("/proc/self/ns/user", &s1) == 0 &&
	    stat("/proc/self/uid_map", &s2) == 0 &&
	    stat("/proc/self/gid_map", &s3) == 0);
	else
		return;

	// read uid map
	char *uidmap;
	if (asprintf(&uidmap, "/proc/%u/uid_map", pid) == -1)
		errExit("asprintf");
	FILE *fp = fopen(uidmap, "r");
	if (!fp) {
		free(uidmap);
		return;
	}

	// check uid map
	int u1;
	int u2;
	if (fscanf(fp, "%d %d", &u1, &u2) == 2) {
		if (arg_debug)
			printf("User namespace detected: %s, %d, %d\n", uidmap, u1, u2);
		if (u1 != 0 || u2 != 0)
			arg_noroot = 1;
	}
	fclose(fp);
	free(uidmap);
}

static void extract_umask(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "/proc/%d/root%s", pid, RUN_UMASK_FILE) == -1)
		errExit("asprintf");

	FILE *fp = fopen(fname, "re");
	free(fname);
	if (!fp) {
		fprintf(stderr, "Error: cannot open umask file\n");
		exit(1);
	}
	if (fscanf(fp, "%3o", &orig_umask) < 1) {
		fprintf(stderr, "Error: cannot read umask\n");
		exit(1);
	}
	fclose(fp);
}

pid_t switch_to_child(pid_t pid) {
	EUID_ROOT();
	errno = 0;
	char *comm = pid_proc_comm(pid);
	if (!comm) {
		if (errno == ENOENT) {
			fprintf(stderr, "Error: cannot find process with pid %d\n", pid);
			exit(1);
		}
		else {
			fprintf(stderr, "Error: cannot read /proc file\n");
			exit(1);
		}
	}
	EUID_USER();
	if (strcmp(comm, "firejail") == 0) {
		pid_t child;
		if (find_child(pid, &child) == 1) {
			fprintf(stderr, "Error: no valid sandbox\n");
			exit(1);
		}
		fmessage("Switching to pid %u, the first child process inside the sandbox\n", (unsigned) child);
		pid = child;
	}
	free(comm);
	return pid;
}



void join(pid_t pid, int argc, char **argv, int index) {
	EUID_ASSERT();

	pid_t parent = pid;
	// in case the pid is that of a firejail process, use the pid of the first child process
	pid = switch_to_child(pid);

	// now check if the pid belongs to a firejail sandbox
	if (invalid_sandbox(pid)) {
		fprintf(stderr, "Error: no valid sandbox\n");
		exit(1);
	}

	// check privileges for non-root users
	uid_t uid = getuid();
	if (uid != 0) {
		uid_t sandbox_uid = pid_get_uid(pid);
		if (uid != sandbox_uid) {
			fprintf(stderr, "Error: permission is denied to join a sandbox created by a different user.\n");
			exit(1);
		}
	}

	extract_x11_display(parent);

	EUID_ROOT();
	// in user mode set caps seccomp, cpu, cgroup, etc
	if (getuid() != 0) {
		extract_nonewprivs(pid);  // redundant on Linux >= 4.10; duplicated in function extract_caps
		extract_caps(pid);
		extract_cpu(pid);
		extract_cgroup(pid);
		extract_nogroups(pid);
		extract_user_namespace(pid);
	}

	// set cgroup
	if (cfg.cgroup)	// not available for uid 0
		set_cgroup(cfg.cgroup);

	// set umask, also uid 0
	extract_umask(pid);

	// join namespaces
	if (arg_join_network) {
		if (join_namespace(pid, "net"))
			exit(1);
	}
	else if (arg_join_filesystem) {
		if (join_namespace(pid, "mnt"))
			exit(1);
	}
	else {
		if (join_namespace(pid, "ipc") ||
		    join_namespace(pid, "net") ||
		    join_namespace(pid, "pid") ||
		    join_namespace(pid, "uts") ||
		    join_namespace(pid, "mnt"))
			exit(1);
	}

	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
		// drop discretionary access control capabilities for root sandboxes
		caps_drop_dac_override();

		// chroot into /proc/PID/root directory
		char *rootdir;
		if (asprintf(&rootdir, "/proc/%d/root", pid) == -1)
			errExit("asprintf");

		int rv;
		if (!arg_join_network) {
			rv = chroot(rootdir); // this will fail for processes in sandboxes not started with --chroot option
			if (rv == 0)
				printf("changing root to %s\n", rootdir);
		}

		EUID_USER();
		if (chdir("/") < 0)
			errExit("chdir");
		if (cfg.homedir) {
			struct stat s;
			if (stat(cfg.homedir, &s) == 0) {
				/* coverity[toctou] */
				if (chdir(cfg.homedir) < 0)
					errExit("chdir");
			}
		}

		// set caps filter
		EUID_ROOT();
		if (apply_caps == 1)	// not available for uid 0
			caps_set(caps);
#ifdef HAVE_SECCOMP
		if (getuid() != 0)
			seccomp_load_file_list();
#endif

		// mount user namespace or drop privileges
		if (arg_noroot) {	// not available for uid 0
			if (arg_debug)
				printf("Joining user namespace\n");
			if (join_namespace(1, "user"))
				exit(1);

			// user namespace resets capabilities
			// set caps filter
			if (apply_caps == 1)	// not available for uid 0
				caps_set(caps);
		}

		// set nonewprivs
		if (arg_nonewprivs == 1) {	// not available for uid 0
			int rv = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
			if (arg_debug && rv == 0)
				printf("NO_NEW_PRIVS set\n");
		}

		EUID_USER();
		int cwd = 0;
		if (cfg.cwd) {
			if (chdir(cfg.cwd) == 0)
				cwd = 1;
		}

		if (!cwd) {
			if (chdir("/") < 0)
				errExit("chdir");
			if (cfg.homedir) {
				struct stat s;
				if (stat(cfg.homedir, &s) == 0) {
					/* coverity[toctou] */
					if (chdir(cfg.homedir) < 0)
						errExit("chdir");
				}
			}
		}

		// drop privileges
		drop_privs(arg_nogroups);

		// kill the child in case the parent died
		prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);

		extract_command(argc, argv, index);
		if (cfg.command_line == NULL) {
			assert(cfg.shell);
			cfg.command_line = cfg.shell;
			cfg.window_title = cfg.shell;
		}
		if (arg_debug)
			printf("Extracted command #%s#\n", cfg.command_line);

		// set cpu affinity
		if (cfg.cpus)	// not available for uid 0
			set_cpu_affinity();

		// set nice value
		if (arg_nice)
			set_nice(cfg.nice);

		// add x11 display
		if (display) {
			char *display_str;
			if (asprintf(&display_str, ":%d", display) == -1)
				errExit("asprintf");
			setenv("DISPLAY", display_str, 1);
			free(display_str);
		}

		start_application(0, NULL);

		// it will never get here!!!
	}

	int status = 0;
	//*****************************
	// following code is signal-safe

	install_handler();

	// wait for the child to finish
	waitpid(child, &status, 0);

	// restore default signal action
	signal(SIGTERM, SIG_DFL);

	// end of signal-safe code
	//*****************************
	flush_stdin();

	if (WIFEXITED(status)) {
		status = WEXITSTATUS(status);
	} else if (WIFSIGNALED(status)) {
		status = WTERMSIG(status);
	} else {
		status = 0;
	}

	exit(status);
}
