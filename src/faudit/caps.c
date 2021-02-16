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

#include "faudit.h"
#include <linux/capability.h>

#define MAXBUF 4098
static int extract_caps(uint64_t *val) {
	FILE *fp = fopen("/proc/self/status", "r");
	if (!fp)
		return 1;

	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp)) {
		if (strncmp(buf, "CapBnd:\t", 8) == 0) {
			char *ptr = buf + 8;
			unsigned long long tmp;
			sscanf(ptr, "%llx", &tmp);
			*val = tmp;
			fclose(fp);
			return 0;
		}
	}

	fclose(fp);
	return 1;
}

// return 1 if the capability is in the map
static int check_capability(uint64_t map, int cap) {
	int i;
	uint64_t mask = 1ULL;

	for (i = 0; i < 64; i++, mask <<= 1) {
		if ((i == cap) && (mask & map))
			return 1;
	}

	return 0;
}

void caps_test(void) {
	uint64_t caps_val;

	if (extract_caps(&caps_val)) {
		printf("SKIP: cannot extract capabilities on this platform.\n");
		return;
	}

	if (caps_val) {
		printf("BAD: the capability map is %llx, it should be all zero. ", (unsigned long long) caps_val);
		printf("Use \"firejail --caps.drop=all\" to fix it.\n");

		if (check_capability(caps_val, CAP_SYS_ADMIN))
			printf("UGLY: CAP_SYS_ADMIN is enabled.\n");
		if (check_capability(caps_val, CAP_SYS_BOOT))
			printf("UGLY: CAP_SYS_BOOT is enabled.\n");
	}
	else
		printf("GOOD: all capabilities are disabled.\n");
}
