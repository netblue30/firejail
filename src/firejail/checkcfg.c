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
char *xephyr_screen = "800x600";
char *xephyr_extra_params = "";
char *xpra_extra_params = "";
char *xvfb_screen = "800x600x24";
char *xvfb_extra_params = "";
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
		cfg_val[CFG_PRIVATE_BIN_NO_LOCAL] = 0;
		cfg_val[CFG_FIREJAIL_PROMPT] = 0;
		cfg_val[CFG_DISABLE_MNT] = 0;
		cfg_val[CFG_ARP_PROBES] = DEFAULT_ARP_PROBES;
		cfg_val[CFG_XPRA_ATTACH] = 0;

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

			// file transfer
			else if (strncmp(ptr, "file-transfer ", 14) == 0) {
				if (strcmp(ptr + 14, "yes") == 0)
					cfg_val[CFG_FILE_TRANSFER] = 1;
				else if (strcmp(ptr + 14, "no") == 0)
					cfg_val[CFG_FILE_TRANSFER] = 0;
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
			// join
			else if (strncmp(ptr, "join ", 5) == 0) {
				if (strcmp(ptr + 5, "yes") == 0)
					cfg_val[CFG_JOIN] = 1;
				else if (strcmp(ptr + 5, "no") == 0)
					cfg_val[CFG_JOIN] = 0;
				else
					goto errout;
			}
			// x11
			else if (strncmp(ptr, "x11 ", 4) == 0) {
				if (strcmp(ptr + 4, "yes") == 0)
					cfg_val[CFG_X11] = 1;
				else if (strcmp(ptr + 4, "no") == 0)
					cfg_val[CFG_X11] = 0;
				else
					goto errout;
			}
			// apparmor
			else if (strncmp(ptr, "apparmor ", 9) == 0) {
				if (strcmp(ptr + 9, "yes") == 0)
					cfg_val[CFG_APPARMOR] = 1;
				else if (strcmp(ptr + 9, "no") == 0)
					cfg_val[CFG_APPARMOR] = 0;
				else
					goto errout;
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
			// cgroup
			else if (strncmp(ptr, "cgroup ", 7) == 0) {
				if (strcmp(ptr + 7, "yes") == 0)
					cfg_val[CFG_CGROUP] = 1;
				else if (strcmp(ptr + 7, "no") == 0)
					cfg_val[CFG_CGROUP] = 0;
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
			// chroot
			else if (strncmp(ptr, "chroot ", 7) == 0) {
				if (strcmp(ptr + 7, "yes") == 0)
					cfg_val[CFG_CHROOT] = 1;
				else if (strcmp(ptr + 7, "no") == 0)
					cfg_val[CFG_CHROOT] = 0;
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
			// seccomp
			else if (strncmp(ptr, "seccomp ", 8) == 0) {
				if (strcmp(ptr + 8, "yes") == 0)
					cfg_val[CFG_SECCOMP] = 1;
				else if (strcmp(ptr + 8, "no") == 0)
					cfg_val[CFG_SECCOMP] = 0;
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
			// network
			else if (strncmp(ptr, "network ", 8) == 0) {
				if (strcmp(ptr + 8, "yes") == 0)
					cfg_val[CFG_NETWORK] = 1;
				else if (strcmp(ptr + 8, "no") == 0)
					cfg_val[CFG_NETWORK] = 0;
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

			// Xephyr screen size
			else if (strncmp(ptr, "xephyr-screen ", 14) == 0) {
				// expecting two numbers and an x between them
				int n1;
				int n2;
				int rv = sscanf(ptr + 14, "%dx%d", &n1, &n2);
				if (rv != 2)
					goto errout;
				if (asprintf(&xephyr_screen, "%dx%d", n1, n2) == -1)
					errExit("asprintf");
			}

			// xephyr window title
			else if (strncmp(ptr, "xephyr-window-title ", 20) == 0) {
				if (strcmp(ptr + 20, "yes") == 0)
					cfg_val[CFG_XEPHYR_WINDOW_TITLE] = 1;
				else if (strcmp(ptr + 20, "no") == 0)
					cfg_val[CFG_XEPHYR_WINDOW_TITLE] = 0;
				else
					goto errout;
			}

			// Xephyr command extra parameters
			else if (strncmp(ptr, "xephyr-extra-params ", 20) == 0) {
				if (*xephyr_extra_params != '\0')
					goto errout;
				xephyr_extra_params = strdup(ptr + 20);
				if (!xephyr_extra_params)
					errExit("strdup");
			}

			// xpra server extra parameters
			else if (strncmp(ptr, "xpra-extra-params ", 18) == 0) {
				if (*xpra_extra_params != '\0')
					goto errout;
				xpra_extra_params = strdup(ptr + 18);
				if (!xpra_extra_params)
					errExit("strdup");
			}

			// Xvfb screen size
	            		else if (strncmp(ptr, "xvfb-screen ", 12) == 0) {
				// expecting three numbers separated by x's
				unsigned int n1;
				unsigned int n2;
				unsigned int n3;
				int rv = sscanf(ptr + 12, "%ux%ux%u", &n1, &n2, &n3);
				if (rv != 3)
					goto errout;
				if (asprintf(&xvfb_screen, "%ux%ux%u", n1, n2, n3) == -1)
					errExit("asprintf");
			}

			// Xvfb extra parameters
			else if (strncmp(ptr, "xvfb-extra-params ", 18) == 0) {
				if (*xvfb_extra_params != '\0')
					goto errout;
				xvfb_extra_params = strdup(ptr + 18);
				if (!xvfb_extra_params)
					errExit("strdup");
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
			else if (strncmp(ptr, "overlayfs ", 10) == 0) {
				if (strcmp(ptr + 10, "yes") == 0)
					cfg_val[CFG_OVERLAYFS] = 1;
				else if (strcmp(ptr + 10, "no") == 0)
					cfg_val[CFG_OVERLAYFS] = 0;
				else
					goto errout;
			}
			else if (strncmp(ptr, "private-home ", 13) == 0) {
				if (strcmp(ptr + 13, "yes") == 0)
					cfg_val[CFG_PRIVATE_HOME] = 1;
				else if (strcmp(ptr + 13, "no") == 0)
					cfg_val[CFG_PRIVATE_HOME] = 0;
				else
					goto errout;
			}
			else if (strncmp(ptr, "private-cache ", 14) == 0) {
				if (strcmp(ptr + 14, "yes") == 0)
					cfg_val[CFG_PRIVATE_CACHE] = 1;
				else if (strcmp(ptr + 14, "no") == 0)
					cfg_val[CFG_PRIVATE_CACHE] = 0;
				else
					goto errout;
			}
			else if (strncmp(ptr, "private-lib ", 12) == 0) {
				if (strcmp(ptr + 12, "yes") == 0)
					cfg_val[CFG_PRIVATE_LIB] = 1;
				else if (strcmp(ptr + 12, "no") == 0)
					cfg_val[CFG_PRIVATE_LIB] = 0;
				else
					goto errout;
			}
			else if (strncmp(ptr, "private-bin-no-local ", 21) == 0) {
				if (strcmp(ptr + 21, "yes") == 0)
					cfg_val[CFG_PRIVATE_BIN_NO_LOCAL] = 1;
				else if (strcmp(ptr + 21, "no") == 0)
					cfg_val[CFG_PRIVATE_BIN_NO_LOCAL] = 0;
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
			// arp probes
			else if (strncmp(ptr, "arp-probes ", 11) == 0) {
				int arp_probes = atoi(ptr + 11);
				if (arp_probes <= 1 || arp_probes > 30)
					goto errout;
				cfg_val[CFG_ARP_PROBES] = arp_probes;
			}
			// xpra-attach
			else if (strncmp(ptr, "xpra-attach ", 12) == 0) {
				if (strcmp(ptr + 12, "yes") == 0)
					cfg_val[CFG_XPRA_ATTACH] = 1;
				else if (strcmp(ptr + 12, "no") == 0)
					cfg_val[CFG_XPRA_ATTACH] = 0;
				else
					goto errout;
			}
			// browser-disable-u2f
			else if (strncmp(ptr, "browser-disable-u2f ", 20) == 0) {
				if (strcmp(ptr + 20, "yes") == 0)
					cfg_val[CFG_BROWSER_DISABLE_U2F] = 1;
				else if (strcmp(ptr + 20, "no") == 0)
					cfg_val[CFG_BROWSER_DISABLE_U2F] = 0;
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

	printf("\t- chroot support is %s\n",
#ifdef HAVE_CHROOT
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

	printf("\t- file transfer support is %s\n",
#ifdef HAVE_FILE_TRANSFER
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

	printf("\t- overlayfs support is %s\n",
#ifdef HAVE_OVERLAYFS
		"enabled"
#else
		"disabled"
#endif
		);

	printf("\t- private-home support is %s\n",
#ifdef HAVE_PRIVATE_HOME
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

	printf("\t- X11 sandboxing support is %s\n",
#ifdef HAVE_X11
		"enabled"
#else
		"disabled"
#endif
		);
}
