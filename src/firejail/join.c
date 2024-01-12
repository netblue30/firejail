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
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>
#include <errno.h>

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif

#include <sys/prctl.h>
#ifndef PR_SET_NO_NEW_PRIVS
#define PR_SET_NO_NEW_PRIVS 38
#endif

static int apply_caps = 0;
static uint64_t caps = 0;
static unsigned display = 0;
#define BUFLEN 4096


static void signal_handler(int sig){
	flush_stdin();

	exit(128 + sig);
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

	FILE *fp = fopen(fname, "re");
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
	build_cmdline(&cfg.command_line, &cfg.window_title, argc, argv, index, true);
}

#if 0
static int open_shell(void) {
	EUID_ASSERT();

	if (arg_debug)
		printf("Opening shell %s\n", cfg.usershell);
	// file descriptor will leak if not opened with O_CLOEXEC !!
	int fd = open(cfg.usershell, O_PATH|O_CLOEXEC);
	if (fd == -1) {
		fprintf(stderr, "Error: cannot open shell %s\n", cfg.usershell);
		exit(1);
	}

	// file descriptor needs to reach final fexecve
	if (asprintf(&cfg.keep_fd, "%s,%d", cfg.keep_fd ? cfg.keep_fd : "", fd) == -1)
		errExit("asprintf");

	return fd;
}
#endif

static void extract_nogroups(ProcessHandle sandbox) {
	struct stat s;

	if (process_rootfs_stat(sandbox, RUN_GROUPS_CFG, &s) == 0)
		arg_nogroups = 1;
	else if (errno != ENOENT)
		errExit("stat");
}

static void extract_nonewprivs(ProcessHandle sandbox) {
	struct stat s;

	if (process_rootfs_stat(sandbox, RUN_NONEWPRIVS_CFG, &s) == 0)
		arg_nonewprivs = 1;
	else if (errno != ENOENT)
		errExit("stat");
}

static void extract_caps(ProcessHandle sandbox) {
	// open status file
	FILE *fp = process_fopen(sandbox, "status");

	char buf[BUFLEN];
	while (fgets(buf, BUFLEN, fp)) {
		if (strncmp(buf, "CapBnd:", 7) == 0) {
			unsigned long long val;
			if (sscanf(buf + 7, "%llx", &val) != 1)
				goto errexit;
			apply_caps = 1;
			caps = val;
		}
		else if (strncmp(buf, "NoNewPrivs:", 11) == 0) {
			int val;
			if (sscanf(buf + 11, "%d", &val) != 1)
				goto errexit;
			if (val)
				arg_nonewprivs = 1;
		}
	}
	fclose(fp);
	return;

errexit:
	fprintf(stderr, "Error: cannot read /proc/%d/status\n", process_get_pid(sandbox));
	exit(1);
}

static void extract_user_namespace(ProcessHandle sandbox) {
	// test user namespaces available in the kernel
	struct stat self_userns;
	if (stat("/proc/self/ns/user", &self_userns) != 0)
		return;

	// check sandbox user namespace
	struct stat dest_userns;
	process_stat(sandbox, "ns/user", &dest_userns);

	if (dest_userns.st_ino != self_userns.st_ino ||
	    dest_userns.st_dev != self_userns.st_dev)
		arg_noroot = 1;
}

static void extract_cpu(ProcessHandle sandbox) {
	int fd = process_rootfs_open(sandbox, RUN_CPU_CFG);
	if (fd < 0)
		return; // not configured

	FILE *fp = fdopen(fd, "r");
	if (!fp)
		errExit("fdopen");

	unsigned tmp;
	if (fscanf(fp, "%x", &tmp) == 1)
		cfg.cpus = (uint32_t) tmp;
	fclose(fp);
}

static void extract_umask(ProcessHandle sandbox) {
	int fd = process_rootfs_open(sandbox, RUN_UMASK_FILE);
	if (fd < 0) {
		fprintf(stderr, "Error: cannot open umask file\n");
		exit(1);
	}

	FILE *fp = fdopen(fd, "r");
	if (!fp)
		errExit("fdopen");

	if (fscanf(fp, "%3o", &orig_umask) != 1) {
		fprintf(stderr, "Error: cannot read umask\n");
		exit(1);
	}
	fclose(fp);
}

// returns false if the sandbox is not fully set up yet,
// or true if the sandbox is complete
static bool has_join_file(ProcessHandle sandbox) {
	// check if a file /run/firejail/mnt/join exists
	int fd = process_rootfs_open(sandbox, RUN_JOIN_FILE);
	if (fd == -1)
		return false;
	struct stat s;
	if (fstat(fd, &s) == -1)
		errExit("fstat");
	if (!S_ISREG(s.st_mode) || s.st_uid != 0 || s.st_size != 1) {
		close(fd);
		return false;
	}
	char status;
	if (read(fd, &status, 1) == 1 && status == SANDBOX_DONE) {
		close(fd);
		return true;
	}
	close(fd);
	return false;
}

#define SNOOZE 10000 // sleep interval in microseconds
static void check_joinable(ProcessHandle sandbox) {
	// check if pid belongs to a fully set up firejail sandbox
	unsigned long i;
	for (i = SNOOZE; has_join_file(sandbox) == false; i += SNOOZE) { // give sandbox some time to start up
		if (i > join_timeout) {
			fprintf(stderr, "Error: no valid sandbox\n");
			exit(1);
		}
		usleep(SNOOZE);
	}
}

static ProcessHandle find_pidns_parent(pid_t pid) {
	// identify current pid namespace
	struct stat self_pidns;
	if (stat("/proc/self/ns/pid", &self_pidns) < 0)
		errExit("stat");

	ProcessHandle process = pin_process(pid);

	// in case pid is member of a different pid namespace
	// find parent who created that namespace
	while (1) {
		struct stat dest_pidns;
		process_stat(process, "ns/pid", &dest_pidns);

		if (dest_pidns.st_ino == self_pidns.st_ino &&
		    dest_pidns.st_dev == self_pidns.st_dev)
			break; // always true for init process

		// next parent process
		ProcessHandle next = pin_parent_process(process);
		unpin_process(process);
		process = next;
	}

	return process;
}

static void check_firejail_comm(ProcessHandle process) {
	// open /proc/pid/comm
	// note: comm value is under control of the target process
	FILE *fp = process_fopen(process, "comm");

	char comm[16];
	if (fscanf(fp, "%15s", comm) != 1) {
		fprintf(stderr, "Error: cannot read /proc file\n");
		exit(1);
	}
	fclose(fp);

	if (strcmp(comm, "firejail") != 0) {
		fprintf(stderr, "Error: no valid sandbox\n");
		exit(1);
	}

	return;
}

static void check_firejail_credentials(ProcessHandle process) {
	// open /proc/pid/status
	FILE *fp = process_fopen(process, "status");

	uid_t ruid = -1;
	uid_t suid = -1;
	char buf[4096];
	while (fgets(buf, sizeof(buf), fp)) {
		if (sscanf(buf, "Uid: %u %*u %u", &ruid, &suid) == 2)
			break;
	}
	fclose(fp);

	// target process should be privileged and owned by the user
	if (suid != 0)
		goto errexit;
	uid_t u = getuid();
	if (ruid != u && u != 0)
		goto errexit;

	return;

errexit:
	fprintf(stderr, "Error: no valid sandbox\n");
	exit(1);
}

static pid_t read_sandbox_pidfile(pid_t parent) {
	char *pidfile;
	if (asprintf(&pidfile, "%s/%d", RUN_FIREJAIL_SANDBOX_DIR, parent) == -1)
		errExit("asprintf");

	// open the pidfile
	EUID_ROOT();
	int pidfile_fd = open(pidfile, O_RDWR|O_CLOEXEC);
	free(pidfile);
	EUID_USER();
	if (pidfile_fd < 0)
		goto errexit;

	// assume pidfile is outdated if parent doesn't hold a lock
	struct flock pidfile_lock = {
		.l_type = F_WRLCK,
		.l_whence = SEEK_SET,
		.l_start = 0,
		.l_len = 0,
		.l_pid = 0,
	};
	if (fcntl(pidfile_fd, F_GETLK, &pidfile_lock) < 0)
		errExit("fcntl");
	if (pidfile_lock.l_type == F_UNLCK)
		goto errexit;
	if (pidfile_lock.l_pid != parent)
		goto errexit;

	// read pidfile
	pid_t sandbox;
	FILE *fp = fdopen(pidfile_fd, "r");
	if (!fp)
		errExit("fdopen");
	if (fscanf(fp, "%d", &sandbox) != 1)
		goto errexit;
	fclose(fp);

	return sandbox;

errexit:
	fprintf(stderr, "Error: no valid sandbox\n");
	exit(1);
}

static ProcessHandle switch_to_sandbox(ProcessHandle parent) {
	// firejail forks many children, identify the sandbox child
	// using a pidfile created by the sandbox parent
	pid_t pid = read_sandbox_pidfile(process_get_pid(parent));

	// pin the sandbox child
	fmessage("Switching to pid %d, the first child process inside the sandbox\n", pid);
	ProcessHandle sandbox = pin_child_process(parent, pid);

	return sandbox;
}

ProcessHandle pin_sandbox_process(pid_t pid) {
	EUID_ASSERT();

	ProcessHandle parent = find_pidns_parent(pid);
	check_firejail_comm(parent);
	check_firejail_credentials(parent);

	ProcessHandle sandbox = switch_to_sandbox(parent);
	check_joinable(sandbox);

	unpin_process(parent);
	return sandbox;
}



void join(pid_t pid, int argc, char **argv, int index) {
	EUID_ASSERT();
	ProcessHandle sandbox = pin_sandbox_process(pid);

	extract_x11_display(pid);

	int shfd = -1;
// Note: this might be used by joining appimages!!!!
//	if (!arg_shell_none)
//		shfd = open_shell();

	// in user mode set caps seccomp, cpu etc.
	if (getuid() != 0) {
		extract_nonewprivs(sandbox);  // redundant on Linux >= 4.10; duplicated in function extract_caps
		extract_caps(sandbox);
		extract_cpu(sandbox);
		extract_nogroups(sandbox);
		extract_user_namespace(sandbox);
		extract_umask(sandbox);
	}

	// join namespaces
	EUID_ROOT();
	if (arg_join_network) {
		if (process_join_namespace(sandbox, "net"))
			exit(1);
	}
	else if (arg_join_filesystem) {
		if (process_join_namespace(sandbox, "mnt"))
			exit(1);
	}
	else {
		if (process_join_namespace(sandbox, "ipc") ||
		    process_join_namespace(sandbox, "net") ||
		    process_join_namespace(sandbox, "pid") ||
		    process_join_namespace(sandbox, "uts") ||
		    process_join_namespace(sandbox, "mnt"))
			exit(1);
	}

	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
		// drop discretionary access control capabilities for root sandboxes
		caps_drop_dac_override();

		if (!arg_join_network) {
			// mount namespace doesn't know about --chroot
			fmessage("Changing root to /proc/%d/root\n", process_get_pid(sandbox));
			process_rootfs_chroot(sandbox);

			// load seccomp filters
			if (getuid() != 0)
				seccomp_load_file_list();
		}

		// set caps filter
		if (apply_caps == 1)	// not available for uid 0
			caps_set(caps);

		// user namespace
		if (arg_noroot) {	// not available for uid 0
			if (arg_debug)
				printf("Joining user namespace\n");
			if (process_join_namespace(sandbox, "user"))
				exit(1);

			// user namespace resets capabilities
			// set caps filter
			if (apply_caps == 1)	// not available for uid 0
				caps_set(caps);
		}
		EUID_USER();
		unpin_process(sandbox);

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

		// set nonewprivs
		if (arg_nonewprivs == 1) {
			if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) != 0)
				errExit("prctl");
			if (arg_debug)
				printf("NO_NEW_PRIVS set\n");
		}

		// drop privileges
		drop_privs(arg_nogroups);

		// kill the child in case the parent died
		prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);

		extract_command(argc, argv, index);
		if (cfg.command_line == NULL)
			cfg.window_title = cfg.usershell;
		else if (arg_debug)
			printf("Extracted command #%s#\n", cfg.command_line);

		// set cpu affinity
		if (cfg.cpus)	// not available for uid 0
			set_cpu_affinity();

		// add x11 display
		if (display) {
			char *display_str;
			if (asprintf(&display_str, ":%d", display) == -1)
				errExit("asprintf");
			env_store_name_val("DISPLAY", display_str, SETENV);
			free(display_str);
		}

#ifdef HAVE_DBUSPROXY
		// set D-Bus environment variables
		struct stat s;
		if (stat(RUN_DBUS_USER_SOCKET, &s) == 0)
			dbus_set_session_bus_env();
		if (stat(RUN_DBUS_SYSTEM_SOCKET, &s) == 0)
			dbus_set_system_bus_env();
#endif

		start_application(arg_join_network || arg_join_filesystem, shfd, NULL);

		__builtin_unreachable();
	}
	EUID_USER();
	unpin_process(sandbox);

	if (shfd != -1)
		close(shfd);

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

	if (WIFEXITED(status)) {
		// if we had a proper exit, return that exit status
		status = WEXITSTATUS(status);
	} else if (WIFSIGNALED(status)) {
		// distinguish fatal signals by adding 128
		status = 128 + WTERMSIG(status);
	} else {
		status = -1;
	}

	flush_stdin();
	exit(status);
}
