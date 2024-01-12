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
#include "fnettrace_sni.h"
#include <sys/ioctl.h>
#include <time.h>
#include <linux/filter.h>
#include <linux/if_ether.h>
#include <sys/prctl.h>
#include <signal.h>
#define MAX_BUF_SIZE (64 * 1024)

static char last[512] = {'\0'};

// pkt - start of TLS layer
static void print_tls(uint32_t ip_dest, unsigned char *pkt, unsigned len) {
	assert(pkt);

	// expecting a handshake packet and client hello
	if (pkt[0] != 0x16 || pkt[5] != 0x01)
		return;

	char ip[30];
	sprintf(ip, "%d.%d.%d.%d", PRINT_IP(ip_dest));
	time_t seconds = time(NULL);
	struct tm *t = localtime(&seconds);

	// look for server name indication
	unsigned char *ptr = pkt;
	unsigned int i = 0;
	char *name = NULL;
	while (i < (len - 20)) {
		// 3 zeros and 3 matching length fields
		if (*ptr == 0 && *(ptr + 1) == 0 && (*(ptr + 2) == 0 || *(ptr + 2) == 1) && *(ptr + 6) == 0) {
			uint16_t len1;
			memcpy(&len1, ptr + 2, 2);
			len1 = ntohs(len1);

			uint16_t len2;
			memcpy(&len2, ptr + 4, 2);
			len2 = ntohs(len2);

			uint16_t len3;
			memcpy(&len3, ptr + 7, 2);
			len3 = ntohs(len3);

			if (len1 == (len2 + 2) && len1 == (len3 + 5)) {
				*(ptr + 9 + len3) = 0;
				name = (char *) (ptr + 9);
				break;
			}
		}
		ptr++;
		i++;
	}

	if (name) {
		// filter output
		char tmp[sizeof(last)];
		snprintf(tmp, sizeof(last), "%02d:%02d:%02d  %-15s  SNI %s", t->tm_hour, t->tm_min, t->tm_sec, ip, name);
		if (strcmp(tmp, last)) {
			printf("%s\n", tmp);
			fflush(0);
			strcpy(last, tmp);
		}
	}
	else
		goto nosni;
	return;

nosni:
	printf("%02d:%02d:%02d  %-15s  no SNI\n", t->tm_hour, t->tm_min, t->tm_sec, ip);
	return;
}

// https://www.kernel.org/doc/html/latest/networking/filter.html
static void custom_bpf(int sock) {
	struct sock_filter code[] = {
		// ports: 443 (regular TLS), 853 (DoT)
		// sudo tcpdump "tcp port (443 or 853) and (tcp[((tcp[12] & 0xf0) >>2)] = 0x16) && (tcp[((tcp[12] & 0xf0) >>2)+5] = 0x01)" -dd
		{ 0x28, 0, 0, 0x0000000c },
		{ 0x15, 29, 0, 0x000086dd },
		{ 0x15, 0, 28, 0x00000800 },
		{ 0x30, 0, 0, 0x00000017 },
		{ 0x15, 0, 26, 0x00000006 },
		{ 0x28, 0, 0, 0x00000014 },
		{ 0x45, 24, 0, 0x00001fff },
		{ 0xb1, 0, 0, 0x0000000e },
		{ 0x48, 0, 0, 0x0000000e },
		{ 0x15, 4, 0, 0x000001bb },
		{ 0x15, 3, 0, 0x00000355 },
		{ 0x48, 0, 0, 0x00000010 },
		{ 0x15, 1, 0, 0x000001bb },
		{ 0x15, 0, 17, 0x00000355 },
		{ 0x50, 0, 0, 0x0000001a },
		{ 0x54, 0, 0, 0x000000f0 },
		{ 0x74, 0, 0, 0x00000002 },
		{ 0xc, 0, 0, 0x00000000 },
		{ 0x7, 0, 0, 0x00000000 },
		{ 0x50, 0, 0, 0x0000000e },
		{ 0x15, 0, 10, 0x00000016 },
		{ 0xb1, 0, 0, 0x0000000e },
		{ 0x50, 0, 0, 0x0000001a },
		{ 0x54, 0, 0, 0x000000f0 },
		{ 0x74, 0, 0, 0x00000002 },
		{ 0x4, 0, 0, 0x00000005 },
		{ 0xc, 0, 0, 0x00000000 },
		{ 0x7, 0, 0, 0x00000000 },
		{ 0x50, 0, 0, 0x0000000e },
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
		printf("SNI trace for %s", ctime(&now));
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

		if (bytes >= (14 + 20 + 20)) { // size of  MAC + IP + TCP headers
			uint8_t ip_hlen = (buf[14] & 0x0f) * 4;
			uint16_t port_dest;
			memcpy(&port_dest, buf + 14 + ip_hlen + 2, 2);
			port_dest = ntohs(port_dest);
			uint32_t ip_dest;
			memcpy(&ip_dest, buf + 14 + 16, 4);
			ip_dest = ntohl(ip_dest);
			uint8_t tcp_hlen = (buf[14 + ip_hlen + 12] & 0xf0) >> 2;

			// extract SNI
			print_tls(ip_dest, buf + 14 + ip_hlen + tcp_hlen, bytes - 14 - ip_hlen - tcp_hlen); // IP and TCP header len
		}
	}

	close(s);
}

static const char *const usage_str =
	"Usage: fnettrace-sni [OPTIONS]\n"
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
