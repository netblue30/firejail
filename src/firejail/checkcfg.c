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
#include "firejail.h"
#include "../include/seccomp.h"
#include "../include/syscall.h"
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
unsigned long join_timeout = 5000000; // microseconds
char *config_seccomp_error_action_str = "EPERM";
char **whitelist_reject_topdirs = NULL;

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
		cfg_val[CFG_SECCOMP_ERROR_ACTION] = -1;
		cfg_val[CFG_BROWSER_ALLOW_DRM] = 0;

		// open configuration file
		const char *fname = SYSCONFDIR "/firejail.config";
		fp = fopen(fname, "re");
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

#define PARSE_YESNO(key, string) \
			else if (strncmp(ptr, string " ", strlen(string)+1) == 0) { \
				if (strcmp(ptr + strlen(string) + 1, "yes") == 0) \
					cfg_val[key] = 1; \
				else if (strcmp(ptr + strlen(string) + 1, "no") == 0) \
					cfg_val[key] = 0; \
				else \
					goto errout; \
			}

			// parse line
			ptr = line_remove_spaces(buf);
			if (!ptr)
				continue;
			PARSE_YESNO(CFG_FILE_TRANSFER, "file-transfer")
			PARSE_YESNO(CFG_DBUS, "dbus")
			PARSE_YESNO(CFG_JOIN, "join")
			PARSE_YESNO(CFG_X11, "x11")
			PARSE_YESNO(CFG_APPARMOR, "apparmor")
			PARSE_YESNO(CFG_BIND, "bind")
			PARSE_YESNO(CFG_CGROUP, "cgroup")
			PARSE_YESNO(CFG_NAME_CHANGE, "name-change")
			PARSE_YESNO(CFG_USERNS, "userns")
			PARSE_YESNO(CFG_CHROOT, "chroot")
			PARSE_YESNO(CFG_FIREJAIL_PROMPT, "firejail-prompt")
			PARSE_YESNO(CFG_FORCE_NONEWPRIVS, "force-nonewprivs")
			PARSE_YESNO(CFG_SECCOMP, "seccomp")
			PARSE_YESNO(CFG_WHITELIST, "whitelist")
			PARSE_YESNO(CFG_NETWORK, "network")
			PARSE_YESNO(CFG_RESTRICTED_NETWORK, "restricted-network")
			PARSE_YESNO(CFG_XEPHYR_WINDOW_TITLE, "xephyr-window-title")
			PARSE_YESNO(CFG_OVERLAYFS, "overlayfs")
			PARSE_YESNO(CFG_PRIVATE_HOME, "private-home")
			PARSE_YESNO(CFG_PRIVATE_CACHE, "private-cache")
			PARSE_YESNO(CFG_PRIVATE_LIB, "private-lib")
			PARSE_YESNO(CFG_PRIVATE_BIN_NO_LOCAL, "private-bin-no-local")
			PARSE_YESNO(CFG_DISABLE_MNT, "disable-mnt")
			PARSE_YESNO(CFG_XPRA_ATTACH, "xpra-attach")
			PARSE_YESNO(CFG_BROWSER_DISABLE_U2F, "browser-disable-u2f")
			PARSE_YESNO(CFG_BROWSER_ALLOW_DRM, "browser-allow-drm")
#undef PARSE_YESNO

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
			// arp probes
			else if (strncmp(ptr, "arp-probes ", 11) == 0) {
				int arp_probes = atoi(ptr + 11);
				if (arp_probes <= 1 || arp_probes > 30)
					goto errout;
				cfg_val[CFG_ARP_PROBES] = arp_probes;
			}

			// file copy limit
			else if (strncmp(ptr, "file-copy-limit ", 16) == 0)
				env_store_name_val("FIREJAIL_FILE_COPY_LIMIT", ptr + 16, SETENV);

			// timeout for join option
			else if (strncmp(ptr, "join-timeout ", 13) == 0)
				join_timeout = strtoul(ptr + 13, NULL, 10) * 1000000; // seconds to microseconds

			// seccomp error action
			else if (strncmp(ptr, "seccomp-error-action ", 21) == 0) {
				if (strcmp(ptr + 21, "kill") == 0)
					cfg_val[CFG_SECCOMP_ERROR_ACTION] = SECCOMP_RET_KILL;
				else if (strcmp(ptr + 21, "log") == 0)
					cfg_val[CFG_SECCOMP_ERROR_ACTION] = SECCOMP_RET_LOG;
				else {
					cfg_val[CFG_SECCOMP_ERROR_ACTION] = errno_find_name(ptr + 21);
					if (cfg_val[CFG_SECCOMP_ERROR_ACTION] == -1)
						errExit("seccomp-error-action: unknown errno");
				}
				config_seccomp_error_action_str = strdup(ptr + 21);
				if (!config_seccomp_error_action_str)
					errExit("strdup");
			}

			else if (strncmp(ptr, "whitelist-disable-topdir ", 25) == 0) {
				char *str = strdup(ptr + 25);
				if (!str)
					errExit("strdup");

				size_t cnt = 0;
				size_t sz = 4;
				whitelist_reject_topdirs = malloc(sz * sizeof(char *));
				if (!whitelist_reject_topdirs)
					errExit("malloc");

				char *tok = strtok(str, ",");
				while (tok) {
					whitelist_reject_topdirs[cnt++] = tok;
					if (cnt >= sz) {
						sz *= 2;
						whitelist_reject_topdirs = realloc(whitelist_reject_topdirs, sz * sizeof(char *));
						if (!whitelist_reject_topdirs)
							errExit("realloc");
					}
					tok = strtok(NULL, ",");
				}
				whitelist_reject_topdirs[cnt] = NULL;
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
	printf("\t- always force nonewprivs support is %s\n",
#ifdef HAVE_FORCE_NONEWPRIVS
		"enabled"
#else
		"disabled"
#endif
		);

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

	printf("\t- D-BUS proxy support is %s\n",
#ifdef HAVE_DBUSPROXY
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

	printf("\t- firetunnel support is %s\n",
#ifdef HAVE_FIRETUNNEL
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

	printf("\t- output logging is %s\n",
#ifdef HAVE_OUTPUT
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

	printf("\t- private-cache and tmpfs as user %s\n",
#ifdef HAVE_USERTMPFS
		"enabled"
#else
		"disabled"
#endif
		);

	printf("\t- SELinux support is %s\n",
#ifdef HAVE_SELINUX
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
