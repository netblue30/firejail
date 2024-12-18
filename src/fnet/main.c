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
#include "fnet.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/utsname.h>

int arg_quiet = 0;

void fmessage(char* fmt, ...) { // TODO: this function is duplicated in src/firejail/util.c
	if (arg_quiet)
		return;

	va_list args;
	va_start(args,fmt);
	vfprintf(stderr, fmt, args);
	va_end(args);
	fflush(0);
}

static const char *const usage_str =
	"Usage:\n"
	"\tfnet create veth dev1 dev2 bridge child\n"
	"\tfnet create macvlan dev parent child\n"
	"\tfnet moveif dev proc\n"
	"\tfnet printif\n"
	"\tfnet printif scan\n"
	"\tfnet config interface dev ip mask mtu\n"
	"\tfnet config mac addr\n"
	"\tfnet config ipv6 dev ip\n"
	"\tfnet ifup dev\n"
	"\tfnet waitll dev\n";

static void usage(void) {
	puts(usage_str);
}

int main(int argc, char **argv) {
#if 0
{
//system("cat /proc/self/status");
int i;
for (i = 0; i < argc; i++)
	printf("*%s* ", argv[i]);
printf("\n");
}
#endif
	if (argc < 2) {
		usage();
		return 1;
	}
	if (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-?") ==0) {
		usage();
		return 0;
	}

	warn_dumpable();

	char *quiet = getenv("FIREJAIL_QUIET");
	if (quiet && strcmp(quiet, "yes") == 0)
		arg_quiet = 1;

	if (argc == 3 && strcmp(argv[1], "ifup") == 0) {
		net_if_up(argv[2]);
	}
	else if (argc == 2 && strcmp(argv[1], "printif") == 0) {
		net_ifprint(0);
	}
	else if (argc == 3 && strcmp(argv[1], "printif") == 0 && strcmp(argv[2], "scan") == 0) {
		net_ifprint(1);
	}
	else if (argc == 7 && strcmp(argv[1], "create") == 0 && strcmp(argv[2], "veth") == 0) {
		// create veth pair and move one end in the the namespace
		net_create_veth(argv[3], argv[4], atoi(argv[6]));
		// connect the other veth end to the bridge ...
		net_bridge_add_interface(argv[5], argv[3]);
		// ... and bring it  up
		net_if_up(argv[3]);
	}
	else if (argc == 6 && strcmp(argv[1], "create") == 0 && strcmp(argv[2], "macvlan") == 0) {
		// use ipvlan for wireless devices
		// ipvlan driver was introduced in Linux kernel 3.19

		// check kernel version
		struct utsname u;
		int rv = uname(&u);
		if (rv != 0)
			errExit("uname");
		int major;
		int minor;
		if (2 != sscanf(u.release, "%d.%d", &major, &minor)) {
			fprintf(stderr, "Error fnet: cannot extract Linux kernel version: %s\n", u.version);
			exit(1);
		}

		if (major <= 3 && minor < 18)
			net_create_macvlan(argv[3], argv[4], atoi(argv[5]));
		else {
			struct stat s;
			char *fname;
			if (asprintf(&fname, "/sys/class/net/%s/wireless", argv[4]) == -1)
				errExit("asprintf");
			if (stat(fname, &s) == 0) // wireless
				net_create_ipvlan(argv[3], argv[4], atoi(argv[5]));
			else // regular ethernet
				net_create_macvlan(argv[3], argv[4], atoi(argv[5]));
		}
	}
	else if (argc == 7 && strcmp(argv[1], "config") == 0 && strcmp(argv[2], "interface") == 0) {
		char *dev = argv[3];
		uint32_t ip = (uint32_t)  atoll(argv[4]);
		uint32_t mask = (uint32_t)  atoll(argv[5]);
		int mtu = atoi(argv[6]);
		// configure interface
		net_if_ip(dev, ip, mask, mtu);
		// ... and bring it  up
		net_if_up(dev);
	}
	else if (argc == 5 && strcmp(argv[1], "config") == 0 && strcmp(argv[2], "mac") == 0) {
		unsigned char mac[6];
		if (atomac(argv[4], mac)) {
			fprintf(stderr, "Error fnet: invalid mac address %s\n", argv[4]);
		}
		net_if_mac(argv[3], mac);
	}
	else if (argc == 4 && strcmp(argv[1], "moveif") == 0) {
		net_move_interface(argv[2], atoi(argv[3]));
	}
	else if (argc == 5 && strcmp(argv[1], "config") == 0 && strcmp(argv[2], "ipv6") == 0) {
		net_if_ip6(argv[3], argv[4]);
	}
	else if (argc == 3 && strcmp(argv[1], "waitll") == 0) {
		net_if_waitll(argv[2]);
	}
	else {
		fprintf(stderr, "Error fnet: invalid arguments\n");
		return 1;
	}

	return 0;
}
