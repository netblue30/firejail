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
#include <sys/wait.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/prctl.h>

static int apply_caps = 0;
static uint64_t caps = 0;
static int apply_seccomp = 0;
#define BUFLEN 4096

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


	int len = 0;
	int i;
	// calculate command length
	for (i = index; i < argc; i++) {
		len += strlen(argv[i]) + 1;
	}
	assert(len > 0);

	// build command
	cfg.command_line = malloc(len + 1);
	*cfg.command_line = '\0';
	for (i = index; i < argc; i++) {
		strcat(cfg.command_line, argv[i]);
		strcat(cfg.command_line, " ");
	}
	if (arg_debug)
		printf("Extracted command #%s#\n", cfg.command_line);
}

static void extract_nogroups(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "/proc/%d/root%s", pid, RUN_GROUPS_CFG) == -1)
		errExit("asprintf");
		
	struct stat s;
	if (stat(fname, &s) == -1)
		return;

	arg_nogroups = 1;
	free(fname);
}

static void extract_cpu(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "/proc/%d/root%s", pid, RUN_CPU_CFG) == -1)
		errExit("asprintf");
		
	struct stat s;
	if (stat(fname, &s) == -1)
		return;
	
	// there is a CPU_CFG file, load it!
	load_cpu(fname);
	free(fname);
}

static void extract_cgroup(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "/proc/%d/root%s", pid, RUN_CGROUP_CFG) == -1)
		errExit("asprintf");
		
	struct stat s;
	if (stat(fname, &s) == -1)
		return;
	
	// there is a cgroup file CGROUP_CFG, load it!
	load_cgroup(fname);
	free(fname);
}

static void extract_caps_seccomp(pid_t pid) {
	// open stat file
	char *file;
	if (asprintf(&file, "/proc/%u/status", pid) == -1) {
		perror("asprintf");
		exit(1);
	}
	FILE *fp = fopen(file, "r");
	if (!fp) {
		free(file);
		fprintf(stderr, "Error: cannot open stat file for process %u\n", pid);
		exit(1);
	}

	char buf[BUFLEN];
	while (fgets(buf, BUFLEN - 1, fp)) {
		if (strncmp(buf, "Seccomp:", 8) == 0) {
			char *ptr = buf + 8;
			int val;
			sscanf(ptr, "%d", &val);
			if (val == 2)
				apply_seccomp = 1;
			break;
		}
		else if (strncmp(buf, "CapBnd:", 7) == 0) {		
			char *ptr = buf + 8;
			unsigned long long val;
			sscanf(ptr, "%llx", &val);
			apply_caps = 1;
			caps = val;
		}
	}
	fclose(fp);
	free(file);
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

void join_name(const char *name, int argc, char **argv, int index) {
	EUID_ASSERT();
	if (!name || strlen(name) == 0) {
		fprintf(stderr, "Error: invalid sandbox name\n");
		exit(1);
	}

	pid_t pid;
	if (name2pid(name, &pid)) {
		fprintf(stderr, "Error: cannot find sandbox %s\n", name);
		exit(1);
	}
	join(pid, argc, argv, index);
}

void join(pid_t pid, int argc, char **argv, int index) {
	EUID_ASSERT();
	char *homedir = cfg.homedir;
	
	extract_command(argc, argv, index);

	// if the pid is that of a firejail  process, use the pid of the first child process
	EUID_ROOT();
	char *comm = pid_proc_comm(pid);
	EUID_USER();
	if (comm) {
		if (strcmp(comm, "firejail") == 0) {
			pid_t child;
			if (find_child(pid, &child) == 0) {
				pid = child;
				printf("Switching to pid %u, the first child process inside the sandbox\n", (unsigned) pid);
			}
		}
		free(comm);
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

	EUID_ROOT();
	// in user mode set caps seccomp, cpu, cgroup, etc
	if (getuid() != 0) {
		extract_caps_seccomp(pid);
		extract_cpu(pid);
		extract_cgroup(pid);
		extract_nogroups(pid);
		extract_user_namespace(pid);
	}
	
	// set cgroup
	if (cfg.cgroup)	// not available for uid 0
		set_cgroup(cfg.cgroup);
		
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
		if (join_namespace(pid, "ipc"))
			exit(1);
		if (join_namespace(pid, "net"))
			exit(1);
		if (join_namespace(pid, "pid"))
			exit(1);
		if (join_namespace(pid, "uts"))
			exit(1);
		if (join_namespace(pid, "mnt"))
			exit(1);
	}

	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
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
		
		prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0); // kill the child in case the parent died
		if (chdir("/") < 0)
			errExit("chdir");
		if (homedir) {
			struct stat s;
			if (stat(homedir, &s) == 0) {
				/* coverity[toctou] */
				if (chdir(homedir) < 0)
					errExit("chdir");
			}
		}
		
		// set cpu affinity
		if (cfg.cpus)	// not available for uid 0
			set_cpu_affinity();
					
		// set caps filter
		if (apply_caps == 1)	// not available for uid 0
			caps_set(caps);
#ifdef HAVE_SECCOMP
		// set protocol filter
		if (getuid() != 0)
			protocol_filter_load(RUN_PROTOCOL_CFG);
		if (cfg.protocol) {	// not available for uid 0
			protocol_filter();
		}
				
		// set seccomp filter
		if (apply_seccomp == 1)	// not available for uid 0
			seccomp_set();
		
#endif
		
		// fix qt 4.8
		if (setenv("QT_X11_NO_MITSHM", "1", 1) < 0)
			errExit("setenv");
		if (setenv("container", "firejail", 1) < 0) // LXC sets container=lxc,
			errExit("setenv");

		// mount user namespace or drop privileges
		if (arg_noroot) {	// not available for uid 0
			if (arg_debug)
				printf("Joining user namespace\n");
			if (join_namespace(1, "user"))
				exit(1);
		}
		else 
			drop_privs(arg_nogroups);	// nogroups not available for uid 0

		// set prompt color to green
		//export PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '
		if (setenv("PROMPT_COMMAND", "export PS1=\"\\[\\e[1;32m\\][\\u@\\h \\W]\\$\\[\\e[0m\\] \"", 1) < 0)
			errExit("setenv");

		// run cmdline trough /bin/bash
		if (cfg.command_line == NULL) {
			struct stat s;

			// replace the process with a shell
			if (stat("/bin/bash", &s) == 0)
				execlp("/bin/bash", "/bin/bash", NULL);
			else if (stat("/usr/bin/zsh", &s) == 0)
				execlp("/usr/bin/zsh", "/usr/bin/zsh", NULL);
			else if (stat("/bin/csh", &s) == 0)
				execlp("/bin/csh", "/bin/csh", NULL);
			else if (stat("/bin/sh", &s) == 0)
				execlp("/bin/sh", "/bin/sh", NULL);
			
			// no shell found, print an error and exit
			fprintf(stderr, "Error: no POSIX shell found\n");
			sleep(5);
			exit(1);
		}
		else {
			// run the command supplied by the user
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
						if (chdir(cfg.homedir) < 0)
							errExit("chdir");
					}
				}
			}

			char *arg[5];
			arg[0] = "/bin/bash";
			arg[1] = "-c";
			if (arg_debug)
				printf("Starting %s\n", cfg.command_line);
			if (!arg_doubledash) {
				arg[2] = cfg.command_line;
				arg[3] = NULL;
			}
			else {
				arg[2] = "--";
				arg[3] = cfg.command_line;
				arg[4] = NULL;
			}
			execvp("/bin/bash", arg);
		}

		// it will never get here!!!
	}

	// wait for the child to finish
	waitpid(child, NULL, 0);
	exit(0);
}



