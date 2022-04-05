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
static int arg_tail = 0;
static char *arg_log = NULL;

typedef struct hnode_t {
	struct hnode_t *hnext;	// used for hash table and unused linked list
	struct hnode_t *dnext;	// used to display streams on the screen
	uint32_t ip_src;
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


// speed up malloc/free
#define HNODE_MAX_MALLOC 16
static HNode *hnode_unused = NULL;
HNode *hmalloc(void) {
	if (hnode_unused == NULL) {
		hnode_unused = malloc(sizeof(HNode) * HNODE_MAX_MALLOC);
		if (!hnode_unused)
			errExit("malloc");
		memset(hnode_unused, 0, sizeof(HNode) * HNODE_MAX_MALLOC);
		HNode *ptr = hnode_unused;
		int i;
		for ( i = 1; i < HNODE_MAX_MALLOC; i++, ptr++)
			ptr->hnext = hnode_unused + i;
	}

	HNode *rv = hnode_unused;
	hnode_unused = hnode_unused->hnext;
	return rv;
}

void hfree(HNode *ptr) {
	assert(ptr);
	memset(ptr, 0, sizeof(HNode));
	ptr->hnext = hnode_unused;
	hnode_unused = ptr;
}


static void hnode_add(uint32_t ip_src, uint8_t protocol, uint16_t port_src, uint32_t bytes) {
	uint8_t h = hash(ip_src);

	// find
	int ip_instance = 0;
	HNode *ptr = htable[h];
	while (ptr) {
		if (ptr->ip_src == ip_src) {
			ip_instance++;
			if (ptr->port_src == port_src && ptr->protocol == protocol) {
				ptr->bytes += bytes;
				return;
			}
		}
		ptr = ptr->hnext;
	}

#ifdef DEBUG
	printf("malloc %d.%d.%d.%d\n", PRINT_IP(ip_src));
#endif
	HNode *hnew = hmalloc();
	assert(hnew);
	hnew->hostname = NULL;
	hnew->ip_src = ip_src;
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
	hfree(elem);
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
		char *ptr = malloc(DISPLAY_BW_UNITS + 2);
		if (!ptr)
			errExit("malloc");
		bw_line[units] = ptr;

		unsigned i;
		for (i = 0; i < DISPLAY_BW_UNITS; i++, ptr++)
			sprintf(ptr, "%s", (i < units)? "*": " ");
		sprintf(ptr, "%s", " ");
	}

	return bw_line[units];
}

#define LINE_MAX 200
static inline void adjust_line(char *str, int len, int cols) {
	if (len > LINE_MAX) // functions such as snprintf truncate the string, and return the length of the untruncated string
		len = LINE_MAX;
	if (cols > 4 && len > cols) {
		str[cols] = '\0';
		str[cols- 1] = '\n';
	}
}

#define BWMAX_CNT 8
static unsigned adjust_bandwidth(unsigned bw) {
	static unsigned array[BWMAX_CNT] = {0};
	static int instance = 0;

	array[instance] = bw;
	int i;
	unsigned sum = 0;
	unsigned max = 0;
	for ( i = 0; i < BWMAX_CNT; i++) {
		sum += array[i];
		max = (max > array[i])? max: array[i];
	}
	sum /= BWMAX_CNT;

	if (++instance >= BWMAX_CNT)
		instance = 0;

	return (max < (sum / 2))? sum: max;
}

static inline const char *common_port(uint16_t port) {
	if (port > 123)
		return NULL;

	if (port == 20 || port == 21)
		return "(FTP)";
	else if (port == 22)
		return "(SSH)";
	else if (port == 23)
		return "(telnet)";
	else if (port == 25)
		return "(SMTP)";
	else if (port == 67)
		return "(DHCP)";
	else if (port == 69)
		return "(TFTP)";
	else if (port == 80)
		return "(HTTP)";
	else if (port == 109)
		return "(POP2)";
	else if (port == 110)
		return "(POP3)";
	else if (port == 123)
		return "(NTP)";

	return NULL;
}


static void hnode_print(unsigned bw) {
	assert(!arg_netfilter);
	bw = (bw < 1024 * DISPLAY_INTERVAL)? 1024 * DISPLAY_INTERVAL: bw;
#ifdef DEBUG
	printf("*********************\n");
	debug_dlist();
	printf("-----------------------------\n");
	debug_hnode();
	printf("*********************\n");
#else
	ansi_clrscr();
#endif

	// get terminal size
	struct winsize sz;
	int cols = 80;
	if (isatty(STDIN_FILENO)) {
		if (!ioctl(0, TIOCGWINSZ, &sz))
			cols  = sz.ws_col;
	}
	if (cols > LINE_MAX)
		cols = LINE_MAX;
	char line[LINE_MAX + 1];

	// print stats line
	bw = adjust_bandwidth(bw);
	char stats[31];
	if (bw > (1024 * 1024 * DISPLAY_INTERVAL))
		sprintf(stats, "%u MB/s ", bw / (1024 * 1024 * DISPLAY_INTERVAL));
	else
		sprintf(stats, "%u KB/s ", bw / (1024 * DISPLAY_INTERVAL));
	int len = snprintf(line, LINE_MAX, "%32s geoip %d, IP database %d\n", stats, geoip_calls, radix_nodes);
	adjust_line(line, len, cols);
	printf("%s", line);

	HNode *ptr = dlist;
	HNode *prev = NULL;
	while (ptr) {
		HNode *next = ptr->dnext;
		if (--ptr->ttl > 0) {
			char bytes[11];
			if (ptr->bytes > (DISPLAY_INTERVAL * 1024 * 1024 * 2)) // > 2 MB/second
				snprintf(bytes, 11, "%u MB/s",
					(unsigned) (ptr->bytes / (DISPLAY_INTERVAL * 1024* 1024)));
			else if (ptr->bytes > (DISPLAY_INTERVAL * 1024 * 2)) // > 2 KB/second
				snprintf(bytes, 11, "%u KB/s",
					(unsigned) (ptr->bytes / (DISPLAY_INTERVAL * 1024)));
			else
				snprintf(bytes, 11, "%u B/s ", (unsigned) (ptr->bytes / DISPLAY_INTERVAL));

			if (!ptr->hostname)
				ptr->hostname = radix_longest_prefix_match(ptr->ip_src);
			if (!ptr->hostname)
				ptr->hostname = retrieve_hostname(ptr->ip_src);
			if (!ptr->hostname)
				ptr->hostname = " ";

			unsigned bwunit = bw / DISPLAY_BW_UNITS;
			char *bwline;
			if (bwunit == 0)
				bwline = print_bw(0);
			else
				bwline = print_bw(ptr->bytes / bwunit);

			const char *protocol = NULL;
			if (ptr->port_src == 443)
				protocol = "(TLS)";
			else if (ptr->port_src == 53)
				protocol = "(DNS)";
			else if (ptr->port_src == 853)
				protocol = "(DoT)";
			else if ((protocol = common_port(ptr->port_src)) != NULL)
				;
			else if (ptr->protocol == 0x11)
				protocol = "(UDP)";
			if (protocol == NULL)
				protocol = "";

			len = snprintf(line, LINE_MAX, "%10s %s %d.%d.%d.%d:%u%s %s\n",
				bytes, bwline, PRINT_IP(ptr->ip_src), ptr->port_src, protocol, ptr->hostname);
			adjust_line(line, len, cols);
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

#ifdef DEBUG
	{
		int cnt = 0;
		HNode *ptr = hnode_unused;
		while (ptr) {
			cnt++;
			ptr = ptr->hnext;
		}
		printf("hnode unused %d\n", cnt);
	}
#endif
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
	unsigned bw = 0; // bandwidth calculations
	while (1) {
		unsigned end = time(NULL);
		if (arg_netfilter && end - start >= NETLOCK_INTERVAL)
			break;
		if (end % DISPLAY_INTERVAL == 1 && last_print_traces != end) { // first print after 1 second
			if (!arg_netfilter)
				hnode_print(bw);
			last_print_traces = end;
			bw = 0;
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
#ifdef DEBUG
			{
				uint32_t ip_src;
				memcpy(&ip_src, buf + 12, 4);
				ip_src = ntohl(ip_src);

				uint32_t ip_dst;
				memcpy(&ip_dst, buf + 16, 4);
				ip_dst = ntohl(ip_dst);
				printf("%d.%d.%d.%d -> %d.%d.%d.%d, %u bytes\n", PRINT_IP(ip_src), PRINT_IP(ip_dst), bytes);
			}
#endif
			// filter out loopback traffic
			if (buf[12] != 127 && buf[16] != 127) {
				bw += bytes + 14; // assume a 14 byte Ethernet layer

				uint32_t ip_src;
				memcpy(&ip_src, buf + 12, 4);
				ip_src = ntohl(ip_src);

				uint8_t hlen = (buf[0] & 0x0f) * 4;
				uint16_t port_src;
				memcpy(&port_src, buf + hlen, 2);
				port_src = ntohs(port_src);

				uint8_t protocol = buf[9];
				hnode_add(ip_src, protocol, port_src, bytes + 14);
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
	printf("Usage: fnettrace [OPTIONS]\n");
	printf("Options:\n");
	printf("   --help, -? - this help screen\n");
	printf("   --log=filename - netlocker logfile\n");
	printf("   --netfilter - build the firewall rules and commit them.\n");
	printf("   --tail - \"tail -f\" functionality\n");
	printf("Examples:\n");
	printf("   # fnettrace                              - traffic trace\n");
	printf("   # fnettrace --netfilter --log=logfile    - netlocker, dump output in logfile\n");
	printf("   # fnettrace --tail --log=logifile        - similar to \"tail -f logfile\"\n");
	printf("\n");
}

int main(int argc, char **argv) {
	int i;

#ifdef DEBUG
	// radix test
	radix_add(0x09000000, 0xff000000, "IBM");
	radix_add(0x09090909, 0xffffffff, "Quad9 DNS");
	radix_add(0x09000000, 0xff000000, "IBM");
	printf("This test should print \"IBM, Quad9 DNS, IBM\"\n");
	char *name = radix_longest_prefix_match(0x09040404);
	printf("%s, ", name);
	name = radix_longest_prefix_match(0x09090909);
	printf("%s, ", name);
	name = radix_longest_prefix_match(0x09322209);
	printf("%s\n", name);
#endif

	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-?") == 0) {
			usage();
			return 0;
		}
		else if (strcmp(argv[i], "--netfilter") == 0)
			arg_netfilter = 1;
		else if (strcmp(argv[i], "--tail") == 0)
			arg_tail = 1;
		else if (strncmp(argv[i], "--log=", 6) == 0)
			arg_log = argv[i] + 6;
		else {
			fprintf(stderr, "Error: invalid argument\n");
			return 1;
		}
	}

	// tail
	if (arg_tail) {
		if (!arg_log) {
			fprintf(stderr, "Error: no log file\n");
			usage();
			exit(1);
		}

		tail(arg_log);
		sleep(5);
		exit(0);
	}

	if (getuid() != 0) {
		fprintf(stderr, "Error: you need to be root to run this program\n");
		return 1;
	}

	ansi_clrscr();
	if (arg_netfilter)
		logprintf("starting network lockdown\n");
	else  {
		char *fname = LIBDIR "/firejail/static-ip-map";
		load_hostnames(fname);
	}

	run_trace();
	if (arg_netfilter) {
		// TCP path MTU discovery will not work properly since the firewall drops all ICMP packets
		// Instead, we use iPacketization Layer PMTUD (RFC 4821) support in Linux kernel
		int rv = system("echo 1 > /proc/sys/net/ipv4/tcp_mtu_probing");
		(void) rv;

		deploy_netfilter();
		sleep(3);
		if (arg_log)
			unlink(arg_log);
	}

	return 0;
}
