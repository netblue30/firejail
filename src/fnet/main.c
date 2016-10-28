 /*
 * Copyright (C) 2014-2016 Firejail Authors
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
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/prctl.h>
#include <linux/capability.h>

static void usage(void) {
	printf("Usage:\n");
	printf("\tfnet create veth dev1 dev2 bridge child\n");
	printf("\tfnet create macvlan dev parent child\n");
	printf("\tfnet moveif dev proc\n");
}

int main(int argc, char **argv) {
#if 0
{
system("cat /proc/self/status");
int i;
for (i = 0; i < argc; i++)
	printf("*%s* ", argv[i]);
printf("\n");
}	
#endif
	if (argc < 2)
		return 1;



	if (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-?") ==0) {
		usage();
		return 0;
	}
	else if (argc == 7 && strcmp(argv[1], "create") == 0 && strcmp(argv[2], "veth") == 0) {
		// create veth pair and move one end in the the namespace
		net_create_veth(argv[3], argv[4], atoi(argv[6]));
		
		// connect the ohter veth end to the bridge ...
		net_bridge_add_interface(argv[5], argv[3]);

		// ... and bring it  up
		net_if_up(argv[3]);
	}
	else if (argc == 6 && strcmp(argv[1], "create") == 0 && strcmp(argv[2], "macvlan") == 0) {
		net_create_macvlan(argv[3], argv[4], atoi(argv[5]));
	}
	else if (argc == 4 && strcmp(argv[1], "moveif") == 0) {
		net_move_interface(argv[2], atoi(argv[3]));
	}
	else {
		fprintf(stderr, "Error fnet: invalid arguments\n");
		return 1;
	}

	return 0;
}
