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
#include "firejail.h"
#include <sys/stat.h>
#include <linux/loop.h>

#define MAX_READ 8192				  // line buffer for profile files

static int initialized = 0;
static int cfg_val[CFG_MAX];
char *xephyr_screen = "800x600";
char *xephyr_extra_params = "";
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
		cfg_val[CFG_FORCE_NONEWPRIVS] = 0; // disabled by default
		cfg_val[CFG_PRIVATE_BIN_NO_LOCAL] = 0; // disabled by default
		cfg_val[CFG_FIREJAIL_PROMPT] = 0; // disabled by default
		
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
			if (strncmp(ptr, "file-transfer ", 14) == 0) {
				if (strcmp(ptr + 14, "yes") == 0)
					cfg_val[CFG_FILE_TRANSFER] = 1;
				else if (strcmp(ptr + 14, "no") == 0)
					cfg_val[CFG_FILE_TRANSFER] = 0;
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
			// bind
			else if (strncmp(ptr, "bind ", 5) == 0) {
				if (strcmp(ptr + 5, "yes") == 0)
					cfg_val[CFG_BIND] = 1;
				else if (strcmp(ptr + 5, "no") == 0)
					cfg_val[CFG_BIND] = 0;
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
			// nonewprivs
			else if (strncmp(ptr, "force-nonewprivs ", 17) == 0) {
				if (strcmp(ptr + 17, "yes") == 0)
					cfg_val[CFG_SECCOMP] = 1;
				else if (strcmp(ptr + 17, "no") == 0)
					cfg_val[CFG_SECCOMP] = 0;
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
			else if (strncmp(ptr, "xephyr-extra-params ", 19) == 0) {
				if (*xephyr_extra_params != '\0')
					goto errout;
				xephyr_extra_params = strdup(ptr + 19);
				if (!xephyr_extra_params)
					errExit("strdup");
			}
			
			// quiet by default
			else if (strncmp(ptr, "quiet-by-default ", 17) == 0) {
				if (strcmp(ptr + 17, "yes") == 0)
					arg_quiet = 1;
			}
			// remount /proc and /sys
			else if (strncmp(ptr, "remount-proc-sys ", 17) == 0) {
				if (strcmp(ptr + 17, "yes") == 0)
					cfg_val[CFG_REMOUNT_PROC_SYS] = 1;
				else if (strcmp(ptr + 17, "no") == 0)
					cfg_val[CFG_REMOUNT_PROC_SYS] = 0;
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
			else if (strncmp(ptr, "chroot-desktop ", 15) == 0) {
				if (strcmp(ptr + 15, "yes") == 0)
					cfg_val[CFG_CHROOT_DESKTOP] = 1;
				else if (strcmp(ptr + 15, "no") == 0)
					cfg_val[CFG_CHROOT_DESKTOP] = 0;
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
			else
				goto errout;

			free(ptr);
		}

		fclose(fp);
		initialized = 1;
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

	printf("\t- bind support is %s\n",
#ifdef HAVE_BIND
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


#ifdef HAVE_NETWORK_RESTRICTED
	printf("\t- networking features are available only to root user\n");
#endif

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
