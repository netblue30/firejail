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
#include "fnettrace_dns.h"
#include <sys/ioctl.h>
#include <time.h>
#include <linux/filter.h>
#include <linux/if_ether.h>
#include <sys/prctl.h>
#include <signal.h>
#define MAX_BUF_SIZE (64 * 1024)

static int arg_nolocal = 0;
static char last[512] = {'\0'};

// pkt - start of DNS layer
void print_dns(uint32_t ip_src, unsigned char *pkt) {
	assert(pkt);

	char ip[30];
	sprintf(ip, "%d.%d.%d.%d", PRINT_IP(ip_src));
	time_t seconds = time(NULL);
	struct tm *t = localtime(&seconds);

	int nxdomain = ((*(pkt + 3) & 0x03) == 0x03)? 1: 0;

	// expecting a single question count
	if (pkt[4] != 0 || pkt[5] != 1)
		goto errout;

	// check cname
	unsigned char *ptr = pkt + 12;
	int len = 0;
	while (*ptr != 0 && len < 255) {	// 255 is the maximum length of a domain name including multiple '.'
		if (*ptr > 63)	// the name left of a '.' is 63 length maximum
			goto errout;

		int delta = *ptr + 1;
		*ptr = '.';
		len += delta;;
		ptr += delta;
	}
	if (*ptr  != 0)
		goto errout;

	ptr++;
	uint16_t type;
	memcpy(&type, ptr, 2);
	type = ntohs(type);

	// filter output
	char tmp[sizeof(last)];
	snprintf(tmp, sizeof(last), "%02d:%02d:%02d  %-15s  DNS %s (type %u)%s",
		t->tm_hour, t->tm_min, t->tm_sec, ip, pkt + 12 + 1,
		type, (nxdomain)? " NXDOMAIN": "");
	if (strcmp(tmp, last)) {
		printf("%s\n", tmp);
		fflush(0);
		strcpy(last, tmp);
	}

	return;

errout:
	printf("%02d:%02d:%02d  %15s  Error: invalid DNS packet\n", t->tm_hour, t->tm_min, t->tm_sec, ip);
	fflush(0);
}

// https://www.kernel.org/doc/html/latest/networking/filter.html
static void custom_bpf(int sock) {
	struct sock_filter code[] = {
		//  sudo tcpdump ip and udp and src port 53 -dd
		{ 0x28, 0, 0, 0x0000000c },
		{ 0x15, 0, 8, 0x00000800 },
		{ 0x30, 0, 0, 0x00000017 },
		{ 0x15, 0, 6, 0x00000011 },
		{ 0x28, 0, 0, 0x00000014 },
		{ 0x45, 4, 0, 0x00001fff },
		{ 0xb1, 0, 0, 0x0000000e },
		{ 0x48, 0, 0, 0x0000000e },
		{ 0x15, 0, 1, 0x00000035 },
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
		printf("DNS trace for %s", ctime(&now));
		day = t->tm_yday;
	}
	fflush(0);
}

static void run_trace(void) {
	// grab all Ethernet packets and use a custom BPF filter to get only UDP from source port 53
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

		if (bytes >= (14 + 20 + 8)) { // size of  MAC + IP + UDP headers
			uint8_t ip_hlen = (buf[14] & 0x0f) * 4;
			uint16_t port_src;
			memcpy(&port_src, buf + 14 + ip_hlen, 2);
			port_src = ntohs(port_src);
			uint8_t protocol = buf[14 + 9];
			uint32_t ip_src;
			memcpy(&ip_src, buf + 14 + 12, 4);
			ip_src = ntohl(ip_src);

			if (arg_nolocal) {
				if ((ip_src & 0xff000000) == 0x7f000000 ||	// 127.0.0.0/8
				    (ip_src & 0xff000000) == 0x0a000000 ||	// 10.0.0.0/8
				    (ip_src & 0xffff0000) == 0xc0a80000 ||	// 192.168.0.0/16
				    (ip_src & 0xfff00000) == 0xac100000)	// 172.16.0.0/12
					continue;
			}

			// if DNS packet, extract the query
			if (port_src == 53 && protocol == 0x11) // UDP protocol
				print_dns(ip_src, buf + 14 + ip_hlen + 8); // IP and UDP header len
		}
	}

	close(s);
}
static const char *const usage_str =
	"Usage: fnettrace-dns [OPTIONS]\n"
	"Options:\n"
	"   --help, -? - this help screen\n"
	"   --nolocal\n";

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
		else if (strcmp(argv[i], "--nolocal") == 0)
			arg_nolocal = 1;
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
