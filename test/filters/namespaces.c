#define _GNU_SOURCE
#include <errno.h>
#include <linux/sched.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <unistd.h>

#include <sched.h>
#ifndef CLONE_NEWTIME
#define CLONE_NEWTIME 0x00000080
#endif

#include <sys/syscall.h>
#ifndef __NR_clone3
#define __NR_clone3 435
#endif

#define STACK_SIZE 1024 * 1024


static int usage() {
	fprintf(stderr, "Usage: namespaces <system call>[clone,clone3,unshare] <list of namespaces>[cgroup,ipc,mnt,net,pid,time,user,uts]\n");
	exit(1);
}

static void die(const char *msg) {
	fprintf(stderr, "Error: %s: %s\n", msg, strerror(errno));
	exit(1);
}

static int ns_flags(const char *list) {
	int flags = 0;

	char *dup = strdup(list);
	if (!dup)
		die("cannot allocate memory");

	char *token = strtok(dup, ",");
	while (token) {
		if (strcmp(token, "cgroup") == 0)
			flags |= CLONE_NEWCGROUP;
		else if (strcmp(token, "ipc") == 0)
			flags |= CLONE_NEWIPC;
		else if (strcmp(token, "net") == 0)
			flags |= CLONE_NEWNET;
		else if (strcmp(token, "mnt") == 0)
			flags |= CLONE_NEWNS;
		else if (strcmp(token, "pid") == 0)
			flags |= CLONE_NEWPID;
		else if (strcmp(token, "time") == 0)
			flags |= CLONE_NEWTIME;
		else if (strcmp(token, "user") == 0)
			flags |= CLONE_NEWUSER;
		else if (strcmp(token, "uts") == 0)
			flags |= CLONE_NEWUTS;
		else
			usage();

		token = strtok(NULL, ",");
	}

	free(dup);
	return flags;
}

static int child(void *arg) {
	(void) arg;

	fprintf(stderr, "clone successful\n");
	return 0;
}

int main (int argc, char **argv) {
	if (argc != 3)
		usage();

	int flags = ns_flags(argv[2]);

	if (getuid() != 0 && (flags & CLONE_NEWUSER) != CLONE_NEWUSER) {
		fprintf(stderr, "Error: add \"user\" to namespaces list\n");
		exit(1);
	}

	if (strcmp(argv[1], "clone") == 0) {
		void *stack = mmap(NULL, STACK_SIZE, PROT_READ | PROT_WRITE,
		                   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
		if (stack == MAP_FAILED)
			die("mmap");

		pid_t pid = clone(child, stack + STACK_SIZE, flags | SIGCHLD, NULL);
		if (pid < 0)
			die("clone");
		waitpid(pid, NULL, 0);
	}
	else if (strcmp(argv[1], "clone3") == 0) {
		struct clone_args args = {
			.flags = flags,
			.exit_signal = SIGCHLD,
		};

		pid_t pid = syscall(__NR_clone3, &args, sizeof(struct clone_args));
		if (pid < 0)
			die("clone3");
		if (pid == 0) {
			fprintf(stderr, "clone3 successful\n");
			exit(0);
		}
		waitpid(pid, NULL, 0);
	}
	else if (strcmp(argv[1], "unshare") == 0) {
		if (unshare(flags))
			die("unshare");

		fprintf(stderr, "unshare successful\n");
	}
	else
		usage();

	return 0;
}
