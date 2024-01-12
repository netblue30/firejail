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
#include "fnettrace.h"
#include "radix.h"
#include <limits.h>
#include <sys/ioctl.h>
#include <sys/prctl.h>
#include <signal.h>
#define MAX_BUF_SIZE (64 * 1024)

static char *arg_log = NULL;

// only 0 or negative values; positive values as defined in RFC
#define PROTOCOL_ICMP 0
#define PROTOCOL_SSH -1



//*****************************************************************
// packet stats
//*****************************************************************
uint32_t stats_pkts = 0;
uint32_t stats_icmp_echo = 0;
uint32_t stats_dns = 0;
uint32_t stats_dns_dot = 0;
uint32_t stats_dns_doh = 0;
uint32_t stats_dns_doq = 0;
uint32_t stats_tls = 0;
uint32_t stats_quic = 0;
uint32_t stats_tor = 0;
uint32_t stats_http = 0;
uint32_t stats_ssh = 0;

static void clear_stats(void) {
	stats_pkts = 0;
	stats_icmp_echo = 0;
	stats_dns = 0;
	stats_dns_dot = 0;
	stats_dns_doh = 0;
	stats_dns_doq = 0;
	stats_tls = 0;
	stats_quic = 0;
	stats_tor = 0;
	stats_http = 0;
	stats_ssh = 0;
}

//*****************************************************************
// traffic trace storage - hash table for fast access + linked list for display purposes
//*****************************************************************
typedef struct hnode_t {
	struct hnode_t *hnext;	// used for hash table and unused linked list
	struct hnode_t *dnext;	// used to display streams on the screen
	uint32_t ip_src;
	RNode *rnode;	// radix tree entry

	// stats
	uint32_t  bytes;	// number of bytes received in the last display interval
	uint32_t pkts;	// number of packets received in the last display interval
	uint16_t port_src;
	int protocol;

	// the firewall is build based on source address, and in the linked list
	// we could have elements with the same address but different ports
	uint8_t ip_instance;
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

// using protocol 0 and port 0 for ICMP
static void hnode_add(uint32_t ip_src, int protocol, uint16_t port_src, uint32_t bytes) {
	uint8_t h = hash(ip_src);

	// find
	int ip_instance = 0;
	HNode *ptr = htable[h];
	while (ptr) {
		if (ptr->ip_src == ip_src) {
			ip_instance++;
			if (ptr->port_src == port_src && ptr->protocol == protocol) {
				ptr->bytes += bytes;
				ptr->pkts++;
				assert(ptr->rnode);
				ptr->rnode->pkts++;
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
	hnew->ip_src = ip_src;
	hnew->port_src = port_src;
	hnew->protocol = protocol;
	hnew->hnext = NULL;
	hnew->bytes = bytes;
	hnew->pkts = 1;
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

	hnew->rnode = radix_longest_prefix_match(hnew->ip_src);
	if (!hnew->rnode)
		hnew->rnode = radix_add(hnew->ip_src, 0xffffffff, NULL);
	hnew->rnode->pkts++;
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
			sprintf(ptr, "%s", (i < units) ? "*" : " ");
		sprintf(ptr, "%s", " ");
	}

	return bw_line[units];
}

static inline void adjust_line(char *str, int len, int cols) {
	if (len > LINE_MAX) // functions such as snprintf truncate the string, and return the length of the untruncated string
		len = LINE_MAX;
	if (cols > 4 && len > cols) {
		str[cols] = '\0';
		str[cols - 1] = '\n';
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
		max = (max > array[i]) ? max : array[i];
	}
	sum /= BWMAX_CNT;

	if (++instance >= BWMAX_CNT)
		instance = 0;

	return (max < (sum / 2)) ? sum : max;
}

typedef struct port_type_t {
	uint16_t port;
	char *service;
} PortType;
static PortType ports[] = {
	{20, "FTP"},
	{21, "FTP"},
	{22, "SSH"},
	{23, "telnet"},
	{25, "SMTP"},
	{43, "WHOIS"},
	{67, "DHCP"},
	{68, "DHCP"},
	{69, "TFTP"},
	{80, "HTTP"},
	{109, "POP2"},
	{110, "POP3"},
	{113, "IRC"},
	{123, "NTP"},
	{161, "SNMP"},
	{162, "SNMP"},
	{194, "IRC"},
	{0, NULL},
};


static inline const char *common_port(uint16_t port) {
	if (port >= 6660 && port <= 10162) {
		if (port >= 6660 && port <= 6669)
			return "IRC";
		else if (port == 6679)
			return "IRC";
		else if (port == 6771)
			return "BitTorrent";
		else if (port >= 6881 && port <= 6999)
			return "BitTorrent";
		else if (port == 9001)
			return "Tor";
		else if (port == 9030)
			return "Tor";
		else if (port == 9040)
			return "Tor";
		else if (port == 9050)
			return "Tor";
		else if (port == 9051)
			return "Tor";
		else if (port == 9150)
			return "Tor";
		else if (port == 10161)
			return "secure SNMP";
		else if (port == 10162)
			return "secure SNMP";
		return NULL;
	}

	if (port <= 194) {
		PortType *ptr = &ports[0];
		while(ptr->service != NULL) {
			if (ptr->port == port)
				return ptr->service;
			ptr++;
		}
	}

	return NULL;
}



static void hnode_print(unsigned bw) {
	bw = (bw < 1024 * DISPLAY_INTERVAL) ? 1024 * DISPLAY_INTERVAL : bw;
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
//	int len = snprintf(line, LINE_MAX, "%32s geoip %d, IP database %d\n", stats, geoip_calls, radix_nodes);
	char faint1[] = {0x1b, '[', '2', 'm', '\0'};
	char faint2[] = {0x1b, '[', '0', 'm', '\0'};
	int len = snprintf(line, LINE_MAX, "%32s %saddress:port (protocol) network%s\n", stats, faint1, faint2);
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
					 (unsigned) (ptr->bytes / (DISPLAY_INTERVAL * 1024 * 1024)));
			else if (ptr->bytes > (DISPLAY_INTERVAL * 1024 * 2)) // > 2 KB/second
				snprintf(bytes, 11, "%u KB/s",
					 (unsigned) (ptr->bytes / (DISPLAY_INTERVAL * 1024)));
			else
				snprintf(bytes, 11, "%u B/s ", (unsigned) (ptr->bytes / DISPLAY_INTERVAL));

			if (!ptr->rnode->name)
				ptr->rnode->name = retrieve_hostname(ptr->ip_src);
			if (!ptr->rnode->name)
				ptr->rnode->name = " ";
			assert(ptr->rnode->name);

			unsigned bwunit = bw / DISPLAY_BW_UNITS;
			char *bwline;
			if (bwunit == 0)
				bwline = print_bw(0);
			else
				bwline = print_bw(ptr->bytes / bwunit);

			const char *protocol = NULL;
			if (ptr->port_src == 443 && ptr->protocol == 0x06) { // TCP
				protocol = "TLS";
				stats_tls += ptr->pkts;
				if (strstr(ptr->rnode->name, "DNS")) {
					protocol = "DoH";
					stats_dns_doh += ptr->pkts;
				}

			}
			else if (ptr->port_src == 443 && ptr->protocol == 0x11) { // UDP
				protocol = "QUIC";
				stats_quic +=  ptr->pkts;
				if (strstr(ptr->rnode->name, "DNS")) {
					protocol = "DoQ";
					stats_dns_doq += ptr->pkts;
				}
			}
			else if (ptr->port_src == 53) {
				protocol = "DNS";
				stats_dns += ptr->pkts;
			}
			else if (ptr->port_src == 853) {
				if (ptr->protocol == 0x06) {
					protocol = "DoT";
					stats_dns_dot += ptr->pkts;
				}
				else if (ptr->protocol == 0x11) {
					protocol = "DoQ";
					stats_dns_doq += ptr->pkts;
				}
				else
					protocol = NULL;
			}
			else if ((protocol = common_port(ptr->port_src)) != NULL) {
				if (strcmp(protocol, "HTTP") == 0)
					stats_http += ptr->pkts;
				else if (strcmp(protocol, "Tor") == 0)
					stats_tor += ptr->pkts;
				else if (strcmp(protocol, "SSH") == 0)
					stats_ssh += ptr->pkts;
			}
			else if (ptr->protocol == 0x11)
				protocol = "UDP";
			else if (ptr->protocol == 0x06)
				protocol = "TCP";
			else if (ptr->protocol == PROTOCOL_SSH) {
				protocol = "SSH";
				stats_ssh += ptr->pkts;
			}

			if (protocol == NULL)
				protocol = "";
			if (ptr->port_src == PROTOCOL_ICMP)
				len = snprintf(line, LINE_MAX, "%10s %s %d.%d.%d.%d (ICMP) %s\n",
					       bytes, bwline, PRINT_IP(ptr->ip_src), ptr->rnode->name);
			else
				len = snprintf(line, LINE_MAX, "%10s %s %d.%d.%d.%d:%u (%s) %s\n",
					       bytes, bwline, PRINT_IP(ptr->ip_src), ptr->port_src, protocol, ptr->rnode->name);
			adjust_line(line, len, cols);
			printf("%s", line);

			if (ptr->bytes)
				ptr->ttl = DISPLAY_TTL;
			ptr->bytes = 0;
			ptr->pkts = 0;
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
	ansi_faint("(D)isplay, (S)ave, (C)lear, e(X)it\n");

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

static void print_stats(FILE *fp) {
	assert(fp);

	fprintf(fp, "Stats: %u packets\n", stats_pkts);
	fprintf(fp, "   encrypted: TLS %u, QUIC %u, Tor %u\n",
		stats_tls, stats_quic, stats_tor);
	fprintf(fp, "   unencrypted: HTTP %u\n", stats_http);
	fprintf(fp, "   C&C backchannel: SSH %u, PING %u, DNS %u, DoH %u, DoT %u, DoQ %u\n",
		stats_ssh, stats_icmp_echo, stats_dns, stats_dns_doh, stats_dns_dot, stats_dns_doq);

	fprintf(fp, "\n\nIP map");
	if (fp == stdout)
		ansi_faint("  - network (packets)\n");
	else
		fprintf(fp, "  - network (packets)\n");
	radix_print(fp, 1);

	fprintf(fp, "\n\nEvents %d", ev_cnt);
	if (fp == stdout)
		ansi_faint(" - time address data\n");
	else
		fprintf(fp, " - time address data\n");
	ev_print(fp);

}



// trace rx traffic coming in
static void run_trace(void) {
	// trace only rx ipv4 tcp and upd
	int s1 = socket(AF_INET, SOCK_RAW, IPPROTO_TCP);
	int s2 = socket(AF_INET, SOCK_RAW, IPPROTO_UDP);
	int s3 = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);
	if (s1 < 0 || s2 < 0 || s3 < 0)
		errExit("socket");


	int p1 = runprog(LIBDIR "/firejail/fnettrace-sni");
	if (p1 != -1)
		printf("loading snitrace...");

	int p2 = runprog(LIBDIR "/firejail/fnettrace-dns");
	if (p2 != -1)
		printf("loading dnstrace...");
	unsigned last_print_traces = 0;
	unsigned char buf[MAX_BUF_SIZE];
	unsigned bw = 0; // bandwidth calculations

	while (1) {
		unsigned end = time(NULL);
		if (end % DISPLAY_INTERVAL == 1 && last_print_traces != end) { // first print after 1 second
			hnode_print(bw);
			last_print_traces = end;
			bw = 0;
		}

		fd_set rfds;
		FD_ZERO(&rfds);
		FD_SET(0, &rfds);

		FD_SET(s1, &rfds);
		FD_SET(s2, &rfds);
		FD_SET(s3, &rfds);
		int maxfd = (s1 > s2) ? s1 : s2;
		maxfd = (s3 > maxfd) ? s3 : maxfd;

		if (p1 != -1) {
			FD_SET(p1, &rfds);
			maxfd = (p1 > maxfd) ? p1 : maxfd;
		}

		if (p2 != -1) {
			FD_SET(p2, &rfds);
			maxfd = (p2 > maxfd) ? p2 : maxfd;
		}
		maxfd++;

		struct timeval tv;
		tv.tv_sec = 1;
		tv.tv_usec = 0;

		int rv = select(maxfd, &rfds, NULL, NULL, &tv);
		if (rv < 0)
			errExit("select");
		else if (rv == 0)
			continue;


		// rx tcp traffic by default
		int sock = s1;
		int icmp = 0;

		if (FD_ISSET(0, &rfds)) {
			int c = getchar();
			if (c == 'c' || c == 'C') {
				clear_stats();
				ev_clear();
				radix_clear_data();
				continue;
			}
			else if (c == 'd' || c == 'D') {
				printf("\n\n");
				ansi_bold("__________________________________________________________________________\n");
				print_stats(stdout);
				ansi_bold("__________________________________________________________________________\n");
				ansi_faint("press any key to continue...");
				fflush(0);

				getchar();
				continue;
			}
			if (c == 's' || c == 'S') {
				printf("The file is saved in /tmp directory. Please enter the file name: ");
				fflush(0);

				char buf[LINE_MAX + 5]; // eave some room to add /tmp/
				strcpy(buf, "/tmp/");
				terminal_restore();
				if (fgets(buf + 5, LINE_MAX, stdin) == NULL)
					errExit("fgets");
				terminal_set();

				// remove '\n' and open the file
				char *ptr = strchr(buf, '\n');
				if (!ptr) { // we should have a '\n'
					printf("Error: invalid file name\n");
					sleep(5);
					continue;
				}
				*ptr = '\0';

				FILE *fp = fopen(buf, "w");
				if (!fp) {
					printf("Error: cannot open file %s\n", buf);
					perror("fopen");
					sleep(5);
					continue;
				}

				printf("Saving stats in %s file...\n", buf);
				print_stats(fp);
				fclose(fp);
				int rv = chmod(buf, 0600);
				(void) rv;
				sleep(1);
				continue;
			}
			else if (c == 'x' || c == 'X')
				break;
			continue;
		}
		else if (FD_ISSET(p1, &rfds)) {
			char buf[LINE_MAX];
			ssize_t sz = read(p1, buf, LINE_MAX - 1);
			if (sz == -1)
				errExit("error reading snitrace");
			if (sz == 0) {
				fprintf(stderr, "Error: snitrace EOF!!!\n");
				p1 = -1;
			}
			if (strncmp(buf, "SNI trace", 9) == 0)
				continue;

			buf[sz] = '\0';
			ev_add(buf);
			continue;
		}
		else if (FD_ISSET(p2, &rfds)) {
			char buf[LINE_MAX];
			ssize_t sz = read(p2, buf, LINE_MAX - 1);
			if (sz == -1)
				errExit("error reading dnstrace");
			if (sz == 0) {
				fprintf(stderr, "Error: dnstrace EOF!!!\n");
				p2 = -1;
			}
			if (strncmp(buf, "DNS trace", 9) == 0)
				continue;

			buf[sz] = '\0';
			ev_add(buf);
			continue;
		}
		// by default we assume TCP
		else if (FD_ISSET(s2, &rfds))
			sock = s2;
		else if (FD_ISSET(s3, &rfds)) {
			sock = s3;
			icmp = 1;
		}

		unsigned bytes = recvfrom(sock, buf, MAX_BUF_SIZE, 0, NULL, NULL);
		if (bytes >= 20) { // minimum size of IP packet
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
				uint16_t port_src = 0;
				if (icmp)
					hnode_add(ip_src, PROTOCOL_ICMP, 0, bytes + 14);
				else { // itcp or udp
					memcpy(&port_src, buf + hlen, 2);
					port_src = ntohs(port_src);
					int protocol = (int) buf[9];

					// detect ssh on a standard or not so standard port (22)
					if (protocol == 6) { // tcp
						uint8_t dataoffset = *(buf + hlen + 12);
						uint8_t tcphlen = (dataoffset >> 2);
						if (memcmp(buf + hlen + tcphlen, "SSH-", 4) == 0) {
							time_t seconds = time(NULL);
							struct tm *t = localtime(&seconds);
							char ip[30];
							sprintf(ip, "%d.%d.%d.%d", PRINT_IP(ip_src));
							char *msg;
							if (asprintf(&msg, "%02d:%02d:%02d  %-15s  SSH connection",
								t->tm_hour, t->tm_min, t->tm_sec, ip) == -1)
								errExit("asprintf");
							ev_add(msg);
							free(msg);
							protocol = PROTOCOL_SSH;
						}
					}
					hnode_add(ip_src, protocol, port_src, bytes + 14);
				}

				// stats
				stats_pkts++;
				if (icmp)  {
					if (*(buf + hlen) == 0 || *(buf + hlen) == 8)
						stats_icmp_echo++;
				}

			}
		}
	}

	close(s1);
	close(s2);
	close(s3);
	if (p1 != -1)
		close(p1);
	if (p2 != -1)
		close(p2);
}


void logprintf(char *fmt, ...) {
	if (!arg_log)
		return;

	FILE *fp = fopen(arg_log, "a");
	if (fp) { // disregard if error
		va_list args;
		va_start(args, fmt);
		vfprintf(fp, fmt, args);
		va_end(args);
		fclose(fp);
	}

	va_list args;
	va_start(args, fmt);
	vfprintf(stdout, fmt, args);
	va_end(args);
}

static const char *const usage_str =
	"Usage: fnettrace [OPTIONS]\n"
	"Options:\n"
	"   --help, -? - this help screen\n"
	"   --log=filename - netlocker logfile\n"
	"   --print-map - print IP map\n"
	"   --squash-map - compress IP map\n";

static void usage(void) {
	puts(usage_str);
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
		else if (strcmp(argv[i], "--print-map") == 0) {
			char *fname = "static-ip-map.txt";
			load_hostnames(fname);
			radix_print(stdout, 0);
			return 0;
		}
		else if (strncmp(argv[i], "--squash-map=", 13) == 0) {
			if (i != (argc - 1)) {
				fprintf(stderr, "Error: please provide a map file\n");
				return 1;
			}
			load_hostnames(argv[i] + 13);
			int in = radix_nodes;
			radix_squash();
			radix_squash();
			radix_squash();
			radix_squash();
			radix_squash();

			printf("#\n");
			printf("# This file is part of firejail project\n");
			printf("# The following list of addresses was compiled from various public sources.\n");
			printf("# License GPLv2\n");
			printf("#\n");

			radix_print(stdout, 0);
			printf("\n#\n#\n# input %d, output %d\n#\n#\n", in, radix_nodes);
			fprintf(stderr, "static ip map: input %d, output %d\n", in, radix_nodes);
			return 0;
		}
		else if (strncmp(argv[i], "--log=", 6) == 0)
			arg_log = argv[i] + 6;
		else {
			fprintf(stderr, "Error: invalid argument\n");
			return 1;
		}
	}

	if (getuid() != 0) {
		fprintf(stderr, "Error: you need to be root to run this program\n");
		return 1;
	}

	terminal_set();
	// handle CTRL-C
	signal (SIGINT, terminal_handler);
	signal (SIGTERM, terminal_handler);
	atexit(terminal_restore);

	// kill the process if the parent died
	prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);

	ansi_clrscr();
	char *fname = LIBDIR "/firejail/static-ip-map";
	load_hostnames(fname);

	run_trace();

	return 0;
}
