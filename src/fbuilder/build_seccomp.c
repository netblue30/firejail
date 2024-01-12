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

#include "fbuilder.h"

#if 0
void build_seccomp(const char *fname, FILE *fp) {
	assert(fname);
	assert(fp);

	FILE *fp2 = fopen(fname, "r");
	if (!fp2) {
		fprintf(stderr, "Error: cannot open %s\n", fname);
		exit(1);
	}

	char buf[MAX_BUF];
	int line = 1;
	int position = 0;
	int cnt = 0;
	while (fgets(buf, MAX_BUF, fp2)) {
		// remove \n
		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';

		// first line:
		//% time     seconds  usecs/call     calls    errors syscall
		if (line == 1) {
			// extract syscall position
			ptr = strstr(buf, "syscall");
			if (*buf != '%' || ptr == NULL) {
				// skip this line, it could be garbage from strace
				continue;
			}
			position = (int) (ptr - buf);
		}
		else if (line == 2) {
			if (*buf != '-') {
				fprintf(stderr, "Error: invalid strace output\n%s\n", buf);
				exit(1);
			}
		}
		else {
			// get out on the next "----" line
			if (*buf == '-')
				break;

			if (line == 3)
				fprintf(fp, "# seccomp.keep %s", buf + position);
			else
				fprintf(fp, ",%s", buf + position);
			cnt++;
		}
		line++;
	}
	fprintf(fp, "\n");
	fprintf(fp, "# %d syscalls total\n", cnt);
	fprintf(fp, "# Probably you will need to add more syscalls to seccomp.keep. Look for\n");
	fprintf(fp, "# seccomp errors in /var/log/syslog or /var/log/audit/audit.log while\n");
	fprintf(fp, "# running your sandbox.\n");

	fclose(fp2);
}
#endif

//***************************************
// protocol
//***************************************
static int unix_s = 0;
static int inet = 0;
static int inet6 = 0;
static int netlink = 0;
static int packet = 0;
static int bluetooth = 0;
static void process_protocol(const char *fname) {
	assert(fname);

	// process trace file
	FILE *fp = fopen(fname, "r");
	if (!fp) {
		fprintf(stderr, "Error: cannot open %s\n", fname);
		exit(1);
	}

	char buf[MAX_BUF];
	while (fgets(buf, MAX_BUF, fp)) {
		// remove \n
		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';

		// parse line: 4:galculator:access /etc/fonts/conf.d:0
		// number followed by :
		ptr = buf;
		if (!isdigit(*ptr))
			continue;
		while (isdigit(*ptr))
			ptr++;
		if (*ptr != ':')
			continue;
		ptr++;

		// next :
		ptr = strchr(ptr, ':');
		if (!ptr)
			continue;
		ptr++;
		if (strncmp(ptr, "socket ", 7) == 0)
			ptr +=  7;
		else
			continue;

		if (strncmp(ptr, "AF_LOCAL ", 9) == 0)
			unix_s = 1;
		else if (strncmp(ptr, "AF_INET ", 8) == 0)
			inet = 1;
		else if (strncmp(ptr, "AF_INET6 ", 9) == 0)
			inet6 = 1;
		else if (strncmp(ptr, "AF_NETLINK ", 11) == 0)
			netlink = 1;
		else if (strncmp(ptr, "AF_PACKET ", 10) == 0)
			packet = 1;
		else if (strncmp(ptr, "AF_BLUETOOTH ", 13) == 0)
			bluetooth = 1;
	}

	fclose(fp);
}


// process fname, fname.1, fname.2, fname.3, fname.4, fname.5
void build_protocol(const char *fname, FILE *fp) {
	assert(fname);

	// run fname
	process_protocol(fname);

	// run all the rest
	struct stat s;
	int i;
	for (i = 1; i <= 5; i++) {
		char *newname;
		if (asprintf(&newname, "%s.%d", fname, i) == -1)
			errExit("asprintf");
		if (stat(newname, &s) == 0)
			process_protocol(newname);
		free(newname);
	}

	int net = 0;
	if (unix_s || inet || inet6 || netlink || packet || bluetooth) {
		fprintf(fp, "protocol ");
		if (unix_s)
			fprintf(fp, "unix,");
		if (inet || inet6) {
			fprintf(fp, "inet,inet6,");
			net = 1;
		}
		if (netlink)
			fprintf(fp, "netlink,");
		if (packet) {
			fprintf(fp, "packet,");
			net = 1;
		}
		if (bluetooth) {
			fprintf(fp, "bluetooth");
			net = 1;
		}
		fprintf(fp, "\n");
	}

	if (net == 0)
		fprintf(fp, "net none\n");
	else {
		fprintf(fp, "#net eth0\n");
		fprintf(fp, "netfilter\n");
	}
}
