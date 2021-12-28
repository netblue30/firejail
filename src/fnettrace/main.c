/*
 * Copyright (C) 2014-2021 Firejail Authors
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
#include "fnettrace.h"
#define MAX_BUF_SIZE (64 * 1024)

static int arg_netfilter = 0;
static char *arg_log = NULL;

typedef struct hlist_t {
	struct hlist_t *next;
	uint32_t ip_src;
	uint32_t ip_dst;
	uint16_t port_src;
	uint64_t  bytes;
	int instance;
#define MAX_TTL 20 // 20 * DISPLAY_INTERVAL = 1 minute
	short ttl;
	uint8_t protocol;
} HList;

#define HMAX 256
HList *htable[HMAX] = {NULL};
static int htable_empty = 1;

static void hlist_add(uint32_t ip_src, uint32_t ip_dst, uint8_t protocol, uint16_t port_src, uint64_t bytes) {
	uint8_t h = hash(ip_src);
	htable_empty = 0;

	// find
	int instance = 0;
	HList *ptr = htable[h];
	while (ptr) {
		if (ptr->ip_src == ip_src) {
			instance++;
			if (ptr->ip_dst == ip_dst && ptr->port_src == port_src && ptr->protocol == protocol) {
				ptr->bytes += bytes;
				ptr->ttl = MAX_TTL;
				return;
			}
		}
		ptr = ptr->next;
	}

	HList *hnew = malloc(sizeof(HList));
	hnew->ip_src = ip_src;
	hnew->ip_dst = ip_dst;
	hnew->port_src = port_src;
	hnew->protocol = protocol;
	hnew->next = NULL;
	hnew->bytes = bytes;
	hnew->ttl = MAX_TTL;
	hnew->instance = instance + 1;
	if (htable[h] == NULL)
		htable[h] = hnew;
	else {
		hnew->next = htable[h];
		htable[h] = hnew;
	}

	ansi_clrline(1);
	logprintf("  %d%d.%d.%d\n", PRINT_IP(hnew->ip_src));
}

// remove entries with a ttl <= 0
static void hlist_clean_ttl() {
	if (htable_empty)
		return;

	int i;
	for (i = 0; i < HMAX; i++) {
		HList *ptr = htable[i];
		HList *parent = NULL;
		while (ptr) {
			if (--ptr->ttl <= 0) {
				HList *tmp = ptr;
				ptr = ptr->next;
				if (parent)
					parent->next = ptr;
				else
					htable[i] = ptr;
				free(tmp);
			}
			else {
				parent = ptr;
				ptr = ptr->next;
			}
		}
	}
}

static void hlist_print() {
	ansi_clrscr(0);
	if (htable_empty)
		return;
	if (arg_netfilter)
		printf("\n\n");

	int i;
	int cnt = 0;
	int cnt_printed = 0;
	for (i = 0; i < HMAX; i++) {
		HList *ptr = htable[i];
		while (ptr) {
			if (ptr->bytes) {
				cnt_printed++;
				char ip_src[30];
				sprintf(ip_src, "%d.%d.%d.%d:%u", PRINT_IP(ptr->ip_src), ptr->port_src);
				char ip_dst[30];
				sprintf(ip_dst, "%d.%d.%d.%d", PRINT_IP(ptr->ip_dst));
				printf("%-25s =>      %-25s\t%s:",
					ip_src,
					ip_dst,
					(ptr->protocol == 6)? "TCP": "UDP");

				if (ptr->bytes > (DISPLAY_INTERVAL * 1024 * 2)) // > 2 KB/second
					printf(" %lu KB/sec\n",
						ptr->bytes / (DISPLAY_INTERVAL * 1024));
				else
					printf(" %lu B/sec\n",
						ptr->bytes / DISPLAY_INTERVAL);
				ptr->bytes = 0;
			}

			ptr = ptr->next;
			cnt++;
		}
	}

	if (cnt_printed < 7) {
		for (i = 0; i < 7 - cnt_printed; i++)
			printf("\n");
	}

	if (!arg_netfilter) {
		printf("(%d %s in the last one minute)\n", cnt, (cnt == 1)? "stream": "streams");
		hlist_clean_ttl();
	}
}

static void run_trace(void) {
	logprintf("accumulating traffic for %d seconds...\n", NETLOCK_INTERVAL);

	// trace only rx ipv4 tcp and upd
	int s1 = socket(AF_INET, SOCK_RAW, IPPROTO_TCP);
	int s2 = socket(AF_INET, SOCK_RAW, IPPROTO_UDP);
	if (s1 < 0 || s2 < 0)
		errExit("socket");

	unsigned start = time(NULL);
	unsigned last_print_traces = 0;
	unsigned last_print_remaining = 0;
	unsigned char buf[MAX_BUF_SIZE];
	while (1) {
		unsigned end = time(NULL);
		if (arg_netfilter && end - start >= NETLOCK_INTERVAL) {
			ansi_clrline(1);
			break;
		}
		if (end % DISPLAY_INTERVAL == 1 && last_print_traces != end) { // first print after 1 second
			hlist_print();
			last_print_traces = end;
		}
		if (arg_netfilter && last_print_remaining != end) {
			ansi_clrline(1);
			int secs = NETLOCK_INTERVAL - (end  - start);
			logprintf("%d %s remaining   ", secs, (secs == 1)? "second": "seconds");
			last_print_remaining = end;
		}

		fd_set rfds;
		FD_ZERO(&rfds);
		FD_SET(s1, &rfds);
		FD_SET(s2, &rfds);
		int maxfd = (s1 > s2) ? s1 : s2;
		 maxfd++;
		struct timeval tv;
		tv.tv_sec = 1;
		tv.tv_usec = 0;
		int rv = select(maxfd, &rfds, NULL, NULL, &tv);
		if (rv < 0)
			errExit("select");
		else if (rv == 0)
			continue;

		int sock = (FD_ISSET(s1, &rfds)) ? s1 : s2;

		unsigned bytes = recvfrom(sock, buf, MAX_BUF_SIZE, 0, NULL, NULL);
		if (bytes >= 20) { // size of IP header
			// filter out loopback traffic
			if (buf[12] != 127) {
				uint32_t ip_src;
				memcpy(&ip_src, buf + 12, 4);
				ip_src = ntohl(ip_src);

				uint32_t ip_dst;
				memcpy(&ip_dst, buf + 16, 4);
				ip_dst = ntohl(ip_dst);

				uint8_t hlen = (buf[0] & 0x0f) * 4;
				uint16_t port_src;
				memcpy(&port_src, buf + hlen, 2);
				port_src = ntohs(port_src);

				hlist_add(ip_src, ip_dst, buf[9], port_src, (uint64_t) bytes);
			}
		}
	}

	close(s1);
	close(s2);
}

static char *filter_start =
"*filter\n"
":INPUT DROP [0:0]\n"
":FORWARD DROP [0:0]\n"
":OUTPUT DROP [0:0]\n";

// return 1 if error
static int print_filter(FILE *fp) {
	if (htable_empty)
		return 1;
	fprintf(fp, "%s\n", filter_start);
	fprintf(fp, "-A INPUT -s 127.0.0.0/8 -j ACCEPT\n");
	fprintf(fp, "-A OUTPUT -d 127.0.0.0/8 -j ACCEPT\n");
	fprintf(fp, "\n");

	int i;
	for (i = 0; i < HMAX; i++) {
		HList *ptr = htable[i];
		while (ptr) {
			if (ptr->instance == 1) {
				char *protocol = (ptr->protocol == 6)? "tcp": "udp";
				fprintf(fp, "-A INPUT -s %d.%d.%d.%d -sport %u -p %s  -j ACCEPT\n",
					PRINT_IP(ptr->ip_src),
					ptr->port_src,
					protocol);
				fprintf(fp, "-A OUTPUT -d %d.%d.%d.%d -dport %u -p %s  -j ACCEPT\n",
					PRINT_IP(ptr->ip_src),
					ptr->port_src,
					protocol);
				fprintf(fp, "\n");
			}
			ptr = ptr->next;
		}
	}
	fprintf(fp, "COMMIT\n");

	return 0;
}

static char *flush_rules[] = {
	"-P INPUT ACCEPT",
	"-P FORWARD ACCEPT",
	"-P OUTPUT ACCEPT",
	"-F",
	"-X",
	"-t nat -F",
	"-t nat -X",
	"-t mangle -F",
	"-t mangle -X",
	"iptables -t raw -F",
	"-t raw -X",
	NULL
};

static void flush_netfilter(void) {
	// find iptables command
	struct stat s;
	char *iptables = NULL;
	if (stat("/sbin/iptables", &s) == 0)
		iptables = "/sbin/iptables";
	else if (stat("/usr/sbin/iptables", &s) == 0)
		iptables = "/usr/sbin/iptables";
	if (iptables == NULL) {
		fprintf(stderr, "Error: iptables command not found, netfilter not configured\n");
		exit(1);
	}

	int i = 0;
	while (flush_rules[i]) {
		char *cmd;
		if (asprintf(&cmd, "%s %s", iptables, flush_rules[i]) == -1)
			errExit("asprintf");
		int rv = system(cmd);
		(void) rv;
		free(cmd);
		i++;
	}
}

static void deploy_netfilter(void) {
	int rv;
	char *cmd;

	// create temporary file
	char fname[] = "/tmp/firejail-XXXXXX";
	int fd = mkstemp(fname);
	if (fd == -1) {
		fprintf(stderr, "Error: cannot create temporary configuration file\n");
		exit(1);
	}

	FILE* fp = fdopen(fd, "w");
	if (!fp) {
		rv = unlink(fname);
		(void) rv;
		fprintf(stderr, "Error: cannot create temporary configuration file\n");
		exit(1);
	}
	print_filter(fp);
	fclose(fp);

	if (arg_log) {
		logprintf("\n");
		logprintf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
		if (asprintf(&cmd, "cat %s >> %s", fname, arg_log) == -1)
			errExit("asprintf");
		rv = system(cmd);
		(void) rv;
		free(cmd);
		logprintf("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n");
	}

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
		rv = unlink(fname);
		(void) rv;
		exit(1);
	}

	// configuring
	if (asprintf(&cmd, "%s %s", iptables_restore, fname) == -1)
		errExit("asprintf");
	rv = system(cmd);
	if (rv)
		fprintf(stdout, "Warning: possible netfilter problem!");
	free(cmd);

	sleep(1);
	if (asprintf(&cmd, "%s %s", iptables_restore, fname) == -1)
		errExit("asprintf");
	rv = system(cmd);
	free(cmd);

	printf("Current firewall configuration:\n\n");
	if (asprintf(&cmd, "%s -vL -n", iptables) == -1)
		errExit("asprintf");
	rv = system(cmd);

	rv = unlink(fname);
	(void) rv;
	logprintf("\nfirewall deployed\n");
}

void logprintf(char* fmt, ...) {
	if (!arg_log)
		return;

	FILE *fp = fopen(arg_log, "a");
	if (fp) { // disregard if error
		va_list args;
		va_start(args,fmt);
		vfprintf(fp, fmt, args);
		va_end(args);
		fclose(fp);
	}
}

static void usage(void) {
	printf("Usage: fnetlock [OPTIONS]\n");
	printf("Options:\n");
	printf("   --help, -? - this help screen\n");
	printf("   --netfilter - build the firewall rules and commit them.\n");
	printf("   --log=filename - logfile\n");
	printf("\n");
}

int main(int argc, char **argv) {
	int i;
	printf("\n\n");

	if (getuid() != 0) {
		fprintf(stderr, "Error: you need to be root to run this program\n");
		return 1;
	}

	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-?") == 0) {
			usage();
			return 0;
		}
		else if (strcmp(argv[i], "--netfilter") == 0)
			arg_netfilter = 1;
		else if (strncmp(argv[i], "--log=", 6) == 0)
			arg_log = argv[i] + 6;
		else {
			fprintf(stderr, "Error: invalid argument\n");
			return 1;
		}
	}

	if (arg_netfilter) {
		logprintf("starting network lockdown\n");
		flush_netfilter();
	}

	ansi_clrscr(0);
	run_trace();
	if (arg_netfilter) {
		deploy_netfilter();
		sleep(3);
		if (arg_log)
			unlink(arg_log);
	}

	return 0;
}
