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
#include "firejail.h"
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>

static char *client_filter =
"*filter\n"
":INPUT DROP [0:0]\n"
":FORWARD DROP [0:0]\n"
":OUTPUT ACCEPT [0:0]\n"
"-A INPUT -i lo -j ACCEPT\n"
"-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT\n"
"# echo replay is handled by -m state RELATED/ESTABLISHED below\n"
"#-A INPUT -p icmp --icmp-type echo-reply -j ACCEPT\n"
"-A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT\n"
"-A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT\n"
"-A INPUT -p icmp --icmp-type echo-request -j ACCEPT \n"
"# disable STUN\n"
"-A OUTPUT -p udp --dport 3478 -j DROP\n"
"-A OUTPUT -p udp --dport 3479 -j DROP\n"
"-A OUTPUT -p tcp --dport 3478 -j DROP\n"
"-A OUTPUT -p tcp --dport 3479 -j DROP\n"
"COMMIT\n";

void check_netfilter_file(const char *fname) {
	EUID_ASSERT();
	invalid_filename(fname);

	if (is_dir(fname) || is_link(fname) || strstr(fname, "..") || access(fname, R_OK )) {
		fprintf(stderr, "Error: invalid network filter file %s\n", fname);
		exit(1);
	}
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

	// read filter
	char *filter = client_filter;
	int allocated = 0;
	if (netfilter_default)
		fname = netfilter_default;
	if (fname) {
		filter = read_text_file_or_exit(fname);
		allocated = 1;
	}

	// create the filter file
	FILE *fp = fopen(SBOX_STDIN_FILE, "w");
	if (!fp) {
		fprintf(stderr, "Error: cannot open %s\n", SBOX_STDIN_FILE);
		exit(1);
	}
	fprintf(fp, "%s\n", filter);
	fclose(fp);


	// push filter
	if (arg_debug)
		printf("Installing network filter:\n%s\n", filter);

	// first run of iptables on this platform installs a number of kernel modules such as ip_tables, x_tables, iptable_filter
	// we run this command with caps and seccomp disabled in order to allow the loading of these modules
	sbox_run(SBOX_ROOT /* | SBOX_CAPS_NETWORK | SBOX_SECCOMP*/ | SBOX_STDIN_FROM_FILE, 1, iptables_restore);
	unlink(SBOX_STDIN_FILE);

	// debug
	if (arg_debug)
		sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 2, iptables, "-vL");

	if (allocated)
		free(filter);
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

	// create the filter file
	char *filter = read_text_file_or_exit(fname);
	FILE *fp = fopen(SBOX_STDIN_FILE, "w");
	if (!fp) {
		fprintf(stderr, "Error: cannot open %s\n", SBOX_STDIN_FILE);
		exit(1);
	}
	fprintf(fp, "%s\n", filter);
	fclose(fp);

	// push filter
	if (arg_debug)
		printf("Installing network filter:\n%s\n", filter);

	// first run of iptables on this platform installs a number of kernel modules such as ip_tables, x_tables, iptable_filter
	// we run this command with caps and seccomp disabled in order to allow the loading of these modules
	sbox_run(SBOX_ROOT | /* SBOX_CAPS_NETWORK | SBOX_SECCOMP | */ SBOX_STDIN_FROM_FILE, 1, ip6tables_restore);
	unlink(SBOX_STDIN_FILE);

	// debug
	if (arg_debug)
		sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 2, ip6tables, "-vL");

	free(filter);
	return;
}
