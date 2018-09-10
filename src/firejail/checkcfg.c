/*
 * Copyright (C) 2014-2018 Firejail Authors
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
#include "firejail.h"
#include <sys/stat.h>
#include <linux/loop.h>

#define MAX_READ 8192				  // line buffer for profile files

static int initialized = 0;
static int cfg_val[CFG_MAX];
char *netfilter_default = NULL;

int checkcfg(int val) {
	assert(val < CFG_MAX);
	int line = 0;
	FILE *fp = NULL;
	char *ptr;

	if (!initialized) {
		// initialize defaults
		int i;
		for (i = 0; i < CFG_MAX; i++)
			cfg_val[i] = 1; // most of them are enabled by default
		cfg_val[CFG_RESTRICTED_NETWORK] = 0; // disabled by default
		cfg_val[CFG_FORCE_NONEWPRIVS] = 0;
		cfg_val[CFG_FIREJAIL_PROMPT] = 0;
		cfg_val[CFG_DISABLE_MNT] = 0;
		cfg_val[CFG_ARP_PROBES] = DEFAULT_ARP_PROBES;

		// open configuration file
		const char *fname = SYSCONFDIR "/firejail.config";
		fp = fopen(fname, "r");
		if (!fp) {
#ifdef HAVE_GLOBALCFG
			fprintf(stderr, "Error: Firejail configuration file %s not found\n", fname);
			exit(1);
#else
			initialized = 1;
			return	cfg_val[val];
#endif
		}

		// read configuration file
		char buf[MAX_READ];
		while (fgets(buf,MAX_READ, fp)) {
			line++;
			if (*buf == '#' || *buf == '\n')
				continue;

			// parse line
			ptr = line_remove_spaces(buf);
			if (!ptr)
				continue;
			// apparmor
			else if (strncmp(ptr, "apparmor ", 9) == 0) {
				if (strcmp(ptr + 9, "yes") == 0)
					cfg_val[CFG_APPARMOR] = 1;
				else if (strcmp(ptr + 9, "no") == 0)
					cfg_val[CFG_APPARMOR] = 0;
				else
					goto errout;
			}
			// arp probes
			else if (strncmp(ptr, "arp-probes ", 11) == 0) {
				int arp_probes = atoi(ptr + 11);
				if (arp_probes <= 1 || arp_probes > 30)
					goto errout;
				cfg_val[CFG_ARP_PROBES] = arp_probes;
			}
			// bind
			else if (strncmp(ptr, "bind ", 5) == 0) {
				if (strcmp(ptr + 5, "yes") == 0)
					cfg_val[CFG_BIND] = 1;
				else if (strcmp(ptr + 5, "no") == 0)
					cfg_val[CFG_BIND] = 0;
				else
					goto errout;
			}
			// dbus
			else if (strncmp(ptr, "dbus ", 5) == 0) {
				if (strcmp(ptr + 5, "yes") == 0)
					cfg_val[CFG_DBUS] = 1;
				else if (strcmp(ptr + 5, "no") == 0)
					cfg_val[CFG_DBUS] = 0;
				else
					goto errout;
			}
			else if (strncmp(ptr, "disable-mnt ", 12) == 0) {
				if (strcmp(ptr + 12, "yes") == 0)
					cfg_val[CFG_DISABLE_MNT] = 1;
				else if (strcmp(ptr + 12, "no") == 0)
					cfg_val[CFG_DISABLE_MNT] = 0;
				else
					goto errout;
			}
			// prompt
			else if (strncmp(ptr, "firejail-prompt ", 16) == 0) {
				if (strcmp(ptr + 16, "yes") == 0)
					cfg_val[CFG_FIREJAIL_PROMPT] = 1;
				else if (strcmp(ptr + 16, "no") == 0)
					cfg_val[CFG_FIREJAIL_PROMPT] = 0;
				else
					goto errout;
			}
			// follow symlink as user
			else if (strncmp(ptr, "follow-symlink-as-user ", 23) == 0) {
				if (strcmp(ptr + 23, "yes") == 0)
					cfg_val[CFG_FOLLOW_SYMLINK_AS_USER] = 1;
				else if (strcmp(ptr + 23, "no") == 0)
					cfg_val[CFG_FOLLOW_SYMLINK_AS_USER] = 0;
				else
					goto errout;
			}
			// nonewprivs
			else if (strncmp(ptr, "force-nonewprivs ", 17) == 0) {
				if (strcmp(ptr + 17, "yes") == 0)
					cfg_val[CFG_FORCE_NONEWPRIVS] = 1;
				else if (strcmp(ptr + 17, "no") == 0)
					cfg_val[CFG_FORCE_NONEWPRIVS] = 0;
				else
					goto errout;
			}
			// join
			else if (strncmp(ptr, "join ", 5) == 0) {
				if (strcmp(ptr + 5, "yes") == 0)
					cfg_val[CFG_JOIN] = 1;
				else if (strcmp(ptr + 5, "no") == 0)
					cfg_val[CFG_JOIN] = 0;
				else
					goto errout;
			}
			// network
			else if (strncmp(ptr, "network ", 8) == 0) {
				if (strcmp(ptr + 8, "yes") == 0)
					cfg_val[CFG_NETWORK] = 1;
				else if (strcmp(ptr + 8, "no") == 0)
					cfg_val[CFG_NETWORK] = 0;
				else
					goto errout;
			}
			// quiet by default
			else if (strncmp(ptr, "quiet-by-default ", 17) == 0) {
				if (strcmp(ptr + 17, "yes") == 0)
					arg_quiet = 1;
				else if (strcmp(ptr + 17, "no") == 0)
					arg_quiet = 0;
				else
					goto errout;
			}
			// network
			else if (strncmp(ptr, "restricted-network ", 19) == 0) {
				if (strcmp(ptr + 19, "yes") == 0)
					cfg_val[CFG_RESTRICTED_NETWORK] = 1;
				else if (strcmp(ptr + 19, "no") == 0)
					cfg_val[CFG_RESTRICTED_NETWORK] = 0;
				else
					goto errout;
			}
			// netfilter
			else if (strncmp(ptr, "netfilter-default ", 18) == 0) {
				char *fname = ptr + 18;
				while (*fname == ' ' || *fname == '\t')
					ptr++;
				char *end = strchr(fname, ' ');
				if (end)
					*end = '\0';

				// is the file present?
				struct stat s;
				if (stat(fname, &s) == -1) {
					fprintf(stderr, "Error: netfilter-default file %s not available\n", fname);
					exit(1);
				}

				if (netfilter_default)
					goto errout;
				netfilter_default = strdup(fname);
				if (!netfilter_default)
					errExit("strdup");
				if (arg_debug)
					printf("netfilter default file %s\n", fname);
			}
			// seccomp
			else if (strncmp(ptr, "seccomp ", 8) == 0) {
				if (strcmp(ptr + 8, "yes") == 0)
					cfg_val[CFG_SECCOMP] = 1;
				else if (strcmp(ptr + 8, "no") == 0)
					cfg_val[CFG_SECCOMP] = 0;
				else
					goto errout;
			}
			// user namespace
			else if (strncmp(ptr, "userns ", 7) == 0) {
				if (strcmp(ptr + 7, "yes") == 0)
					cfg_val[CFG_USERNS] = 1;
				else if (strcmp(ptr + 7, "no") == 0)
					cfg_val[CFG_USERNS] = 0;
				else
					goto errout;
			}
			// whitelist
			else if (strncmp(ptr, "whitelist ", 10) == 0) {
				if (strcmp(ptr + 10, "yes") == 0)
					cfg_val[CFG_WHITELIST] = 1;
				else if (strcmp(ptr + 10, "no") == 0)
					cfg_val[CFG_WHITELIST] = 0;
				else
					goto errout;
			}
			else
				goto errout;

			free(ptr);
		}

		fclose(fp);
		initialized = 1;
	}


	// merge CFG_RESTRICTED_NETWORK into CFG_NETWORK
	if (val == CFG_NETWORK) {
		if (cfg_val[CFG_RESTRICTED_NETWORK] && getuid() != 0)
			return 0;
	}

	return cfg_val[val];

errout:
	assert(ptr);
	free(ptr);
	assert(fp);
	fclose(fp);
	fprintf(stderr, "Error: invalid line %d in firejail configuration file\n", line );
	exit(1);
}


void print_compiletime_support(void) {
	printf("Compile time support:\n");
	printf("\t- AppArmor support is %s\n",
#ifdef HAVE_APPARMOR
		"enabled"
#else
		"disabled"
#endif
		);

	printf("\t- AppImage support is %s\n",
#ifdef LOOP_CTL_GET_FREE	// test for older kernels; this definition is found in /usr/include/linux/loop.h
		"enabled"
#else
		"disabled"
#endif
		);

	printf("\t- file and directory whitelisting support is %s\n",
#ifdef HAVE_WHITELIST
		"enabled"
#else
		"disabled"
#endif
		);

	printf("\t- networking support is %s\n",
#ifdef HAVE_NETWORK
		"enabled"
#else
		"disabled"
#endif
		);

	printf("\t- seccomp-bpf support is %s\n",
#ifdef HAVE_SECCOMP
		"enabled"
#else
		"disabled"
#endif
		);

	printf("\t- user namespace support is %s\n",
#ifdef HAVE_USERNS
		"enabled"
#else
		"disabled"
#endif
		);
}
