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
#include "jailcheck.h"
#include "../include/firejail_user.h"
#include "../include/pid.h"
#include <sys/wait.h>

uid_t user_uid = 0;
gid_t user_gid = 0;
char *user_name = NULL;
char *user_home_dir = NULL;
char *user_run_dir = NULL;
int arg_debug = 0;

static const char *const usage_str =
	"Usage: jailcheck [options] directory [directory]\n\n"
	"Options:\n"
	"   --debug - print debug messages.\n"
	"   --help, -? - this help screen.\n"
	"   --version - print program version and exit.\n";

static void print_version(void) {
	printf("jailcheck version %s\n\n", VERSION);
}

static void usage(void) {
	print_version();
	puts(usage_str);
}

static void cleanup(void) {
	// running only as root
	if (getuid() == 0) {
		if (arg_debug)
			printf("cleaning up!\n");
		access_destroy();
		virtual_destroy();
	}
}

int main(int argc, char **argv) {
	int i;
	int findex = 0;

	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "-?") == 0 || strcmp(argv[i], "--help") == 0) {
			usage();
			return 0;
		}
		else if (strcmp(argv[i], "--version") == 0) {
			print_version();
			return 0;
		}
		else if (strncmp(argv[i], "--hello=", 8) == 0) { // used by noexec test
			printf("   Warning: I can run programs in %s\n", argv[i] + 8);
			return 0;
		}
		else if (strcmp(argv[i], "--debug") == 0)
			arg_debug = 1;
		else if (strncmp(argv[i], "--", 2) == 0) {
			fprintf(stderr, "Error: invalid option\n");
			return 1;
		}
		else {
			findex = i;
			break;
		}
	}

	// user setup
	if (getuid() != 0) {
		fprintf(stderr, "Error: you need to be root (via sudo or doas) to run this program\n");
		exit(1);
	}
	user_name = get_sudo_user();
	assert(user_name);
	user_home_dir = get_homedir(user_name, &user_uid, &user_gid);
	if (user_uid == 0) {
		fprintf(stderr, "Error: root user not supported\n");
		exit(1);
	}
	if (asprintf(&user_run_dir, "/run/user/%d", user_uid) == -1)
		errExit("asprintf");

	// test setup
	atexit(cleanup);
	access_setup("~/.ssh");
	access_setup("~/.gnupg");
	if (findex > 0) {
		for (i = findex; i < argc; i++)
			access_setup(argv[i]);
	}

	noexec_setup();
	virtual_setup(user_home_dir);
	virtual_setup("/tmp");
	virtual_setup("/var/tmp");
	virtual_setup("/dev");
	virtual_setup("/etc");
	virtual_setup("/bin");
	virtual_setup("/usr/share");
	virtual_setup(user_run_dir);
	// basic sysfiles
	sysfiles_setup("/etc/shadow");
	sysfiles_setup("/etc/gshadow");
	sysfiles_setup("/usr/bin/doas");
	sysfiles_setup("/usr/bin/mount");
	sysfiles_setup("/usr/bin/su");
	sysfiles_setup("/usr/bin/ksu");
	sysfiles_setup("/usr/bin/sudo");
	sysfiles_setup("/usr/bin/strace");
	// X11
	sysfiles_setup("/usr/bin/xev");
	sysfiles_setup("/usr/bin/xinput");
	// compilers
	sysfiles_setup("/usr/bin/gcc");
	sysfiles_setup("/usr/bin/clang");
	// networking
	sysfiles_setup("/usr/bin/dig");
	sysfiles_setup("/usr/bin/nslookup");
	sysfiles_setup("/usr/bin/resolvectl");
	sysfiles_setup("/usr/bin/nc");
	sysfiles_setup("/usr/bin/ncat");
	sysfiles_setup("/usr/bin/nmap");
	sysfiles_setup("/usr/sbin/tcpdump");
	// terminals
	sysfiles_setup("/usr/bin/gnome-terminal");
	sysfiles_setup("/usr/bin/xfce4-terminal");
	sysfiles_setup("/usr/bin/lxterminal");

	// print processes
	pid_read(0);
	for (i = 0; i < max_pids; i++) {
		if (pids[i].level == 1) {
			uid_t uid = pid_get_uid(i);
			if (uid != user_uid) // not interested in other user sandboxes
				continue;

			// in case the pid is that of a firejail process, use the pid of the first child process
			uid_t pid = find_child(i);
			printf("\n");
			pid_print_list(i, 0); //  no wrapping
			apparmor_test(pid);
			seccomp_test(pid);
			fflush(0);

			// filesystem tests
			pid_t child = fork();
			if (child == -1)
				errExit("fork");
			if (child == 0) {
				int rv = join_namespace(pid, "mnt");
				if (rv == 0) {
					virtual_test();
					noexec_test(user_home_dir);
					noexec_test("/tmp");
					noexec_test("/var/tmp");
					noexec_test(user_run_dir);
					access_test();
					sysfiles_test();
				}
				else {
					printf("   Error: I cannot join the process mount space\n");
					exit(1);
				}

				// drop privileges in order not to trigger cleanup()
				if (setgid(user_gid) != 0)
					errExit("setgid");
				if (setuid(user_uid) != 0)
					errExit("setuid");
				return 0;
			}
			int status;
			wait(&status);

			// network test
			child = fork();
			if (child == -1)
				errExit("fork");
			if (child == 0) {
				int rv = join_namespace(pid, "net");
				if (rv == 0)
					network_test();
				else {
					printf("   Error: I cannot join the process network stack\n");
					exit(1);
				}

				// drop privileges in order not to trigger cleanup()
				if (setgid(user_gid) != 0)
					errExit("setgid");
				if (setuid(user_uid) != 0)
					errExit("setuid");
				return 0;
			}
			wait(&status);
		}
	}

	return 0;
}
