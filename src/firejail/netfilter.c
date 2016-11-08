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
	
	if (is_dir(fname) || is_link(fname) || strstr(fname, "..")) {
		fprintf(stderr, "Error: invalid network filter file\n");
		exit(1);
	}

	// access call checks as real UID/GID, not as effective UID/GID
	if (access(fname, R_OK)) {
		fprintf(stderr, "Error: cannot access network filter file\n");
		exit(1);
	}
}


void netfilter(const char *fname) {
	// default filter
	char *filter = client_filter;

	// custom filter
	int allocated = 0;
	if (netfilter_default)
		fname = netfilter_default;
	if (fname) {
		// buffer the filter
		struct stat s;
		if (stat(fname, &s) == -1) {
			fprintf(stderr, "Error: cannot find network filter file %s\n", fname);
			exit(1);
		}

		filter = malloc(s.st_size + 1);	  // + '\0'
		if (!filter)
			errExit("malloc");
		memset(filter, 0, s.st_size + 1);

		/* coverity[toctou] */
		FILE *fp = fopen(fname, "r");
		if (!fp) {
			fprintf(stderr, "Error: cannot open network filter file %s\n", fname);
			exit(1);
		}

		size_t sz = fread(filter, 1, s.st_size, fp);
		if ((off_t)sz != s.st_size) {
			fprintf(stderr, "Error: cannot read network filter file %s\n", fname);
			exit(1);
		}
		fclose(fp);
		allocated = 1;
	}

	// temporarily mount a tempfs on top of /tmp directory
	if (mount("tmpfs", "/tmp", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
		errExit("mounting /tmp");

	// create the filter file
	FILE *fp = fopen("/tmp/netfilter", "w");
	if (!fp) {
		fprintf(stderr, "Error: cannot open /tmp/netfilter file\n");
		exit(1);
	}
	fprintf(fp, "%s\n", filter);
	fclose(fp);

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
		fprintf(stderr, "Error: iptables command not found\n");
		goto doexit;
	}

	// push filter
	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
		if (arg_debug)
			printf("Installing network filter:\n%s\n", filter);

		int fd;
		if((fd = open("/tmp/netfilter", O_RDONLY)) == -1) {
			fprintf(stderr,"Error: cannot open /tmp/netfilter\n");
			exit(1);
		}
		dup2(fd,STDIN_FILENO);

		// wipe out environment variables
		environ = NULL;
		clearenv();
		execl(iptables_restore, iptables_restore, NULL);
		perror("execl");
		_exit(1);
	}
	// wait for the child to finish
	waitpid(child, NULL, 0);

	// debug
	if (arg_debug) {
		child = fork();
		if (child < 0)
			errExit("fork");
		if (child == 0) {
			// elevate privileges in order to get grsecurity working
			if (setreuid(0, 0))
				errExit("setreuid");
			if (setregid(0, 0))
				errExit("setregid");
			environ = NULL;
			execl(iptables, iptables, "-vL", NULL);
			perror("execl");
			_exit(1);
		}
		// wait for the child to finish
		waitpid(child, NULL, 0);
	}

doexit:
	// unmount /tmp
	umount("/tmp");

	if (allocated)
		free(filter);
}

void netfilter6(const char *fname) {
	if (fname == NULL)
		return;
		
	char *filter;

	// buffer the filter
	struct stat s;
	if (stat(fname, &s) == -1) {
		fprintf(stderr, "Error: cannot find network filter file %s\n", fname);
		exit(1);
	}

	filter = malloc(s.st_size + 1);	  // + '\0'
	if (!filter)
		errExit("malloc");
	memset(filter, 0, s.st_size + 1);

	/* coverity[toctou] */
	FILE *fp = fopen(fname, "r");
	if (!fp) {
		fprintf(stderr, "Error: cannot open network filter file %s\n", fname);
		exit(1);
	}

	size_t sz = fread(filter, 1, s.st_size, fp);
	if ((off_t)sz != s.st_size) {
		fprintf(stderr, "Error: cannot read network filter file %s\n", fname);
		exit(1);
	}
	fclose(fp);

	// temporarily mount a tempfs on top of /tmp directory
	if (mount("tmpfs", "/tmp", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
		errExit("mounting /tmp");

	// create the filter file
	fp = fopen("/tmp/netfilter6", "w");
	if (!fp) {
		fprintf(stderr, "Error: cannot open /tmp/netfilter6 file\n");
		exit(1);
	}
	fprintf(fp, "%s\n", filter);
	fclose(fp);

	// find iptables command
	char *ip6tables = NULL;
	char *ip6tables_restore = NULL;
	if (stat("/sbin/ip6tables", &s) == 0) {
		ip6tables = "/sbin/ip6tables";
		ip6tables_restore = "/sbin/ip6tables-restore";
	}
	else if (stat("/usr/sbin/ip6tables", &s) == 0) {
		ip6tables = "/usr/sbin/ip6tables";
		ip6tables_restore = "/usr/sbin/ip6tables-restore";
	}
	if (ip6tables == NULL || ip6tables_restore == NULL) {
		fprintf(stderr, "Error: ip6tables command not found\n");
		goto doexit;
	}

	// push filter
	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
		if (arg_debug)
			printf("Installing network filter:\n%s\n", filter);

		int fd;
		if((fd = open("/tmp/netfilter6", O_RDONLY)) == -1) {
			fprintf(stderr,"Error: cannot open /tmp/netfilter6\n");
			exit(1);
		}
		dup2(fd,STDIN_FILENO);

		// wipe out environment variables
		environ = NULL;
		clearenv();
		execl(ip6tables_restore, ip6tables_restore, NULL);
		perror("execl");
		_exit(1);
	}
	// wait for the child to finish
	waitpid(child, NULL, 0);

	// debug
	if (arg_debug) {
		child = fork();
		if (child < 0)
			errExit("fork");
		if (child == 0) {
			environ = NULL;
			clearenv();
			execl(ip6tables, ip6tables, "-vL", NULL);
			perror("execl");
			_exit(1);
		}
		// wait for the child to finish
		waitpid(child, NULL, 0);
	}

doexit:
	// unmount /tmp
	umount("/tmp");
	free(filter);
}
