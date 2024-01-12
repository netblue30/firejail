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
#define MAXBUF 1024

int geoip_calls = 0;
static int geoip_not_found = 0;
static char buf[MAXBUF];

char *retrieve_hostname(uint32_t ip) {
	if (geoip_not_found)
		return NULL;
	if (access("/usr/bin/geoiplookup", X_OK)) {
		geoip_not_found = 1;
		return NULL;
	}
	geoip_calls++;

	char *rv = NULL;
	char *cmd;
	if (asprintf(&cmd, "/usr/bin/geoiplookup %d.%d.%d.%d", PRINT_IP(ip)) == -1)
		errExit("asprintf");

	FILE *fp = popen(cmd, "r");
	if (!fp) {
		geoip_not_found = 1;
		goto out;
	}

	char *ptr;
	if (fgets(buf, MAXBUF, fp)) {
		ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';
		if (strncmp(buf, "GeoIP Country Edition:", 22) == 0) {
			ptr = buf + 22;
			if (*ptr == ' ' && *(ptr + 3) == ',' && *(ptr + 4) == ' ') {
				rv = ptr + 5;
				if (strcmp(rv, "United States") == 0)
					rv = "US";
			}
		}
	}
	pclose(fp);
	if (rv)
		rv = strdup(rv);

out:
	free(cmd);
	return rv;
}

void load_hostnames(const char *fname) {
	assert(fname);
	FILE *fp = fopen(fname, "r");
	if (!fp) {
		fprintf(stderr, "Warning: cannot find %s file\n", fname);
		return;
	}

	char buf[MAXBUF];
	int line = 0;
	while (fgets(buf, MAXBUF, fp)) {
		line++;

		// skip empty spaces
		char *start = buf;
		while (*start == ' ' || *start == '\t')
			start++;
		// comments
		if (*start == '#')
			continue;
		char *end = strchr(start, '#');
		if (end)
			*end = '\0';

		// end
		end = strchr(start, '\n');
		if (end)
			*end = '\0';
		end = start + strlen(start);
		if (end == start)	// empty line
			continue;

		// line format: 1.2.3.4/32 name_without_empty_spaces
		// a single empty space between address and name
		end = strchr(start, ' ');
		if (!end)
			goto errexit;
		*end = '\0';
		end++;
		if (*end == '\0')
			goto errexit;

		uint32_t ip;
		uint32_t mask;
		if (atocidr(start, &ip, &mask)) {
			fprintf(stderr, "Error: invalid CIDR address\n");
			goto errexit;
		}

		radix_add(ip, mask, end);
	}

	fclose(fp);
	return;


errexit:
	fprintf(stderr, "Error: invalid line %d in file %s\n", line, fname);
	exit(1);
}
