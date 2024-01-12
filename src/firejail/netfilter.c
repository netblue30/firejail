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
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>

void netfilter_netlock(pid_t pid) {
	EUID_ASSERT();

	// give the sandbox a chance to start up before entering the network namespace
	sleep(1);
	enter_network_namespace(pid);

	char *flog;
	if (asprintf(&flog, "/run/firejail/network/%d-netlock", getpid()) == -1)
		errExit("asprintf");
	FILE *fp = fopen(flog, "w");
	if (!fp)
		errExit("fopen");
	fclose(fp);

	// try to find a X terminal
	char *terminal = NULL;
	if (access("/usr/bin/xterm", X_OK) == 0)
		terminal = "/usr/bin/xterm";
	else if (access("/usr/bin/lxterminal", X_OK) == 0)
		terminal = "/usr/bin/lxterminal";
	else if (access("/usr/bin/xfce4-terminal", X_OK) == 0)
		terminal = "/usr/bin/xfce4-terminal";
	else if (access("/usr/bin/konsole", X_OK) == 0)
		terminal = "/usr/bin/konsole";
// problem: newer gnome-terminal versions don't support -e command line option???
// same for mate-terminal

	if (isatty(STDIN_FILENO))
		terminal = NULL;

	if (terminal) {
		pid_t p = fork();
		if (p == -1)
			; // run without terminal logger
		else if (p == 0) { // child
			drop_privs(0);
			env_apply_all();
			umask(orig_umask);

			char *cmd;
			if (asprintf(&cmd, "%s -e \"%s/firejail/fnetlock --tail --log=%s\"", terminal, LIBDIR, flog) == -1)
				errExit("asprintf");
			int rv = system(cmd);
			(void) rv;
			exit(0);
		}
	}

	char *cmd;
	if (asprintf(&cmd, "%s/firejail/fnetlock --log=%s", LIBDIR, flog) == -1)
		errExit("asprintf");
	free(flog);

	//************************
	// build command
	//************************
	char *arg[4];
	arg[0] = "/bin/sh";
	arg[1] = "-c";
	arg[2] = cmd;
	arg[3] = NULL;
	clearenv();
	sbox_exec_v(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, arg);
	// it will never get here!!
}

void netfilter_trace(pid_t pid, const char *cmd) {
	EUID_ASSERT();

	// a pid of 0 means the main system network namespace
	if (pid)
		enter_network_namespace(pid);

	//************************
	// build command
	//************************
	char *arg[4];
	arg[0] = "/bin/sh";
	arg[1] = "-c";
	arg[2] = (char *) cmd;
	arg[3] = NULL;

	clearenv();
	sbox_exec_v(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP | SBOX_ALLOW_STDIN, arg);
	// it will never get here!!
}

void check_netfilter_file(const char *fname) {
	EUID_ASSERT();

	char *tmp = strdup(fname);
	if (!tmp)
		errExit("strdup");
	char *ptr = strchr(tmp, ',');
	if (ptr)
		*ptr = '\0';

	invalid_filename(tmp, 0); // no globbing

	if (is_dir(tmp) || is_link(tmp) || strstr(tmp, "..") || access(tmp, R_OK )) {
		fprintf(stderr, "Error: invalid network filter file %s\n", tmp);
		exit(1);
	}
	free(tmp);
}

void netfilter(const char *fname) {
	// find iptables command
	struct stat s;
	char *iptables = NULL;
	char *iptables_restore = NULL;
	if (stat("/sbin/iptables", &s) == 0) {
		iptables = "/sbin/iptables";
		iptables_restore = "/sbin/iptables-restore";
	}
	else if (stat("/usr/sbin/iptables", &s) == 0) {
		iptables = "/usr/sbin/iptables";
		iptables_restore = "/usr/sbin/iptables-restore";
	}
	if (iptables == NULL || iptables_restore == NULL) {
		fprintf(stderr, "Error: iptables command not found, netfilter not configured\n");
		return;
	}

	if (arg_debug)
		printf("Installing firewall\n");

	// create an empty user-owned SBOX_STDIN_FILE
	create_empty_file_as_root(SBOX_STDIN_FILE, 0644);
	if (set_perms(SBOX_STDIN_FILE, getuid(), getgid(), 0644))
		errExit("set_perms");

	if (fname == NULL) {
		if (netfilter_default)
			sbox_run(SBOX_USER| SBOX_CAPS_NONE | SBOX_SECCOMP, 3, PATH_FNETFILTER, netfilter_default, SBOX_STDIN_FILE);
		else
			sbox_run(SBOX_USER| SBOX_CAPS_NONE | SBOX_SECCOMP, 2, PATH_FNETFILTER, SBOX_STDIN_FILE);
	}
	else
		sbox_run(SBOX_USER| SBOX_CAPS_NONE | SBOX_SECCOMP, 3, PATH_FNETFILTER, fname, SBOX_STDIN_FILE);

	// first run of iptables on this platform installs a number of kernel modules such as ip_tables, x_tables, iptable_filter
	// we run this command with caps and seccomp disabled in order to allow the loading of these modules
	sbox_run(SBOX_ROOT | SBOX_STDIN_FROM_FILE, 1, iptables_restore);
	unlink(SBOX_STDIN_FILE);

	// debug
	if (arg_debug)
		sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 2, iptables, "-vL");

	return;
}

void netfilter6(const char *fname) {
	if (fname == NULL)
		return;

	// find iptables command
	char *ip6tables = NULL;
	char *ip6tables_restore = NULL;
	struct stat s;
	if (stat("/sbin/ip6tables", &s) == 0) {
		ip6tables = "/sbin/ip6tables";
		ip6tables_restore = "/sbin/ip6tables-restore";
	}
	else if (stat("/usr/sbin/ip6tables", &s) == 0) {
		ip6tables = "/usr/sbin/ip6tables";
		ip6tables_restore = "/usr/sbin/ip6tables-restore";
	}
	if (ip6tables == NULL || ip6tables_restore == NULL) {
		fprintf(stderr, "Error: ip6tables command not found, netfilter6 not configured\n");
		return;
	}

	if (arg_debug)
		printf("Installing IPv6 firewall\n");

	// create an empty user-owned SBOX_STDIN_FILE
	create_empty_file_as_root(SBOX_STDIN_FILE, 0644);
	if (set_perms(SBOX_STDIN_FILE, getuid(), getgid(), 0644))
		errExit("set_perms");

	sbox_run(SBOX_USER| SBOX_CAPS_NONE | SBOX_SECCOMP, 3, PATH_FNETFILTER, fname, SBOX_STDIN_FILE);

	// first run of iptables on this platform installs a number of kernel modules such as ip_tables, x_tables, iptable_filter
	// we run this command with caps and seccomp disabled in order to allow the loading of these modules
	sbox_run(SBOX_ROOT | SBOX_STDIN_FROM_FILE, 1, ip6tables_restore);
	unlink(SBOX_STDIN_FILE);

	// debug
	if (arg_debug)
		sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 2, ip6tables, "-vL");

	return;
}

void netfilter_print(pid_t pid, int ipv6) {
	EUID_ASSERT();

	enter_network_namespace(pid);

	// find iptables executable
	char *iptables = NULL;
//	char *iptables_restore = NULL;
	struct stat s;
	if (ipv6) {
		if (stat("/sbin/ip6tables", &s) == 0)
			iptables = "/sbin/ip6tables";
		else if (stat("/usr/sbin/ip6tables", &s) == 0)
			iptables = "/usr/sbin/ip6tables";
	}
	else {
		if (stat("/sbin/iptables", &s) == 0)
			iptables = "/sbin/iptables";
		else if (stat("/usr/sbin/iptables", &s) == 0)
			iptables = "/usr/sbin/iptables";
	}

	if (iptables == NULL) {
		fprintf(stderr, "Error: iptables command not found\n");
		exit(1);
	}

	sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 2, iptables, "-nvL");
}
