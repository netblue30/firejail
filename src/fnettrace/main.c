/*
 * Copyright (C) 2014-2022 Firejail Authors
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
#include "radix.h"
#include <sys/ioctl.h>
#define MAX_BUF_SIZE (64 * 1024)

static int arg_netfilter = 0;
static char *arg_log = NULL;

typedef struct hnode_t {
	struct hnode_t *hnext;	// used for hash table
	struct hnode_t *dnext;	// used to display stremas on the screen
	uint32_t ip_src;
	uint32_t ip_dst;
	uint32_t  bytes;	// number of bytes received in the last display interval
	uint16_t port_src;
	uint8_t protocol;
	// the firewall is build based on source address, and in the linked list
	// we have elements with the same address but different ports
	uint8_t ip_instance;
	char *hostname;
	int ttl;
} HNode;

// hash table
#define HMAX 256
HNode *htable[HMAX] = {NULL};
// display linked list
HNode *dlist = NULL;

static unsigned bwmax = 0; // max bytes received in a display interval

static void hnode_add(uint32_t ip_src, uint32_t ip_dst, uint8_t protocol, uint16_t port_src, uint32_t bytes) {
	uint8_t h = hash(ip_src);

	// find
	int ip_instance = 0;
	HNode *ptr = htable[h];
	while (ptr) {
		if (ptr->ip_src == ip_src) {
			ip_instance++;
			if (ptr->ip_dst == ip_dst && ptr->port_src == port_src && ptr->protocol == protocol) {
				ptr->bytes += bytes;
				return;
			}
		}
		ptr = ptr->hnext;
	}

#ifdef DEBUG
	printf("malloc %d.%d.%d.%d\n", PRINT_IP(ip_src));
#endif
	HNode *hnew = malloc(sizeof(HNode));
	if (!hnew)
		errExit("malloc");
	hnew->hostname = NULL;
	hnew->ip_src = ip_src;
	hnew->ip_dst = ip_dst;
	hnew->port_src = port_src;
	hnew->protocol = protocol;
	hnew->hnext = NULL;
	hnew->bytes = bytes;
	hnew->ip_instance = ip_instance + 1;
	hnew->ttl = DISPLAY_TTL;
	if (htable[h] == NULL)
		htable[h] = hnew;
	else {
		hnew->hnext = htable[h];
		htable[h] = hnew;
	}

	// add to the end of list
	hnew->dnext = NULL;
	if (dlist == NULL)
		dlist = hnew;
	else {
		ptr = dlist;
		while (ptr->dnext != NULL)
			ptr = ptr->dnext;
		ptr->dnext = hnew;
	}

	if (arg_netfilter)
		logprintf(" %d.%d.%d.%d ", PRINT_IP(hnew->ip_src));
}

static void hnode_free(HNode *elem) {
	assert(elem);
#ifdef DEBUG
	printf("free %d.%d.%d.%d\n", PRINT_IP(elem->ip_src));
#endif

	uint8_t h = hash(elem->ip_src);
	HNode *ptr = htable[h];
	assert(ptr);

	HNode *prev = NULL;
	while (ptr != elem) {
		prev = ptr;
		ptr = ptr->hnext;
	}
	if (prev == NULL)
		htable[h] = elem->hnext;
	else
		prev->hnext = elem->hnext;
	free(elem);
}

#ifdef DEBUG
static void debug_dlist(void) {
	HNode *ptr = dlist;
	while (ptr) {
		printf("dlist %d.%d.%d.%d:%d\n", PRINT_IP(ptr->ip_src), ptr->port_src);
		ptr = ptr->dnext;
	}
}
static void debug_hnode(void) {
	int i;
	for (i = 0; i < HMAX; i++) {
		HNode *ptr = htable[i];
		while (ptr) {
			printf("hnode (%d) %d.%d.%d.%d:%d\n", i, PRINT_IP(ptr->ip_src), ptr->port_src);
			ptr = ptr->hnext;
		}
	}
}
#endif

static char *bw_line[DISPLAY_BW_UNITS + 1] = { NULL };

static char *print_bw(unsigned units) {
	if (units > DISPLAY_BW_UNITS)
		units = DISPLAY_BW_UNITS ;

	if (bw_line[units] == NULL) {
		char *ptr = malloc(DISPLAY_BW_UNITS + 1);
		if (!ptr)
			errExit("malloc");
		bw_line[units] = ptr;

		unsigned i;
		for (i = 0; i < DISPLAY_BW_UNITS; i++, ptr++)
			sprintf(ptr, "%s", (i < units)? "*": " ");
	}

	return bw_line[units];
}

static void hnode_print(void) {
	assert(!arg_netfilter);
	ansi_clrscr();

#ifdef DEBUG
	printf("*********************\n");
	debug_dlist();
	printf("-----------------------------\n");
	debug_hnode();
	printf("*********************\n");
#endif

	// get terminal size
	struct winsize sz;
	int col = 80;
	if (isatty(STDIN_FILENO)) {
		if (!ioctl(0, TIOCGWINSZ, &sz))
			col  = sz.ws_col;
	}
#define LINE_MAX 200
	char line[LINE_MAX + 1];
	if (col > LINE_MAX)
		col = LINE_MAX;

	HNode *ptr = dlist;
	HNode *prev = NULL;
	while (ptr) {
		HNode *next = ptr->dnext;
		if (--ptr->ttl > 0) {
			char bytes[11];
			if (ptr->bytes > (DISPLAY_INTERVAL * 1024 * 1024 * 2)) // > 2 MB/second
				sprintf(bytes, "%u MB/s",
					(unsigned) (ptr->bytes / (DISPLAY_INTERVAL * 1024* 1024)));
			else if (ptr->bytes > (DISPLAY_INTERVAL * 1024 * 2)) // > 2 KB/second
				sprintf(bytes, "%u KB/s",
					(unsigned) (ptr->bytes / (DISPLAY_INTERVAL * 1024)));
			else
				sprintf(bytes, "%u B/s", (unsigned) (ptr->bytes / DISPLAY_INTERVAL));

			char *hostname = ptr->hostname;
			if (!hostname)
				hostname = radix_find_last(ptr->ip_src);

			if (!hostname)
				hostname = retrieve_hostname(ptr->ip_src);

			if (!hostname)
				hostname = " ";
			else {
				ptr->hostname = strdup(hostname);
				if (!ptr->hostname)
					errExit("strdup");
			}

			unsigned bwunit = bwmax / DISPLAY_BW_UNITS;
			unsigned units = ptr->bytes / bwunit;
			char *bwline = print_bw(units);

			sprintf(line, "%10s %s %d.%d.%d.%d:%u %s\n", bytes, bwline, PRINT_IP(ptr->ip_src), ptr->port_src, hostname);
			int len = strlen(line);
			if (col > 4 && len > col) {
				line[col] = '\0';
				line[col - 1] = '\n';
			}
			printf("%s", line);

			if (ptr->bytes)
				ptr->ttl = DISPLAY_TTL;
			ptr->bytes = 0;
			prev = ptr;
		}
		else {
			// free the element
			if (prev == NULL)
				dlist = next;
			else
				prev->dnext = next;
			hnode_free(ptr);
		}

		ptr = next;
	}
}

static void run_trace(void) {
	if (arg_netfilter)
		logprintf("accumulating traffic for %d seconds\n", NETLOCK_INTERVAL);

	// trace only rx ipv4 tcp and upd
	int s1 = socket(AF_INET, SOCK_RAW, IPPROTO_TCP);
	int s2 = socket(AF_INET, SOCK_RAW, IPPROTO_UDP);
	if (s1 < 0 || s2 < 0)
		errExit("socket");

	unsigned start = time(NULL);
	unsigned last_print_traces = 0;
	unsigned last_print_remaining = 0;
	unsigned char buf[MAX_BUF_SIZE];
	unsigned bwcurrent = 0;
	while (1) {
		unsigned end = time(NULL);
		if (arg_netfilter && end - start >= NETLOCK_INTERVAL)
			break;
		if (end % DISPLAY_INTERVAL == 1 && last_print_traces != end) { // first print after 1 second
			if (bwcurrent > bwmax)
				bwmax = bwcurrent;
			if (!arg_netfilter)
				hnode_print();
			last_print_traces = end;
			bwcurrent = 0;
		}
		if (arg_netfilter && last_print_remaining != end) {
			logprintf(".");
			fflush(0);
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
			bwcurrent += bytes + 14; // assume a 14 byte Ethernet layer
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

				hnode_add(ip_src, ip_dst, buf[9], port_src, bytes + 14);
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
	if (dlist == NULL)
		return 1;
	fprintf(fp, "%s\n", filter_start);
	fprintf(fp, "-A INPUT -s 127.0.0.0/8 -j ACCEPT\n");
	fprintf(fp, "-A OUTPUT -d 127.0.0.0/8 -j ACCEPT\n");
	fprintf(fp, "\n");

	int i;
	for (i = 0; i < HMAX; i++) {
		HNode *ptr = htable[i];
		while (ptr) {
			// filter rules are targeting ip address, the port number is disregarded,
			// so we look only at the first instance of an address
			if (ptr->ip_instance == 1) {
				char *protocol = (ptr->protocol == 6)? "tcp": "udp";
				fprintf(fp, "-A INPUT -s %d.%d.%d.%d -p %s  -j ACCEPT\n",
					PRINT_IP(ptr->ip_src),
					protocol);
				fprintf(fp, "-A OUTPUT -d %d.%d.%d.%d -p %s  -j ACCEPT\n",
					PRINT_IP(ptr->ip_src),
					protocol);
				fprintf(fp, "\n");
			}
			ptr = ptr->hnext;
		}
	}
	fprintf(fp, "COMMIT\n");

	return 0;
}

static char *flush_rules[] = {
	"-P INPUT ACCEPT",
//	"-P FORWARD DENY",
	"-P OUTPUT ACCEPT",
	"-F",
	"-X",
//	"-t nat -F",
//	"-t nat -X",
//	"-t mangle -F",
//	"-t mangle -X",
//	"iptables -t raw -F",
//	"-t raw -X",
	NULL
};

static void deploy_netfilter(void) {
	int rv;
	char *cmd;
	int i;

	if (dlist == NULL) {
		logprintf("Sorry, no network traffic was detected. The firewall was not configured.\n");
		return;
	}
	// find iptables command
	char *iptables = NULL;
	char *iptables_restore = NULL;
	if (access("/sbin/iptables", X_OK) == 0) {
		iptables = "/sbin/iptables";
		iptables_restore = "/sbin/iptables-restore";
	}
	else if (access("/usr/sbin/iptables", X_OK) == 0) {
		iptables = "/usr/sbin/iptables";
		iptables_restore = "/usr/sbin/iptables-restore";
	}
	if (iptables == NULL || iptables_restore == NULL) {
		fprintf(stderr, "Error: iptables command not found, netfilter not configured\n");
		exit(1);
	}

	// flush all netfilter rules
	i = 0;
	while (flush_rules[i]) {
		char *cmd;
		if (asprintf(&cmd, "%s %s", iptables, flush_rules[i]) == -1)
			errExit("asprintf");
		int rv = system(cmd);
		(void) rv;
		free(cmd);
		i++;
	}

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

	logprintf("\n\n");
	logprintf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
	if (asprintf(&cmd, "cat %s >> %s", fname, arg_log) == -1)
		errExit("asprintf");
	rv = system(cmd);
	(void) rv;
	free(cmd);

	if (asprintf(&cmd, "cat %s", fname) == -1)
		errExit("asprintf");
	rv = system(cmd);
	(void) rv;
	free(cmd);
	logprintf("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n");

	// configuring
	if (asprintf(&cmd, "%s %s", iptables_restore, fname) == -1)
		errExit("asprintf");
	rv = system(cmd);
	if (rv)
		fprintf(stdout, "Warning: possible netfilter problem!");
	free(cmd);

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

	va_list args;
	va_start(args,fmt);
	vfprintf(stdout, fmt, args);
	va_end(args);
}

static void usage(void) {
	printf("Usage: fnetlock [OPTIONS]\n");
	printf("Options:\n");
	printf("   --build=filename - compact list of addresses\n");
	printf("   --help, -? - this help screen\n");
	printf("   --netfilter - build the firewall rules and commit them.\n");
	printf("   --log=filename - logfile\n");
	printf("\n");
}

int main(int argc, char **argv) {
	int i;

#ifdef DEBUG
	// radix test
	radix_add(0x09000000, 0xff000000, "IBM");
	radix_add(0x09090909, 0xffffffff, "Quad9 DNS");
	radix_add(0x09000000, 0xff000000, "IBM");
	radix_print();
	printf("This test should print \"IBM, Quad9 DNS, IBM\"\n");
	char *name = radix_find_first(0x09090909);
	printf("%s, ", name);
	name = radix_find_last(0x09090909);
	printf("%s, ", name);
	name = radix_find_last(0x09322209);
	printf("%s\n", name);
#endif

	if (argc == 2 && strncmp(argv[1], "--build=", 8) == 0) {
		build_list(argv[1] + 8);
		return 0;
	}

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

	ansi_clrscr();
	if (arg_netfilter)
		logprintf("starting network lockdown\n");
	else  {
		char *fname;
		if (asprintf(&fname, "%s/hostnames", SYSCONFDIR) == -1)
			errExit("asprintf");
		load_hostnames(fname);
		free(fname);
	}

	run_trace();
	if (arg_netfilter) {
		deploy_netfilter();
		sleep(3);
		if (arg_log)
			unlink(arg_log);
	}

	return 0;
}
