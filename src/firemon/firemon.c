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
#include "firemon.h"
#include <signal.h>
#include <termios.h>
#include <sys/ioctl.h>
#include <sys/prctl.h>
#include <grp.h>
#include <sys/stat.h>

pid_t skip_process = 0;
int arg_debug = 0;
static int arg_route = 0;
static int arg_arp = 0;
static int arg_tree = 0;
static int arg_seccomp = 0;
static int arg_caps = 0;
static int arg_cpu = 0;
static int arg_x11 = 0;
static int arg_top = 0;
static int arg_list = 0;
static int arg_netstats = 0;
static int arg_apparmor = 0;
int arg_wrap = 0;

static struct termios tlocal;	// startup terminal setting
static struct termios twait;	// no wait on key press
static int terminal_set = 0;

static void my_handler(int s){
	// Remove unused parameter warning
	(void)s;

	if (terminal_set)
		tcsetattr(0, TCSANOW, &tlocal);
	_exit(0);
}

// find the second child process for the specified pid
// return -1 if not found
//
// Example:
//14776:netblue:/usr/bin/firejail /usr/bin/transmission-qt
//  14777:netblue:/usr/bin/firejail /usr/bin/transmission-qt
//    14792:netblue:/usr/bin/transmission-qt
// We need 14792, the first real sandboxed process
int find_child(int id) {
	int i;
	int first_child = -1;

	// find the first child
	for (i = 0; i < max_pids; i++) {
		if (pids[i].level == 2 && pids[i].parent == id) {
			// skip /usr/bin/xdg-dbus-proxy (started by firejail for dbus filtering)
			char *cmdline = pid_proc_cmdline(i);
			if (strncmp(cmdline, XDG_DBUS_PROXY_PATH, strlen(XDG_DBUS_PROXY_PATH)) == 0) {
				free(cmdline);
				continue;
			}
			free(cmdline);
			first_child = i;
			break;
		}
	}

	if (first_child == -1)
		return -1;

	// find the second-level child
	for (i = 0; i < max_pids; i++) {
		if (pids[i].level == 3 && pids[i].parent == first_child)
			return i;
	}

	// if a second child is not found, return the first child pid
	// this happens for processes sandboxed with --join
	return first_child;
}

// sleep and wait for a key to be pressed
void firemon_sleep(int st) {
	if (terminal_set == 0) {
		tcgetattr(0, &twait);          // get current terminal attributes; 0 is the file descriptor for stdin
		memcpy(&tlocal, &twait, sizeof(tlocal));
		twait.c_lflag &= ~ICANON;      // disable canonical mode
		twait.c_lflag &= ~ECHO;	// no echo
		twait.c_cc[VMIN] = 1;          // wait until at least one keystroke available
		twait.c_cc[VTIME] = 0;         // no timeout
		terminal_set = 1;
	}
	tcsetattr(0, TCSANOW, &twait);


	fd_set fds;
	FD_ZERO(&fds);
	FD_SET(0,&fds);
	int maxfd = 1;

	struct timeval ts;
	ts.tv_sec = st;
	ts.tv_usec = 0;

	int ready = select(maxfd, &fds, (fd_set *) 0, (fd_set *) 0, &ts);
	(void) ready;
	if( FD_ISSET(0, &fds)) {
		getchar();
		tcsetattr(0, TCSANOW, &tlocal);
		printf("\n");
		exit(0);
	}
	tcsetattr(0, TCSANOW, &tlocal);
}


int main(int argc, char **argv) {
	unsigned pid = 0;
	int i;

	// handle CTRL-C
	signal (SIGINT, my_handler);
	signal (SIGTERM, my_handler);

	for (i = 1; i < argc; i++) {
		// default options
		if (strcmp(argv[i], "--help") == 0 ||
		    strcmp(argv[i], "-?") == 0) {
			usage();
			return 0;
		}
		else if (strcmp(argv[i], "--version") == 0) {
			print_version();
			return 0;
		}
		else if (strcmp(argv[i], "--debug") == 0)
			arg_debug = 1;
		// options without a pid argument
		else if (strcmp(argv[i], "--top") == 0)
			arg_top = 1;
		else if (strcmp(argv[i], "--list") == 0)
			arg_list = 1;
		else if (strcmp(argv[i], "--tree") == 0)
			arg_tree = 1;
#ifdef HAVE_NETWORK
		else if (strcmp(argv[i], "--netstats") == 0) {
			struct stat s;
			if (getuid() != 0 && stat("/proc/sys/kernel/grsecurity", &s) == 0) {
				fprintf(stderr, "Error: this feature is not available on Grsecurity systems\n");
				exit(1);
			}
			arg_netstats = 1;
		}
#endif

		// cumulative options with or without a pid argument
		else if (strcmp(argv[i], "--x11") == 0)
			arg_x11 = 1;
		else if (strcmp(argv[i], "--cpu") == 0)
			arg_cpu = 1;
		else if (strcmp(argv[i], "--seccomp") == 0)
			arg_seccomp = 1;
		else if (strcmp(argv[i], "--caps") == 0)
			arg_caps = 1;
#ifdef HAVE_NETWORK
		else if (strcmp(argv[i], "--route") == 0)
			arg_route = 1;
		else if (strcmp(argv[i], "--arp") == 0)
			arg_arp = 1;
#endif
		else if (strcmp(argv[i], "--apparmor") == 0)
			arg_apparmor = 1;

		else if (strncmp(argv[i], "--name=", 7) == 0) {
			char *name = argv[i] + 7;
			if (name2pid(name, (pid_t *) &pid)) {
				fprintf(stderr, "Error: cannot find sandbox %s\n", name);
				return 1;
			}
		}

		// etc
		else if (strcmp(argv[i], "--wrap") == 0)
			arg_wrap = 1;

		// invalid option
		else if (*argv[i] == '-') {
			fprintf(stderr, "Error: invalid option\n");
			return 1;
		}

		// PID argument
		else {
			// this should be a pid number
			char *ptr = argv[i];
			while (*ptr != '\0') {
				if (!isdigit(*ptr)) {
					fprintf(stderr, "Error: not a valid PID number\n");
					exit(1);
				}
				ptr++;
			}

			sscanf(argv[i], "%u", &pid);
			break;
		}
	}


	// if the parent is firejail, skip the process
	pid_t ppid = getppid();
	char *pcomm = pid_proc_comm(ppid);
	if (pcomm && strcmp(pcomm, "firejail") == 0)
		skip_process = ppid;

	// allow only root user if /proc is mounted hidepid
	if (pid_hidepid() && getuid() != 0) {
		fprintf(stderr, "Error: /proc is mounted hidepid, you would need to be root to run this command\n");
		exit(1);
	}

	if (arg_top) {
		top();	// print all sandboxes, --name disregarded
		return 0;
	}
	if (arg_list) {
		list();	// print all sandboxes, --name disregarded
		return 0;
	}
	if (arg_netstats) {
		netstats();	// print all sandboxes, --name disregarded
		return 0;
	}
	if (arg_tree) {
		tree(pid);
		return 0;
	}

	// if --name requested without other options, print all data
	if (pid && !arg_cpu && !arg_seccomp && !arg_caps && !arg_apparmor &&
	    !arg_x11  && !arg_route && !arg_arp) {
		arg_tree = 1;
		arg_cpu = 1;
		arg_seccomp = 1;
		arg_caps = 1;
		arg_x11 = 1;
		arg_route = 1;
		arg_arp = 1;
		arg_apparmor = 1;
	}

	// cumulative options
	int print_procs = 1;
	if (arg_cpu) {
		cpu((pid_t) pid, print_procs);
		print_procs = 0;
	}
	if (arg_seccomp) {
		seccomp((pid_t) pid, print_procs);
		print_procs = 0;
	}
	if (arg_caps) {
		caps((pid_t) pid, print_procs);
		print_procs = 0;
	}
	if (arg_apparmor) {
		apparmor((pid_t) pid, print_procs);
		print_procs = 0;
	}
	if (arg_x11) {
		x11((pid_t) pid, print_procs);
		print_procs = 0;
	}
	if (arg_route) {
		route((pid_t) pid, print_procs);
		print_procs = 0;
	}
	if (arg_arp) {
		arp((pid_t) pid, print_procs);
		print_procs = 0;
	}
	(void) print_procs;

	if (getuid() == 0) {
		tree((pid_t) pid);	// pid initialized as zero, will print the tree for all processes if a specific pid was not requested
		procevent((pid_t) pid);
	}

	return 0;
}
