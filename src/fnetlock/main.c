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
#include "fnetlock.h"
#include <limits.h>
#include <sys/ioctl.h>
#include <sys/prctl.h>
#include <signal.h>
#define MAX_BUF_SIZE (64 * 1024)

static int arg_tail = 0;
static char *arg_log = NULL;

//*****************************************************************
// traffic trace storage - hash table for fast access + linked list for display purposes
//*****************************************************************
typedef struct hnode_t {
	struct hnode_t *hnext;	// used for hash table and unused linked list
	struct hnode_t *dnext;	// used to display streams on the screen
	uint32_t ip_src;
	uint16_t port_src;
	uint8_t protocol;

	// the firewall is build based on source address, and in the linked list
	// we could have elements with the same address but different ports
	uint8_t ip_instance;
} HNode;

// hash table
#define HMAX 256
HNode *htable[HMAX] = {NULL};
static int have_traffic = 0;

// using protocol 0 and port 0 for ICMP
static void hnode_add(uint32_t ip_src, uint8_t protocol, uint16_t port_src) {
	uint8_t h = hash(ip_src);
	int ip_instance = 0;
	HNode *ptr = htable[h];
	while (ptr) {
		if (ptr->ip_src == ip_src) {
			ip_instance++;
			if (ptr->port_src == port_src && ptr->protocol == protocol)
				return;
		}
		ptr = ptr->hnext;
	}

	logprintf("netlock: adding %d.%d.%d.%d\n", PRINT_IP(ip_src));
	have_traffic = 1;
	HNode *hnew = malloc(sizeof(HNode));
	assert(hnew);
	hnew->ip_src = ip_src;
	hnew->port_src = port_src;
	hnew->protocol = protocol;
	hnew->hnext = NULL;
	hnew->ip_instance = ip_instance + 1;
	if (htable[h] == NULL)
		htable[h] = hnew;
	else {
		hnew->hnext = htable[h];
		htable[h] = hnew;
	}
}




// trace rx traffic coming in
static void run_trace(void) {
	logprintf("netlock: accumulating traffic for %d seconds\n", NETLOCK_INTERVAL);

	// trace only rx ipv4 tcp and upd
	int s1 = socket(AF_INET, SOCK_RAW, IPPROTO_TCP);
	int s2 = socket(AF_INET, SOCK_RAW, IPPROTO_UDP);
	if (s1 < 0 || s2 < 0)
		errExit("socket");


	unsigned start = time(NULL);
	unsigned char buf[MAX_BUF_SIZE];
	// FIXME: error: variable 'bw' set but not used [-Werror,-Wunused-but-set-variable]
	//unsigned bw = 0; // bandwidth calculations

	int printed = 0;
	while (1) {
		unsigned runtime = time(NULL) - start;
		if ( runtime >= NETLOCK_INTERVAL)
			break;
		if (runtime % 10 == 0) {
			if (!printed)
				logprintf("netlock: %u seconds remaining\n", NETLOCK_INTERVAL - runtime);
			printed = 1;
		}
		else
			printed = 0;

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


		// rx tcp traffic by default
		int sock = s1;

		if (FD_ISSET(s2, &rfds))
			sock = s2;

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
				// FIXME: error: variable 'bw' set but not used [-Werror,-Wunused-but-set-variable]
				//bw += bytes + 14; // assume a 14 byte Ethernet layer

				uint32_t ip_src;
				memcpy(&ip_src, buf + 12, 4);
				ip_src = ntohl(ip_src);

				uint8_t hlen = (buf[0] & 0x0f) * 4;
				uint16_t port_src = 0;
				memcpy(&port_src, buf + hlen, 2);
				port_src = ntohs(port_src);

				uint8_t protocol = buf[9];
				hnode_add(ip_src, protocol, port_src);
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
				char *protocol = (ptr->protocol == 6) ? "tcp" : "udp";
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

	if (have_traffic == 0) {
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

	FILE *fp = fdopen(fd, "w");
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
	logprintf("\nnetlock: firewall deployed\n");
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
	"   --tail - \"tail -f\" functionality\n";

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

	// kill the process if the parent died
	prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);

	logprintf("netlock: starting network lockdown\n");
	run_trace();

	// TCP path MTU discovery will not work properly since the firewall drops all ICMP packets
	// Instead, we use iPacketization Layer PMTUD (RFC 4821) support in Linux kernel
	int rv = system("echo 1 > /proc/sys/net/ipv4/tcp_mtu_probing");
	(void) rv;

	deploy_netfilter();
	sleep(3);
	if (arg_log)
		unlink(arg_log);

	return 0;
}
