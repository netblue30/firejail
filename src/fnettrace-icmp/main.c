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
#include "fnettrace_icmp.h"
#include <sys/ioctl.h>
#include <time.h>
#include <linux/filter.h>
#include <linux/if_ether.h>
#include <sys/prctl.h>
#include <signal.h>
#define MAX_BUF_SIZE (64 * 1024)

char *type_description[19] = {
	"Echo reply",
	"unassigned",
	"unassigned",
	"Destination unreachable",
	"Source quench",
	"Redirect message",
	"unassigned",
	"unassigned",
	"Echo request",
	"Router advertisement",
	"Router solicitation",
	"Time exceeded",
	"Bad IP header",
	"Timestamp",
	"Timestamp replay",
	"Information request",
	"Information reply",
	"Address mask request",
	"Address mask reply"
};

char *code_dest_unreachable[16] = {
	"Network unreachable",
	"Host unreachable",
	"Protocol unreachable",
	"Port unreachable",
	"Fragmentation required, and DF flag set",
	"Source route failed",
	"Network unknown",
	"Host unknown",
	"Source host isolated",
	"Network administratively prohibited",
	"Host administratively prohibited",
	"Network unreachable for ToS",
	"Host unreachable for ToS",
	"Communication administratively prohibited",
	"Host Precedence Violation",
	"Precedence cutoff in effect"
};

char *code_redirect_message[4] = {
	"Datagram for the Network",
	"Datagram for the Host",
	"Datagram for the ToS & network",
	"Datagram for the ToS & host"
};

char *code_time_exceeded[2] = {
	"TTL expired in transit",
	"Fragment reassembly time exceeded"
};

char *code_bad_ip_header[3] = {
	"Pointer indicates the error",
	"Missing a required option",
	"Bad length"
};

static void print_icmp(uint32_t ip_dest, uint32_t ip_src, uint8_t type, uint8_t code, unsigned icmp_bytes) {
	char type_number[10];
	char *type_ptr = type_number;
	if (type < 19)
		type_ptr = type_description[type];
	else
		sprintf(type_number, "%u", type);

	char code_number[10];
	char *code_ptr = code_number;
	if (type ==3 && code < 16)
		code_ptr = code_dest_unreachable[code];
	else if (type == 5 && code < 4)
		code_ptr = code_redirect_message[code];
	else if (type == 11 && code < 2)
		code_ptr = code_time_exceeded[code];
	else if (type == 12 && code < 3)
		code_ptr = code_bad_ip_header[code];
	else
		sprintf(code_number, "%u", code);

	time_t seconds = time(NULL);
	struct tm *t = localtime(&seconds);
	printf("%02d:%02d:%02d  %d.%d.%d.%d -> %d.%d.%d.%d - %u bytes - %s/%s\n",
		t->tm_hour, t->tm_min, t->tm_sec,
		PRINT_IP(ip_src),
		PRINT_IP(ip_dest),
		icmp_bytes,
		type_ptr,
		code_ptr);
	fflush(0);
}

// https://www.kernel.org/doc/html/latest/networking/filter.html
static void custom_bpf(int sock) {
	struct sock_filter code[] = {
		// sudo tcpdump "icmp" -dd
		{ 0x28, 0, 0, 0x0000000c },
		{ 0x15, 0, 3, 0x00000800 },
		{ 0x30, 0, 0, 0x00000017 },
		{ 0x15, 0, 1, 0x00000001 },
		{ 0x6, 0, 0, 0x00040000 },
		{ 0x6, 0, 0, 0x00000000 },
	};

	struct sock_fprog bpf = {
		.len = (unsigned short) sizeof(code) / sizeof(code[0]),
		.filter = code,
	};

	int rv = setsockopt(sock, SOL_SOCKET, SO_ATTACH_FILTER, &bpf, sizeof(bpf));
	if (rv < 0) {
		fprintf(stderr, "Error: cannot attach BPF filter\n");
		exit(1);
	}
}

static void print_date(void) {
	static int day = -1;
	time_t now = time(NULL);
	struct tm *t = localtime(&now);

	if (day != t->tm_yday) {
		printf("\nICMP trace for %s", ctime(&now));
		day = t->tm_yday;
	}

	fflush(0);
}

static void run_trace(void) {
	// grab all Ethernet packets and use a custom BPF filter to get TLS/SNI packets
	int s = socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
	if (s < 0)
		errExit("socket");
	custom_bpf(s);

	struct timeval tv;
	tv.tv_sec = 10;
	tv.tv_usec = 0;
	unsigned char buf[MAX_BUF_SIZE];
	while (1) {
		fd_set rfds;
		FD_ZERO(&rfds);
		FD_SET(s, &rfds);
		int rv = select(s + 1, &rfds, NULL, NULL, &tv);
		if (rv < 0)
			errExit("select");
		else if (rv == 0) {
			print_date();
			tv.tv_sec = 10;
			tv.tv_usec = 0;
			continue;
		}

		unsigned bytes = recvfrom(s, buf, MAX_BUF_SIZE, 0, NULL, NULL);

		if (bytes >= (14 + 20 + 2)) { // size of  MAC + IP + ICMP code and type fields
			uint8_t ip_hlen = (buf[14] & 0x0f) * 4;
			uint8_t type = *(buf + 14 +ip_hlen);
			uint8_t code = *(buf + 14 + ip_hlen + 1);

			uint32_t ip_dest;
			memcpy(&ip_dest, buf + 14 + 16, 4);
			ip_dest = ntohl(ip_dest);
			uint32_t ip_src;
			memcpy(&ip_src, buf + 14 + 12, 4);
			ip_src = ntohl(ip_src);

			print_icmp(ip_dest, ip_src, type, code, bytes);
		}
	}

	close(s);
}

static const char *const usage_str =
	"Usage: fnettrace-icmp [OPTIONS]\n"
	"Options:\n"
	"   --help, -? - this help screen\n";

static void usage(void) {
	puts(usage_str);
}

int main(int argc, char **argv) {
	int i;

	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-?") == 0) {
			usage();
			return 0;
		}
		else {
			fprintf(stderr, "Error: invalid argument\n");
			return 1;
		}
	}

	if (getuid() != 0) {
		fprintf(stderr, "Error: you need to be root to run this program\n");
		return 1;
	}

	// kill the process if the parent died
	prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);

	print_date();
	run_trace();

	return 0;
}
