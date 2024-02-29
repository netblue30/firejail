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
#include "firejail.h"
#include "../include/gcov_wrapper.h"
#include "../include/seccomp.h"
#include "../include/syscall.h"
#include <dirent.h>
#include <sys/stat.h>

extern char *xephyr_screen;

#define MAX_READ 8192		// line buffer for profile files
#define MAX_LIST 16384		// size limit for argument lists

// find and read the profile specified by name from dir directory
// return  1 if a profile was found
static int profile_find(const char *name, const char *dir, int add_ext) {
	EUID_ASSERT();
	assert(name);
	assert(dir);

	int rv = 0;
	DIR *dp;
	char *pname = NULL;
	if (add_ext) {
		if (asprintf(&pname, "%s.profile", name) == -1)
			errExit("asprintf");
		else
			name = pname;
	}

	dp = opendir (dir);
	if (dp != NULL) {
		struct dirent *ep;
		while ((ep = readdir(dp)) != NULL) {
			if (strcmp(ep->d_name, name) == 0) {
				if (arg_debug)
					printf("Found %s profile in %s directory\n", name, dir);
				char *etcpname;
				if (asprintf(&etcpname, "%s/%s", dir, name) == -1)
					errExit("asprintf");
				profile_read(etcpname);
				free(etcpname);
				rv = 1;
				break;
			}
		}
		(void) closedir (dp);
	}

	if (pname)
		free(pname);
	return rv;
}

// search and read the profile specified by name from firejail directories
// return  1 if a profile was found
int profile_find_firejail(const char *name, int add_ext) {
#ifndef HAVE_ONLY_SYSCFG_PROFILES
	// look for a profile in ~/.config/firejail directory
	char *usercfgdir;
	if (asprintf(&usercfgdir, "%s/.config/firejail", cfg.homedir) == -1)
		errExit("asprintf");
	int rv = profile_find(name, usercfgdir, add_ext);
	free(usercfgdir);

	if (!rv)
		// look for a user profile in /etc/firejail directory
		rv = profile_find(name, SYSCONFDIR, add_ext);

	return rv;
#else
	return profile_find(name, SYSCONFDIR, add_ext);
#endif
}

//***************************************************
// run-time profiles
//***************************************************

static void warning_feature_disabled(const char *feature) {
	fwarning("%s feature is disabled in Firejail configuration file\n", feature);
}


static int is_in_ignore_list(char *ptr) {
	// check ignore list
	int i;
	for (i = 0; i < MAX_PROFILE_IGNORE; i++) {
		if (cfg.profile_ignore[i] == NULL)
			break;

		int len = strlen(cfg.profile_ignore[i]);
		if (strncmp(ptr, cfg.profile_ignore[i], len) == 0) {
			// full word match
			if (*(ptr + len) == '\0' || *(ptr + len) == ' ')
				return 1;	// ignore line
		}
	}

	return 0;
}

void profile_add_ignore(const char *str) {
	assert(str);
	if (*str == '\0') {
		fprintf(stderr, "Error: invalid ignore option\n");
		exit(1);
	}

	// find an empty entry in profile_ignore array
	int i;
	for (i = 0; i < MAX_PROFILE_IGNORE; i++) {
		if (cfg.profile_ignore[i] == NULL)
			break;
	}
	if (i >= MAX_PROFILE_IGNORE) {
		fprintf(stderr, "Error: maximum %d --ignore options are permitted\n", MAX_PROFILE_IGNORE);
		exit(1);
	}
	// ... and configure it
	else {
		cfg.profile_ignore[i] = strdup(str);
		if (!cfg.profile_ignore[i])
			errExit("strdup");
	}
}

typedef struct cond_t {
	const char *name;	// conditional name
	int (*check)(void);	// true if set
} Cond;

static int check_appimage(void) {
	return arg_appimage != 0;
}

static int check_netoptions(void) {
	return (arg_nonetwork || any_bridge_configured());
}

static int check_nodbus(void) {
	return arg_dbus_user != DBUS_POLICY_ALLOW || arg_dbus_system != DBUS_POLICY_ALLOW;
}

static int check_nosound(void) {
	return arg_nosound != 0;
}

static int check_private(void) {
	return arg_private;
}

static int check_x11(void) {
	return (arg_x11_block || arg_x11_xorg || env_get("FIREJAIL_X11"));
}

static int check_disable_u2f(void) {
	return checkcfg(CFG_BROWSER_DISABLE_U2F) != 0;
}

static int check_allow_drm(void) {
	return checkcfg(CFG_BROWSER_ALLOW_DRM) != 0;
}

static int check_allow_tray(void) {
	return checkcfg(CFG_ALLOW_TRAY) != 0;
}

Cond conditionals[] = {
	{"HAS_APPIMAGE", check_appimage},
	{"HAS_NET", check_netoptions},
	{"HAS_NODBUS", check_nodbus},
	{"HAS_NOSOUND", check_nosound},
	{"HAS_PRIVATE", check_private},
	{"HAS_X11", check_x11},
	{"BROWSER_DISABLE_U2F", check_disable_u2f},
	{"BROWSER_ALLOW_DRM", check_allow_drm},
	{"ALLOW_TRAY", check_allow_tray},
	{ NULL, NULL }
};

int profile_check_conditional(char *ptr, int lineno, const char *fname) {
	char *tmp = ptr, *msg = NULL;

	if (*ptr++ != '?')
		return 1;

	Cond *cond = conditionals;
	while (cond->name) {
		// continue if not this conditional
		if (strncmp(ptr, cond->name, strlen(cond->name)) != 0) {
			cond++;
			continue;
		}
		ptr += strlen(cond->name);

		if (*ptr == ' ')
			ptr++;
		if (*ptr++ != ':') {
			msg = "invalid conditional syntax: colon must come after conditional";
			ptr = tmp;
			goto error;
		}
		if (*ptr == '\0') {
			msg = "invalid conditional syntax: no profile line after conditional";
			ptr = tmp;
			goto error;
		}
		if (*ptr == ' ')
			ptr++;

		// if set, continue processing statement in caller
		int value = cond->check();
		if (value) {
			// move ptr to start of profile line
			ptr = strdup(ptr);
			if (!ptr)
				errExit("strdup");

			// check that the profile line does not contain either
			// quiet or include directives
			if ((strncmp(ptr, "quiet", 5) == 0) ||
			    (strncmp(ptr, "include", 7) == 0)) {
				msg = "invalid conditional syntax: quiet and include not allowed in conditionals";
				ptr = tmp;
				goto error;
			}
			free(tmp);

			// verify syntax, exit in case of error
			if (arg_debug)
				printf("conditional %s, %s\n", cond->name, ptr);
			if (profile_check_line(ptr, lineno, fname))
				profile_add(ptr);
		}
		// tell caller to ignore
		return 0;
	}

	tmp = ptr;
	// get the conditional used
	while (*tmp != ':' && *tmp != '\0')
		tmp++;
	*tmp = '\0';

	// this was a '?' prefix, but didn't match any of the conditionals
	msg = "invalid/unsupported conditional";

error:
	fprintf(stderr, "Error: %s (\"%s\"", msg, ptr);
	if (lineno == 0) ;
	else if (fname != NULL)
		fprintf(stderr, " on line %d in %s", lineno, fname);
	else
		fprintf(stderr, " on line %d in the custom profile", lineno);
	fprintf(stderr, ")\n");
	exit(1);
}


// check profile line; if line == 0, this was generated from a command line option
// return 1 if the command is to be added to the linked list of profile commands
// return 0 if the command was already executed inside the function
int profile_check_line(char *ptr, int lineno, const char *fname) {
	EUID_ASSERT();

	// check and process conditional profile lines
	if (profile_check_conditional(ptr, lineno, fname) == 0)
		return 0;

	// check ignore list
	if (is_in_ignore_list(ptr))
		return 0;

	if (strncmp(ptr, "ignore ", 7) == 0) {
		profile_add_ignore(ptr + 7);
		return 0;
	}

	if (strncmp(ptr, "keep-fd ", 8) == 0) {
		if (strcmp(ptr + 8, "all") == 0)
			arg_keep_fd_all = 1;
		else {
			const char *add = ptr + 8;
			profile_list_augment(&cfg.keep_fd, add);
		}
		return 0;
	}
	if (strncmp(ptr, "xephyr-screen ", 14) == 0) {
#ifdef HAVE_X11
		if (checkcfg(CFG_X11)) {
			xephyr_screen = ptr + 14;
		}
		else
			warning_feature_disabled("x11");
#endif
		return 0;
	}
	// mkdir
	if (strncmp(ptr, "mkdir ", 6) == 0) {
		fs_mkdir(ptr + 6);
		return 1;	// process mkdir again while applying blacklists
	}
	// mkfile
	if (strncmp(ptr, "mkfile ", 7) == 0) {
		fs_mkfile(ptr + 7);
		return 1;	// process mkfile again while applying blacklists
	}
	// sandbox name
	else if (strncmp(ptr, "name ", 5) == 0) {
		cfg.name = ptr + 5;
		if (strlen(cfg.name) == 0) {
			fprintf(stderr, "Error: invalid sandbox name: cannot be empty\n");
			exit(1);
		}
		if (invalid_name(cfg.name)) {
			fprintf(stderr, "Error: invalid sandbox name\n");
			exit(1);
		}
		return 0;
	}
	else if (strcmp(ptr, "ipc-namespace") == 0) {
		arg_ipc = 1;
		return 0;
	}
	// seccomp, caps, private, user namespace
	else if (strcmp(ptr, "noroot") == 0) {
#if HAVE_USERNS
		if (checkcfg(CFG_USERNS))
			check_user_namespace();
		else
			warning_feature_disabled("noroot");
#endif

		return 0;
	}
	else if (strcmp(ptr, "nonewprivs") == 0) {
		arg_nonewprivs = 1;
		return 0;
	}
	else if (strcmp(ptr, "seccomp") == 0) {
		if (checkcfg(CFG_SECCOMP))
			arg_seccomp = 1;
		else
			warning_feature_disabled("seccomp");
		return 0;
	}
	else if (strcmp(ptr, "caps") == 0) {
		arg_caps_default_filter = 1;
		return 0;
	}
	else if (strcmp(ptr, "caps.drop all") == 0) {
		arg_caps_drop_all = 1;
		return 0;
	}
	else if (strcmp(ptr, "shell ") == 0) {
		fprintf(stderr, "Warning: \"shell none\" is done by default now; the \"shell\" command has been removed\n");
		return 0;
	}
	else if (strcmp(ptr, "tracelog") == 0) {
		if (checkcfg(CFG_TRACELOG))
			arg_tracelog = 1;
		// no warning, we have tracelog in over 400 profiles
		return 0;
	}
	else if (strcmp(ptr, "private") == 0) {
		arg_private = 1;
		return 0;
	}
	else if (strncmp(ptr, "private-home ", 13) == 0) {
#ifdef HAVE_PRIVATE_HOME
		if (checkcfg(CFG_PRIVATE_HOME)) {
			if (cfg.home_private_keep) {
				if ( asprintf(&cfg.home_private_keep, "%s,%s", cfg.home_private_keep, ptr + 13) < 0 )
					errExit("asprintf");
			} else
				cfg.home_private_keep = ptr + 13;
			arg_private = 1;
		}
		else
			warning_feature_disabled("private-home");
#endif
		return 0;
	}
	else if (strcmp(ptr, "tab") == 0) {
		arg_tab = 1;
		return 0;
	}
	else if (strcmp(ptr, "private-cwd") == 0) {
		cfg.cwd = NULL;
		arg_private_cwd = 1;
		return 0;
	}
	else if (strncmp(ptr, "private-cwd ", 12) == 0) {
		fs_check_private_cwd(ptr + 12);
		arg_private_cwd = 1;
		return 0;
	}
	else if (strcmp(ptr, "allusers") == 0) {
		arg_allusers = 1;
		return 0;
	}
	else if (strcmp(ptr, "private-cache") == 0) {
#ifdef HAVE_USERTMPFS
		if (checkcfg(CFG_PRIVATE_CACHE))
			arg_private_cache = 1;
		else
			warning_feature_disabled("private-cache");
#endif
		return 0;
	}
	else if (strcmp(ptr, "private-dev") == 0) {
		arg_private_dev = 1;
		return 0;
	}
	else if (strcmp(ptr, "keep-dev-shm") == 0) {
		arg_keep_dev_shm = 1;
		return 0;
	}
	else if (strcmp(ptr, "private-tmp") == 0) {
		arg_private_tmp = 1;
		return 0;
	}
	else if (strcmp(ptr, "nogroups") == 0) {
		arg_nogroups = 1;
		return 0;
	}
	else if (strcmp(ptr, "nosound") == 0) {
		arg_nosound = 1;
		return 0;
	}
	else if (strcmp(ptr, "noautopulse") == 0) {
		arg_keep_config_pulse = 1;
		return 0;
	}
	else if (strcmp(ptr, "notv") == 0) {
		arg_notv = 1;
		return 0;
	}
	else if (strcmp(ptr, "nodvd") == 0) {
		arg_nodvd = 1;
		return 0;
	}
	else if (strcmp(ptr, "novideo") == 0) {
		arg_novideo = 1;
		return 0;
	}
	else if (strcmp(ptr, "no3d") == 0) {
		arg_no3d = 1;
		return 0;
	}
	else if (strcmp(ptr, "noprinters") == 0) {
		arg_noprinters = 1;
		profile_add("blacklist /dev/lp*");
		profile_add("blacklist /run/cups/cups.sock");
		return 0;
	}
	else if (strcmp(ptr, "noinput") == 0) {
		arg_noinput = 1;
		return 0;
	}
	else if (strcmp(ptr, "nodbus") == 0) {
#ifdef HAVE_DBUSPROXY
		arg_dbus_user = DBUS_POLICY_BLOCK;
		arg_dbus_system = DBUS_POLICY_BLOCK;
#endif
		return 0;
	}
	else if (strncmp(ptr, "dbus-user ", 10) == 0) {
#ifdef HAVE_DBUSPROXY
		ptr += 10;
		if (strcmp("filter", ptr) == 0) {
			if (arg_dbus_user == DBUS_POLICY_BLOCK) {
				fprintf(stderr, "Error: Cannot relax dbus-user policy, it is already set to block\n");
			} else {
				arg_dbus_user = DBUS_POLICY_FILTER;
			}
		} else if (strcmp("none", ptr) == 0) {
			if (arg_dbus_log_user) {
				fprintf(stderr, "Error: --dbus-user.log requires --dbus-user=filter\n");
				exit(1);
			}
			arg_dbus_user = DBUS_POLICY_BLOCK;
		} else {
			fprintf(stderr, "Unknown dbus-user policy: %s\n", ptr);
			exit(1);
		}
#endif
		return 0;
	}
	else if (strncmp(ptr, "dbus-user.see ", 14) == 0) {
#ifdef HAVE_DBUSPROXY
		if (!dbus_check_name(ptr + 14)) {
			fprintf(stderr, "Invalid dbus-user.see name: %s\n", ptr + 15);
			exit(1);
		}
#endif
		return 1;
	}
	else if (strncmp(ptr, "dbus-user.talk ", 15) == 0) {
#ifdef HAVE_DBUSPROXY
		if (!dbus_check_name(ptr + 15)) {
			fprintf(stderr, "Error: Invalid dbus-user.talk name: %s\n", ptr + 15);
			exit(1);
		}
#endif
		return 1;
	}
	else if (strncmp(ptr, "dbus-user.own ", 14) == 0) {
#ifdef HAVE_DBUSPROXY
		if (!dbus_check_name(ptr + 14)) {
			fprintf(stderr, "Error: Invalid dbus-user.own name: %s\n", ptr + 14);
			exit(1);
		}
#endif
		return 1;
	}
	else if (strncmp(ptr, "dbus-user.call ", 15) == 0) {
#ifdef HAVE_DBUSPROXY
		if (!dbus_check_call_rule(ptr + 15)) {
			fprintf(stderr, "Error: Invalid dbus-user.call rule: %s\n", ptr + 15);
			exit(1);
		}
#endif
		return 1;
	}
	else if (strncmp(ptr, "dbus-user.broadcast ", 20) == 0) {
#ifdef HAVE_DBUSPROXY
		if (!dbus_check_call_rule(ptr + 20)) {
			fprintf(stderr, "Error: Invalid dbus-user.broadcast rule: %s\n", ptr + 20);
			exit(1);
		}
#endif
		return 1;
	}
	else if (strncmp(ptr, "dbus-system ", 12) == 0) {
#ifdef HAVE_DBUSPROXY
		ptr += 12;
		if (strcmp("filter", ptr) == 0) {
			if (arg_dbus_system == DBUS_POLICY_BLOCK) {
				fprintf(stderr, "Error: Cannot relax dbus-system policy, it is already set to block\n");
			} else {
				arg_dbus_system = DBUS_POLICY_FILTER;
			}
		} else if (strcmp("none", ptr) == 0) {
			if (arg_dbus_log_system) {
				fprintf(stderr, "Error: --dbus-system.log requires --dbus-system=filter\n");
				exit(1);
			}
			arg_dbus_system = DBUS_POLICY_BLOCK;
		} else {
			fprintf(stderr, "Error: Unknown dbus-system policy: %s\n", ptr);
			exit(1);
		}
#endif
		return 0;
	}
	else if (strncmp(ptr, "dbus-system.see ", 16) == 0) {
#ifdef HAVE_DBUSPROXY
		if (!dbus_check_name(ptr + 16)) {
			fprintf(stderr, "Error: Invalid dbus-system.see name: %s\n", ptr + 17);
			exit(1);
		}
#endif
		return 1;
	}
	else if (strncmp(ptr, "dbus-system.talk ", 17) == 0) {
#ifdef HAVE_DBUSPROXY
		if (!dbus_check_name(ptr + 17)) {
			fprintf(stderr, "Error: Invalid dbus-system.talk name: %s\n", ptr + 17);
			exit(1);
		}
#endif
		return 1;
	}
	else if (strncmp(ptr, "dbus-system.own ", 16) == 0) {
#ifdef HAVE_DBUSPROXY
		if (!dbus_check_name(ptr + 16)) {
			fprintf(stderr, "Error: Invalid dbus-system.own name: %s\n", ptr + 16);
			exit(1);
		}
#endif
		return 1;
	}
	else if (strncmp(ptr, "dbus-system.call ", 17) == 0) {
#ifdef HAVE_DBUSPROXY
		if (!dbus_check_call_rule(ptr + 17)) {
			fprintf(stderr, "Error: Invalid dbus-system.call rule: %s\n", ptr + 17);
			exit(1);
		}
#endif
		return 1;
	}
	else if (strncmp(ptr, "dbus-system.broadcast ", 22) == 0) {
#ifdef HAVE_DBUSPROXY
		if (!dbus_check_call_rule(ptr + 22)) {
			fprintf(stderr, "Error: Invalid dbus-system.broadcast rule: %s\n", ptr + 22);
			exit(1);
		}
#endif
		return 1;
	}
	else if (strcmp(ptr, "nou2f") == 0) {
		arg_nou2f = 1;
		return 0;
	}
	else if (strcmp(ptr, "netfilter") == 0) {
#ifdef HAVE_NETWORK
		if (checkcfg(CFG_NETWORK))
			arg_netfilter = 1;
		else
			warning_feature_disabled("networking");
#endif
		return 0;
	}
	else if (strncmp(ptr, "netfilter ", 10) == 0) {
#ifdef HAVE_NETWORK
		if (checkcfg(CFG_NETWORK)) {
			arg_netfilter = 1;
			arg_netfilter_file = expand_macros(ptr + 10);
			check_netfilter_file(arg_netfilter_file);
		}
		else
			warning_feature_disabled("networking");
#endif
		return 0;
	}
	else if (strncmp(ptr, "netfilter6 ", 11) == 0) {
#ifdef HAVE_NETWORK
		if (checkcfg(CFG_NETWORK)) {
			arg_netfilter6 = 1;
			arg_netfilter6_file = expand_macros(ptr + 11);
			check_netfilter_file(arg_netfilter6_file);
		}
		else
			warning_feature_disabled("networking");
#endif
		return 0;
	}
	else if (strcmp(ptr, "netlock") == 0) {
#ifdef HAVE_NETWORK
		if (checkcfg(CFG_NETWORK)) {
			arg_netlock = 1;
		}
		else
			warning_feature_disabled("networking");
#endif
		return 0;
	}
	else if (strncmp(ptr, "netns ", 6) == 0) {
#ifdef HAVE_NETWORK
		if (checkcfg(CFG_NETWORK)) {
			arg_netns = ptr + 6;
			check_netns(arg_netns);
		}
		else
			warning_feature_disabled("networking");
#endif
		return 0;
	}
	else if (strcmp(ptr, "net none") == 0) {
		arg_nonetwork  = 1;
		cfg.bridge0.configured = 0;
		cfg.bridge1.configured = 0;
		cfg.bridge2.configured = 0;
		cfg.bridge3.configured = 0;
		cfg.interface0.configured = 0;
		cfg.interface1.configured = 0;
		cfg.interface2.configured = 0;
		cfg.interface3.configured = 0;
		return 0;
	}
	else if (strncmp(ptr, "net ", 4) == 0) {
#ifdef HAVE_NETWORK
		if (checkcfg(CFG_NETWORK)) {
			if (strcmp(ptr + 4, "lo") == 0) {
				fprintf(stderr, "Error: cannot attach to lo device\n");
				exit(1);
			}

			Bridge *br;
			if (cfg.bridge0.configured == 0)
				br = &cfg.bridge0;
			else if (cfg.bridge1.configured == 0)
				br = &cfg.bridge1;
			else if (cfg.bridge2.configured == 0)
				br = &cfg.bridge2;
			else if (cfg.bridge3.configured == 0)
				br = &cfg.bridge3;
			else {
				fprintf(stderr, "Error: maximum 4 network devices are allowed\n");
				exit(1);
			}
			br->dev = ptr + 4;
			br->configured = 1;
		}
		else
			warning_feature_disabled("networking");
#endif
		return 0;
	}

	else if (strncmp(ptr, "veth-name ", 10) == 0) {
#ifdef HAVE_NETWORK
		if (checkcfg(CFG_NETWORK)) {
			Bridge *br = last_bridge_configured();
			if (br == NULL) {
				fprintf(stderr, "Error: no network device configured\n");
				exit(1);
			}

			br->veth_name = strdup(ptr + 10);
			if (br->veth_name == NULL)
				errExit("strdup");
			if (*br->veth_name == '\0') {
				fprintf(stderr, "Error: no veth-name configured\n");
				exit(1);
			}
		}
		else
			warning_feature_disabled("networking");
#endif
		return 0;
	}

	else if (strncmp(ptr, "iprange ", 8) == 0) {
#ifdef HAVE_NETWORK
		if (checkcfg(CFG_NETWORK)) {
			Bridge *br = last_bridge_configured();
			if (br == NULL) {
				fprintf(stderr, "Error: no network device configured\n");
				exit(1);
			}
			if (br->iprange_start || br->iprange_end) {
				fprintf(stderr, "Error: cannot configure the IP range twice for the same interface\n");
				exit(1);
			}

			// parse option arguments
			char *firstip = ptr + 8;
			char *secondip = firstip;
			while (*secondip != '\0') {
				if (*secondip == ',')
					break;
				secondip++;
			}
			if (*secondip == '\0') {
				fprintf(stderr, "Error: invalid IP range\n");
				exit(1);
			}
			*secondip = '\0';
			secondip++;

			// check addresses
			if (atoip(firstip, &br->iprange_start) || atoip(secondip, &br->iprange_end) ||
			    br->iprange_start >= br->iprange_end) {
				fprintf(stderr, "Error: invalid IP range\n");
				exit(1);
			}
		}
		else
			warning_feature_disabled("networking");
#endif
		return 0;
	}


	else if (strncmp(ptr, "mac ", 4) == 0) {
#ifdef HAVE_NETWORK
		if (checkcfg(CFG_NETWORK)) {
			Bridge *br = last_bridge_configured();
			if (br == NULL) {
				fprintf(stderr, "Error: no network device configured\n");
				exit(1);
			}

			if (mac_not_zero(br->macsandbox)) {
				fprintf(stderr, "Error: cannot configure the MAC address twice for the same interface\n");
				exit(1);
			}

			// read the address
			if (atomac(ptr + 4, br->macsandbox)) {
				fprintf(stderr, "Error: invalid MAC address\n");
				exit(1);
			}

			// check multicast address
			if (br->macsandbox[0] & 1) {
				fprintf(stderr, "Error: invalid MAC address (multicast)\n");
				exit(1);
			}
		}
		else
			warning_feature_disabled("networking");
#endif
		return 0;
	}

	else if (strncmp(ptr, "mtu ", 4) == 0) {
#ifdef HAVE_NETWORK
		if (checkcfg(CFG_NETWORK)) {
			Bridge *br = last_bridge_configured();
			if (br == NULL) {
				fprintf(stderr, "Error: no network device configured\n");
				exit(1);
			}

			if (sscanf(ptr + 4, "%d", &br->mtu) != 1 || br->mtu < 576 || br->mtu > 9198) {
				fprintf(stderr, "Error: invalid mtu value\n");
				exit(1);
			}
		}
		else
			warning_feature_disabled("networking");
#endif
		return 0;
	}

	else if (strncmp(ptr, "netmask ", 8) == 0) {
#ifdef HAVE_NETWORK
		if (checkcfg(CFG_NETWORK)) {
			Bridge *br = last_bridge_configured();
			if (br == NULL) {
				fprintf(stderr, "Error: no network device configured\n");
				exit(1);
			}
			if (br->arg_ip_none || br->masksandbox) {
				fprintf(stderr, "Error: cannot configure the network mask twice for the same interface\n");
				exit(1);
			}

			// configure this network mask for the last bridge defined
			if (atoip(ptr + 8, &br->masksandbox)) {
				fprintf(stderr, "Error: invalid  network mask\n");
				exit(1);
			}

			// if the bridge is not configured, use this mask as the bridge mask
			if (br->mask == 0)
				br->mask = br->masksandbox;
			else {
				fprintf(stderr, "Error: interface %s already has a network mask defined; "
					"please remove --netmask\n",
					br->dev);
				exit(1);
			}
		}
		else
			warning_feature_disabled("networking");
#endif
		return 0;
	}
	else if (strncmp(ptr, "ip ", 3) == 0) {
#ifdef HAVE_NETWORK
		if (checkcfg(CFG_NETWORK)) {
			Bridge *br = last_bridge_configured();
			if (br == NULL) {
				fprintf(stderr, "Error: no network device configured\n");
				exit(1);
			}
			if (br->arg_ip_none || br->ipsandbox) {
				fprintf(stderr, "Error: cannot configure the IP address twice for the same interface\n");
				exit(1);
			}

			// configure this IP address for the last bridge defined
			if (strcmp(ptr + 3, "none") == 0)
				br->arg_ip_none = 1;
			else if (strcmp(ptr + 3, "dhcp") == 0) {
				br->arg_ip_none = 1;
				br->arg_ip_dhcp = 1;
			} else {
				if (atoip(ptr + 3, &br->ipsandbox)) {
					fprintf(stderr, "Error: invalid IP address\n");
					exit(1);
				}
			}
		}
		else
			warning_feature_disabled("networking");
#endif
		return 0;
	}

	else if (strncmp(ptr, "ip6 ", 4) == 0) {
#ifdef HAVE_NETWORK
		if (checkcfg(CFG_NETWORK)) {
			Bridge *br = last_bridge_configured();
			if (br == NULL) {
				fprintf(stderr, "Error: no network device configured\n");
				exit(1);
			}
			if (br->arg_ip6_dhcp || br->ip6sandbox) {
				fprintf(stderr, "Error: cannot configure the IP address twice for the same interface\n");
				exit(1);
			}

			// configure this IP address for the last bridge defined
			if (strcmp(ptr + 4, "dhcp") == 0)
				br->arg_ip6_dhcp = 1;
			else {
				if (check_ip46_address(ptr + 4) == 0) {
					fprintf(stderr, "Error: invalid IPv6 address\n");
					exit(1);
				}

				br->ip6sandbox = strdup(ptr + 4);
				if (br->ip6sandbox == NULL)
					errExit("strdup");
			}
		}
		else
			warning_feature_disabled("networking");
#endif
		return 0;
	}

	else if (strncmp(ptr, "defaultgw ", 10) == 0) {
#ifdef HAVE_NETWORK
		if (checkcfg(CFG_NETWORK)) {
			if (atoip(ptr + 10, &cfg.defaultgw)) {
				fprintf(stderr, "Error: invalid IP address\n");
				exit(1);
			}
		}
		else
			warning_feature_disabled("networking");
#endif
		return 0;
	}

	if (strcmp(ptr, "apparmor") == 0) {
#ifdef HAVE_APPARMOR
		arg_apparmor = 1;
		apparmor_profile = "firejail-default";
#endif
		return 0;
	}

	if (strncmp(ptr, "apparmor ", 9) == 0) {
#ifdef HAVE_APPARMOR
		arg_apparmor = 1;
		apparmor_profile = strdup(ptr + 9);
		if (!apparmor_profile)
			errExit("strdup");
#endif
		return 0;
	}

	if (strcmp(ptr, "apparmor-replace") == 0) {
#ifdef HAVE_APPARMOR
		arg_apparmor = 1;
		apparmor_replace = true;
#endif
		return 0;
	}

	if (strcmp(ptr, "apparmor-stack") == 0) {
#ifdef HAVE_APPARMOR
		arg_apparmor = 1;
		apparmor_replace = false;
#endif
		return 0;
	}

	if (strncmp(ptr, "protocol ", 9) == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			const char *add = ptr + 9;
			profile_list_augment(&cfg.protocol, add);
			if (arg_debug)
				fprintf(stderr, "[profile] combined protocol list: \"%s\"\n", cfg.protocol);
		}
		else
			warning_feature_disabled("seccomp");
		return 0;
	}

	if (strncmp(ptr, "env ", 4) == 0) {
		env_store(ptr + 4, SETENV);
		return 0;
	}
	if (strncmp(ptr, "rmenv ", 6) == 0) {
		env_store(ptr + 6, RMENV);
		return 0;
	}

	// seccomp drop list on top of default list
	if (strncmp(ptr, "seccomp ", 8) == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			arg_seccomp = 1;
			cfg.seccomp_list = seccomp_check_list(ptr + 8);
		}
		else if (!arg_quiet)
			warning_feature_disabled("seccomp");

		return 0;
	}
	if (strncmp(ptr, "seccomp.32 ", 11) == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			arg_seccomp32 = 1;
			cfg.seccomp_list32 = seccomp_check_list(ptr + 11);
		}
		else if (!arg_quiet)
			warning_feature_disabled("seccomp");

		return 0;
	}

	if (strcmp(ptr, "seccomp.block-secondary") == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			arg_seccomp_block_secondary = 1;
		}
		else
			warning_feature_disabled("seccomp");
		return 0;
	}
	// seccomp drop list without default list
	if (strncmp(ptr, "seccomp.drop ", 13) == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			arg_seccomp = 1;
			cfg.seccomp_list_drop = seccomp_check_list(ptr + 13);
		}
		else
			warning_feature_disabled("seccomp");
		return 0;
	}
	if (strncmp(ptr, "seccomp.32.drop ", 16) == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			arg_seccomp32 = 1;
			cfg.seccomp_list_drop32 = seccomp_check_list(ptr + 16);
		}
		else
			warning_feature_disabled("seccomp");
		return 0;
	}

	// seccomp keep list
	if (strncmp(ptr, "seccomp.keep ", 13) == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			arg_seccomp = 1;
			cfg.seccomp_list_keep= seccomp_check_list(ptr + 13);
		}
		else
			warning_feature_disabled("seccomp");
		return 0;
	}
	if (strncmp(ptr, "seccomp.32.keep ", 16) == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			arg_seccomp32 = 1;
			cfg.seccomp_list_keep32 = seccomp_check_list(ptr + 16);
		}
		else
			warning_feature_disabled("seccomp");
		return 0;
	}

#ifdef HAVE_LANDLOCK
	if (strncmp(ptr, "landlock.enforce", 16) == 0) {
		arg_landlock_enforce = 1;
		return 0;
	}
	if (strncmp(ptr, "landlock.fs.read ", 17) == 0) {
		ll_add_profile(LL_FS_READ, ptr + 17);
		return 0;
	}
	if (strncmp(ptr, "landlock.fs.write ", 18) == 0) {
		ll_add_profile(LL_FS_WRITE, ptr + 18);
		return 0;
	}
	if (strncmp(ptr, "landlock.fs.makeipc ", 20) == 0) {
		ll_add_profile(LL_FS_MAKEIPC, ptr + 20);
		return 0;
	}
	if (strncmp(ptr, "landlock.fs.makedev ", 20) == 0) {
		ll_add_profile(LL_FS_MAKEDEV, ptr + 20);
		return 0;
	}
	if (strncmp(ptr, "landlock.fs.execute ", 20) == 0) {
		ll_add_profile(LL_FS_EXEC, ptr + 20);
		return 0;
	}
#endif

	// memory deny write&execute
	if (strcmp(ptr, "memory-deny-write-execute") == 0) {
		if (checkcfg(CFG_SECCOMP))
			arg_memory_deny_write_execute = 1;
		else
			warning_feature_disabled("seccomp");
		return 0;
	}

	// restrict-namespaces
	if (strcmp(ptr, "restrict-namespaces") == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			arg_restrict_namespaces = 1;
			profile_list_augment(&cfg.restrict_namespaces, "cgroup,ipc,net,mnt,pid,time,user,uts");
		}
		else
			warning_feature_disabled("seccomp");
		return 0;
	}
	if (strncmp(ptr, "restrict-namespaces ", 20) == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			const char *add = ptr + 20;
			profile_list_augment(&cfg.restrict_namespaces, add);
		}
		else
			warning_feature_disabled("seccomp");
		return 0;
	}

	// seccomp error action
	if (strncmp(ptr, "seccomp-error-action ", 21) == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			int config_seccomp_error_action = checkcfg(CFG_SECCOMP_ERROR_ACTION);
			if (config_seccomp_error_action == -1) {
				if (strcmp(ptr + 21, "kill") == 0)
					arg_seccomp_error_action = SECCOMP_RET_KILL;
				else if (strcmp(ptr + 21, "log") == 0)
					arg_seccomp_error_action = SECCOMP_RET_LOG;
				else {
					arg_seccomp_error_action = errno_find_name(ptr + 21);
					if (arg_seccomp_error_action == -1)
						errExit("seccomp-error-action: unknown errno");
				}
				cfg.seccomp_error_action = strdup(ptr + 21);
				if (!cfg.seccomp_error_action)
					errExit("strdup");
			} else {
				arg_seccomp_error_action = config_seccomp_error_action;
				cfg.seccomp_error_action = config_seccomp_error_action_str;
				warning_feature_disabled("seccomp-error-action");
			}
		} else
			warning_feature_disabled("seccomp");
		return 0;
	}

	// caps drop list
	if (strncmp(ptr, "caps.drop ", 10) == 0) {
		arg_caps_drop = 1;
		arg_caps_list = strdup(ptr + 10);
		if (!arg_caps_list)
			errExit("strdup");
		// verify caps list and exit if problems
		caps_check_list(arg_caps_list, NULL);
		return 0;
	}

	// caps keep list
	if (strncmp(ptr, "caps.keep ", 10) == 0) {
		arg_caps_keep = 1;
		arg_caps_list = strdup(ptr + 10);
		if (!arg_caps_list)
			errExit("strdup");
		// verify caps list and exit if problems
		caps_check_list(arg_caps_list, NULL);
		return 0;
	}

	// hostname
	if (strncmp(ptr, "hostname ", 9) == 0) {
		cfg.hostname = ptr + 9;
		if (strlen(cfg.hostname) == 0) {
			fprintf(stderr, "Error: invalid hostname: cannot be empty\n");
			exit(1);
		}
		if (invalid_name(cfg.hostname)) {
			fprintf(stderr, "Error: invalid hostname\n");
			exit(1);
		}
		return 0;
	}

	// hosts-file
	if (strncmp(ptr, "hosts-file ", 11) == 0) {
		cfg.hosts_file = fs_check_hosts_file(ptr + 11);
		return 0;
	}

	// dns
	if (strncmp(ptr, "dns ", 4) == 0) {

		if (check_ip46_address(ptr + 4) == 0) {
			fprintf(stderr, "Error: invalid DNS server IPv4 or IPv6 address\n");
			exit(1);
		}
		char *dns = strdup(ptr + 4);
		if (!dns)
			errExit("strdup");

		if (cfg.dns1 == NULL)
			cfg.dns1 = dns;
		else if (cfg.dns2 == NULL)
			cfg.dns2 = dns;
		else if (cfg.dns3 == NULL)
			cfg.dns3 = dns;
		else if (cfg.dns4 == NULL)
			cfg.dns4 = dns;
		else {
			fwarning("up to 4 DNS servers can be specified, %s ignored\n", dns);
			free(dns);
		}
		return 0;
	}

	// cpu affinity
	if (strncmp(ptr, "cpu ", 4) == 0) {
		read_cpu_list(ptr + 4);
		return 0;
	}

	// nice value
	if (strncmp(ptr, "nice ", 5) == 0) {
		cfg.nice = atoi(ptr + 5);
		if (getuid() != 0 &&cfg.nice < 0)
			cfg.nice = 0;
		arg_nice = 1;
		return 0;
	}

	// writable-etc
	if (strcmp(ptr, "writable-etc") == 0) {
		if (cfg.etc_private_keep) {
			fprintf(stderr, "Error: private-etc and writable-etc are mutually exclusive\n");
			exit(1);
		}
		arg_writable_etc = 1;
		return 0;
	}

	if (strcmp(ptr, "machine-id") == 0) {
		arg_machineid = 1;
		return 0;
	}

	if (strcmp(ptr, "keep-config-pulse") == 0) {
		arg_keep_config_pulse = 1;
		return 0;
	}

	if (strcmp(ptr, "keep-shell-rc") == 0) {
		arg_keep_shell_rc = 1;
		return 0;
	}

	// writable-var
	if (strcmp(ptr, "writable-var") == 0) {
		arg_writable_var = 1;
		return 0;
	}
	// don't overwrite /var/tmp
	if (strcmp(ptr, "keep-var-tmp") == 0) {
		arg_keep_var_tmp = 1;
		return 0;
	}
	// writable-run-user
	if (strcmp(ptr, "writable-run-user") == 0) {
		arg_writable_run_user = 1;
		return 0;
	}
	if (strcmp(ptr, "writable-var-log") == 0) {
		arg_writable_var_log = 1;
		return 0;
	}

	// private directory
	if (strncmp(ptr, "private ", 8) == 0) {
		cfg.home_private = ptr + 8;
		fs_check_private_dir();
		arg_private = 1;
		return 0;
	}

	if (strcmp(ptr, "allow-debuggers") == 0) {
		arg_allow_debuggers = 1;
		return 0;
	}

	if (strcmp(ptr, "x11 none") == 0) {
		arg_x11_block = 1;
		return 0;
	}

	if (strcmp(ptr, "x11 xephyr") == 0) {
#ifdef HAVE_X11
		if (checkcfg(CFG_X11)) {
			const char *x11env = env_get("FIREJAIL_X11");
			if (x11env && strcmp(x11env, "yes") == 0) {
				return 0;
			}
			else {
				// start x11
				x11_start_xephyr(cfg.original_argc, cfg.original_argv);
				exit(0);
			}
		}
		else
			warning_feature_disabled("x11");
#endif
		return 0;
	}

	if (strcmp(ptr, "x11 xorg") == 0) {
#ifdef HAVE_X11
		if (checkcfg(CFG_X11))
			arg_x11_xorg = 1;
		else
			warning_feature_disabled("x11");
#endif
		return 0;
	}

	if (strcmp(ptr, "x11 xpra") == 0) {
#ifdef HAVE_X11
		if (checkcfg(CFG_X11)) {
			const char *x11env = env_get("FIREJAIL_X11");
			if (x11env && strcmp(x11env, "yes") == 0) {
				return 0;
			}
			else {
				// start x11
				x11_start_xpra(cfg.original_argc, cfg.original_argv);
				exit(0);
			}
		}
		else
			warning_feature_disabled("x11");
#endif
		return 0;
	}

	if (strcmp(ptr, "x11 xvfb") == 0) {
#ifdef HAVE_X11
		if (checkcfg(CFG_X11)) {
			const char *x11env = env_get("FIREJAIL_X11");
			if (x11env && strcmp(x11env, "yes") == 0) {
				return 0;
			}
			else {
				// start x11
				x11_start_xvfb(cfg.original_argc, cfg.original_argv);
				exit(0);
			}
		}
		else
			warning_feature_disabled("x11");
#endif
		return 0;
	}

	if (strcmp(ptr, "x11") == 0) {
#ifdef HAVE_X11
		if (checkcfg(CFG_X11)) {
			const char *x11env = env_get("FIREJAIL_X11");
			if (x11env && strcmp(x11env, "yes") == 0) {
				return 0;
			}
			else {
				// start x11
				x11_start(cfg.original_argc, cfg.original_argv);
				exit(0);
			}
		}
		else
			warning_feature_disabled("x11");
#endif
		return 0;
	}

	// private /etc list of files and directories
	if (strncmp(ptr, "private-etc ", 12) == 0) {
		if (checkcfg(CFG_PRIVATE_ETC)) {
			if (arg_writable_etc) {
				fprintf(stderr, "Error: --private-etc and --writable-etc are mutually exclusive\n");
				exit(1);
			}
			if (cfg.etc_private_keep) {
				if ( asprintf(&cfg.etc_private_keep, "%s,%s", cfg.etc_private_keep, ptr + 12) < 0 )
					errExit("asprintf");
			} else {
				cfg.etc_private_keep = ptr + 12;
			}
			arg_private_etc = 1;
		}
		else
			warning_feature_disabled("private-etc");
		return 0;
	}

	// private /etc without a list of files and directories
	if (strcmp(ptr, "private-etc") == 0) {
		if (checkcfg(CFG_PRIVATE_ETC)) {
			if (arg_writable_etc) {
				fprintf(stderr, "Error: --private-etc and --writable-etc are mutually exclusive\n");
				exit(1);
			}
			arg_private_etc = 1;
		}
		else
			warning_feature_disabled("private-etc");
		return 0;
	}

	// private /opt list of files and directories
	if (strncmp(ptr, "private-opt ", 12) == 0) {
		if (checkcfg(CFG_PRIVATE_OPT)) {
			if (cfg.opt_private_keep) {
				if ( asprintf(&cfg.opt_private_keep, "%s,%s", cfg.opt_private_keep, ptr + 12) < 0 )
					errExit("asprintf");
			} else {
				cfg.opt_private_keep = ptr + 12;
			}
			arg_private_opt = 1;
		}
		else
			warning_feature_disabled("private-opt");
		return 0;
	}

	// private /srv list of files and directories
	if (strncmp(ptr, "private-srv ", 12) == 0) {
		if (checkcfg(CFG_PRIVATE_SRV)) {
			if (cfg.srv_private_keep) {
				if ( asprintf(&cfg.srv_private_keep, "%s,%s", cfg.srv_private_keep, ptr + 12) < 0 )
					errExit("asprintf");
			} else {
				cfg.srv_private_keep = ptr + 12;
			}
			arg_private_srv = 1;
		}
		else
			warning_feature_disabled("private-srv");
		return 0;
	}

	// private /bin list of files
	if (strncmp(ptr, "private-bin ", 12) == 0) {
		if (checkcfg(CFG_PRIVATE_BIN)) {
			if (cfg.bin_private_keep) {
				if ( asprintf(&cfg.bin_private_keep, "%s,%s", cfg.bin_private_keep, ptr + 12) < 0 )
					errExit("asprintf");
			} else {
				cfg.bin_private_keep = ptr + 12;
			}
			arg_private_bin = 1;
		}
		else
			warning_feature_disabled("private-bin");
		return 0;
	}

	// private /lib list of files
	if (strncmp(ptr, "private-lib", 11) == 0) {
		if (checkcfg(CFG_PRIVATE_LIB)) {
			if (ptr[11] == ' ') {
				if (cfg.lib_private_keep) {
					if (ptr[12] != '\0' && asprintf(&cfg.lib_private_keep, "%s,%s", cfg.lib_private_keep, ptr + 12) < 0)
						errExit("asprintf");
				} else {
					cfg.lib_private_keep = ptr + 12;
				}
			}
			arg_private_lib = 1;
		}
		else
			warning_feature_disabled("private-lib");
		return 0;
	}


#ifdef HAVE_OVERLAYFS
	if (strncmp(ptr, "overlay-named ", 14) == 0) {
		if (checkcfg(CFG_OVERLAYFS)) {
			if (arg_overlay) {
				fprintf(stderr, "Error: only one overlay command is allowed\n");
				exit(1);
			}
			if (cfg.chrootdir) {
				fprintf(stderr, "Error: --overlay and --chroot options are mutually exclusive\n");
				exit(1);
			}
			arg_overlay = 1;
			arg_overlay_keep = 1;
			arg_overlay_reuse = 1;

			char *subdirname = ptr + 14;
			if (*subdirname == '\0') {
				fprintf(stderr, "Error: invalid overlay option\n");
				exit(1);
			}

			// check name
			invalid_filename(subdirname, 0); // no globbing
			if (strstr(subdirname, "..") || strstr(subdirname, "/")) {
				fprintf(stderr, "Error: invalid overlay name\n");
				exit(1);
			}
			cfg.overlay_dir = fs_check_overlay_dir(subdirname, arg_overlay_reuse);
		}
		else
			warning_feature_disabled("overlayfs");
		return 0;

	} else if (strcmp(ptr, "overlay-tmpfs") == 0) {
		if (checkcfg(CFG_OVERLAYFS)) {
			if (arg_overlay) {
				fprintf(stderr, "Error: only one overlay command is allowed\n");
				exit(1);
			}
			if (cfg.chrootdir) {
				fprintf(stderr, "Error: --overlay and --chroot options are mutually exclusive\n");
				exit(1);
			}
			arg_overlay = 1;
		}
		else
			warning_feature_disabled("overlayfs");
		return 0;

	} else if (strcmp(ptr, "overlay") == 0) {
		if (checkcfg(CFG_OVERLAYFS)) {
			if (arg_overlay) {
				fprintf(stderr, "Error: only one overlay command is allowed\n");
				exit(1);
			}
			if (cfg.chrootdir) {
				fprintf(stderr, "Error: --overlay and --chroot options are mutually exclusive\n");
				exit(1);
			}
			arg_overlay = 1;
			arg_overlay_keep = 1;

			char *subdirname;
			if (asprintf(&subdirname, "%d", getpid()) == -1)
				errExit("asprintf");
			cfg.overlay_dir = fs_check_overlay_dir(subdirname, arg_overlay_reuse);

			free(subdirname);
		}
		else
			warning_feature_disabled("overlayfs");
		return 0;
	}
#endif

	// filesystem bind
	if (strncmp(ptr, "bind ", 5) == 0) {
		if (checkcfg(CFG_BIND)) {
			// extract two directories
			if (getuid() != 0) {
				fprintf(stderr, "Error: --bind option is available only if running as root\n");
				exit(1);
			}

			char *dname1 = ptr + 5;
			char *dname2 = split_comma(dname1); // this inserts a '0 to separate the two dierctories
			if (dname2 == NULL) {
				fprintf(stderr, "Error: missing second directory for bind\n");
				exit(1);
			}

			// check directories
			invalid_filename(dname1, 0); // no globbing
			invalid_filename(dname2, 0); // no globbing
			if (strstr(dname1, "..") || strstr(dname2, "..")) {
				fprintf(stderr, "Error: invalid file name.\n");
				exit(1);
			}
			if (is_link(dname1) || is_link(dname2)) {
				fprintf(stderr, "Symbolic links are not allowed for bind command\n");
				exit(1);
			}

			// insert comma back
			*(dname2 - 1) = ',';
			return 1;
		}
		else
			warning_feature_disabled("bind");
		return 0;
	}

	// rlimit
	if (strncmp(ptr, "rlimit", 6) == 0) {
		if (strncmp(ptr, "rlimit-nofile ", 14) == 0) {
			check_unsigned(ptr + 14, "Error: invalid rlimit in profile file: ");
			sscanf(ptr + 14, "%llu", &cfg.rlimit_nofile);
			arg_rlimit_nofile = 1;
		}
		else if (strncmp(ptr, "rlimit-cpu ", 11) == 0) {
			check_unsigned(ptr + 11, "Error: invalid rlimit in profile file: ");
			sscanf(ptr + 11, "%llu", &cfg.rlimit_cpu);
			arg_rlimit_cpu = 1;
		}
		else if (strncmp(ptr, "rlimit-nproc ", 13) == 0) {
			check_unsigned(ptr + 13, "Error: invalid rlimit in profile file: ");
			sscanf(ptr + 13, "%llu", &cfg.rlimit_nproc);
			arg_rlimit_nproc = 1;
		}
		else if (strncmp(ptr, "rlimit-fsize ", 13) == 0) {
			cfg.rlimit_fsize = parse_arg_size(ptr + 13);
			if (cfg.rlimit_fsize == 0) {
				perror("Error: invalid rlimit-fsize in profile file. Only use positive numbers and k, m or g suffix.");
				exit(1);
			}
			arg_rlimit_fsize = 1;
		}
		else if (strncmp(ptr, "rlimit-sigpending ", 18) == 0) {
			check_unsigned(ptr + 18, "Error: invalid rlimit in profile file: ");
			sscanf(ptr + 18, "%llu", &cfg.rlimit_sigpending);
			arg_rlimit_sigpending = 1;
		}
		else if (strncmp(ptr, "rlimit-as ", 10) == 0) {
			cfg.rlimit_as = parse_arg_size(ptr + 10);
			if (cfg.rlimit_as == 0) {
				perror("Error: invalid rlimit-as in profile file. Only use positive numbers and k, m or g suffix.");
				exit(1);
			}
			arg_rlimit_as = 1;
		}
		else {
			fprintf(stderr, "Error: Invalid rlimit option on line %d\n", lineno);
			exit(1);
		}

		return 0;
	}

	if (strncmp(ptr, "timeout ", 8) == 0) {
		cfg.timeout = extract_timeout(ptr +8);
		return 0;
	}

	if (strncmp(ptr, "join-or-start ", 14) == 0) {
		if (checkcfg(CFG_JOIN) || getuid() == 0) {
			// try to join by name only
			pid_t pid;
			EUID_ROOT();
			int r = name2pid(ptr + 14, &pid);
			EUID_USER();
			if (!r) {
				// find first non-option arg
				int i;
				for (i = 1; i < cfg.original_argc && strncmp(cfg.original_argv[i], "--", 2) != 0; i++);

				join(pid, cfg.original_argc,cfg.original_argv, i + 1);
				exit(0);
			}

			// set sandbox name and start normally
			cfg.name = ptr + 14;
			if (strlen(cfg.name) == 0) {
				fprintf(stderr, "Error: invalid sandbox name: cannot be empty\n");
				exit(1);
			}
			if (invalid_name(cfg.name)) {
				fprintf(stderr, "Error: invalid sandbox name\n");
				exit(1);
			}
		}
		else
			warning_feature_disabled("join");
		return 0;
	}

	if (strcmp(ptr, "disable-mnt") == 0) {
		arg_disable_mnt = 1;
		return 0;
	}

	if (strcmp(ptr, "deterministic-exit-code") == 0) {
		arg_deterministic_exit_code = 1;
		return 0;
	}

	if (strcmp(ptr, "deterministic-shutdown") == 0) {
		arg_deterministic_shutdown = 1;
		return 0;
	}

	// rest of filesystem
	if (strncmp(ptr, "blacklist ", 10) == 0)
		ptr += 10;
	else if (strncmp(ptr, "blacklist-nolog ", 16) == 0)
		ptr += 16;
	else if (strncmp(ptr, "noblacklist ", 12) == 0)
		ptr += 12;
	else if (strncmp(ptr, "whitelist ", 10) == 0) {
		arg_whitelist = 1;
		ptr += 10;
	}
	else if (strncmp(ptr, "nowhitelist ", 12) == 0)
		ptr += 12;
	else if (strncmp(ptr, "read-only ", 10) == 0)
		ptr += 10;
	else if (strncmp(ptr, "read-write ", 11) == 0)
		ptr += 11;
	else if (strncmp(ptr, "noexec ", 7) == 0)
		ptr += 7;
	else if (strncmp(ptr, "tmpfs ", 6) == 0) {
#ifndef HAVE_USERTMPFS
		if (getuid() != 0) {
			fprintf(stderr, "Error: tmpfs available only when running the sandbox as root\n");
			exit(1);
		}
#endif
		ptr += 6;
	}
	else {
		if (lineno == 0)
			fprintf(stderr, "Error: \"%s\" as a command line option is invalid\n", ptr);
		else if (fname != NULL)
			fprintf(stderr, "Error: line %d in %s is invalid\n", lineno, fname);
		else
			fprintf(stderr, "Error: line %d in the custom profile is invalid\n", lineno);
		exit(1);
	}

	// some characters just don't belong in filenames
	invalid_filename(ptr, 1); // globbing
	if (strstr(ptr, "..")) {
		if (lineno == 0)
			fprintf(stderr, "Error: \"%s\" is an invalid filename\n", ptr);
		else if (fname != NULL)
			fprintf(stderr, "Error: line %d in %s is invalid\n", lineno, fname);
		else
			fprintf(stderr, "Error: line %d in the custom profile is invalid\n", lineno);
		exit(1);
	}
	return 1;
}

// add a profile entry in cfg.profile list; use str to populate the list
void profile_add(char *str) {
	EUID_ASSERT();

	ProfileEntry *prf = malloc(sizeof(ProfileEntry));
	if (!prf)
		errExit("malloc");
	memset(prf, 0, sizeof(ProfileEntry));
	prf->next = NULL;
	prf->data = str;

	// add prf to the list
	if (cfg.profile == NULL) {
		cfg.profile = prf;
		return;
	}
	ProfileEntry *ptr = cfg.profile;
	while (ptr->next != NULL)
		ptr = ptr->next;
	ptr->next = prf;
}

// read a profile file
static int include_level = 0;
void profile_read(const char *fname) {
	EUID_ASSERT();

	// exit program if maximum include level was reached
	if (include_level > MAX_INCLUDE_LEVEL) {
		fprintf(stderr, "Error: maximum profile include level was reached\n");
		exit(1);
	}

	// check file
	invalid_filename(fname, 0); // no globbing
	if (strlen(fname) == 0 || is_dir(fname)) {
		fprintf(stderr, "Error: invalid profile file\n");
		exit(1);
	}
	if (access(fname, R_OK)) {
		int errsv = errno;
		// if the file ends in ".local", do not exit
		const char *base = gnu_basename(fname);
		char *ptr = strstr(base, ".local");
		if (ptr && strlen(ptr) == 6 && errsv != EACCES)
			return;

		fprintf(stderr, "Error: cannot access profile file: %s\n", fname);
		exit(1);
	}

	// --allow-debuggers - skip disable-devel.inc file
	if (arg_allow_debuggers) {
		char *tmp = strrchr(fname, '/');
		if (tmp && *(tmp + 1) != '\0') {
			tmp++;
			if (strcmp(tmp, "disable-devel.inc") == 0)
				return;
		}
	}
	// --appimage - skip disable-shell.inc file
	if (arg_appimage) {
		char *tmp = strrchr(fname, '/');
		if (tmp && *(tmp + 1) != '\0') {
			tmp++;
			if (strcmp(tmp, "disable-shell.inc") == 0)
				return;
		}
	}

	// open profile file:
	FILE *fp = fopen(fname, "re");
	if (fp == NULL) {
		fprintf(stderr, "Error: cannot open profile file %s\n", fname);
		exit(1);
	}

	// save the name of the file for --profile.print option
	if (include_level == 0)
		set_profile_run_file(getpid(), fname);

	int msg_printed = 0;

	// read the file line by line
	char buf[MAX_READ + 1];
	int lineno = 0;
	while (fgets(buf, MAX_READ, fp)) {
		++lineno;

		// remove comments
		char *ptr = strchr(buf, '#');
		if (ptr)
			*ptr = '\0';

		// remove empty space - ptr in allocated memory
		ptr = line_remove_spaces(buf);
		if (ptr == NULL)
			continue;
		if (*ptr == '\0') {
			free(ptr);
			continue;
		}

		if (strncmp(ptr, "whitelist-ro ", 13) == 0) {
			char *whitelist, *readonly;
			if (asprintf(&whitelist, "whitelist %s", ptr + 13) == -1)
				errExit("asprintf");
			profile_add(whitelist);
			if (asprintf(&readonly, "read-only %s", ptr + 13) == -1)
				errExit("asprintf");
			profile_add(readonly);
			free(ptr);
			continue;
		}

		// process quiet
		// todo: a quiet in the profile file cannot be disabled by --ignore on command line
		if (strcmp(ptr, "quiet") == 0) {
			if (is_in_ignore_list(ptr))
				arg_quiet = 0;
			else if (!arg_debug)
				arg_quiet = 1;
			free(ptr);
			continue;
		}
		if (!msg_printed) {
			fmessage("Reading profile %s\n", fname);
			msg_printed = 1;
		}

		// process include
		if (strncmp(ptr, "include ", 8) == 0 && !is_in_ignore_list(ptr)) {
			include_level++;

			// expand macros in front of the include profile file
			char *newprofile = expand_macros(ptr + 8);

			char *ptr2 = newprofile;
			while (*ptr2 != '/' && *ptr2 != '\0')
				ptr2++;
			// profile path contains no / chars, do a search
			if (*ptr2 == '\0') {
				int rv = profile_find_firejail(newprofile, 0); // returns 1 if a profile was found in sysconfig directory
				if (!rv) {
					// maybe this is a file in the local working directory?
					// it will stop the sandbox if not!
					// Note: if the file ends in .local it will not stop the program
					profile_read(newprofile);
				}
			}
			else {
				profile_read(newprofile);
			}

			include_level--;
			free(newprofile);
			free(ptr);
			continue;
		}

		// verify syntax, exit in case of error
		if (profile_check_line(ptr, lineno, fname))
			profile_add(ptr);
// we cannot free ptr here, data is extracted from ptr and linked as a pointer in cfg structure
//		else {
//			free(ptr);
//		}

		__gcov_flush();
	}
	fclose(fp);
}

char *profile_list_normalize(char *list) {
	/* Remove redundant commas.
	 *
	 * As result is always shorter than original,
	 * in-place copying can be used.
	 */
	size_t i = 0;
	size_t j = 0;
	int c;
	while (list[i] == ',')
		++i;
	while ((c = list[i++])) {
		if (c == ',') {
			while (list[i] == ',')
				++i;
			if (list[i] == 0)
				break;
		}
		list[j++] = c;
	}
	list[j] = 0;
	return list;
}

char *profile_list_compress(char *list)
{
	size_t i;

	/* Comma separated list is processed so that:
	 * "item"  -> adds item to list
	 * "-item" -> removes item from list
	 * "+item" -> adds item to list
	 * "=item" -> clear list, add item
	 *
	 * For example:
	 * ,a,,,b,,,c, -> a,b,c
	 * a,,b,,,c,a  -> a,b,c
	 * a,b,c,-a    -> b,c
	 * a,b,c,-a,a  -> b,c,a
	 * a,+b,c      -> a,b,c
	 * a,b,=c,d    -> c,d
	 * a,b,c,=     ->
	 */
	profile_list_normalize(list);

	/* Count items: comma count + 1 */
	size_t count = 1;
	for (i = 0; list[i]; ++i) {
		if (list[i] == ',')
			++count;
	}

	/* Collect items in an array */
	char *in[count];
	count = 0;
	in[count++] = list;
	for (i = 0; list[i]; ++i) {
		if (list[i] != ',')
			continue;
		list[i] = 0;
		in[count++] = list + i + 1;
	}

	/* Filter array: add, remove, reset, filter out duplicates */
	for (i = 0; i < count; ++i) {
		char *item = in[i];
		assert(item);

		size_t k;
		switch (*item) {
		case '-':
			++item;
			/* Do not include this item */
			in[i] = 0;
			/* Remove if already included */
			for (k = 0; k < i; ++k) {
				if (in[k] && !strcmp(in[k], item)) {
					in[k] = 0;
					break;
				}
			}
			break;
		case '+':
			/* Allow +/- symmetry */
			in[i] = ++item;
			/* FALLTHRU */
		default:
			/* Adding empty item is a NOP */
			if (!*item) {
				in[i] = 0;
				break;
			}
			/* Include item unless it is already included */
			for (k = 0; k < i; ++k) {
				if (in[k] && !strcmp(in[k], item)) {
					in[i] = 0;
					break;
				}
			}
			break;
		case '=':
			in[i] = ++item;
			/* Include non-empty item */
			if (!*item)
				in[i] = 0;
			/* Remove all already included items */
			for (k = 0; k < i; ++k)
				in[k] = 0;
			break;
		}
	}

	/* Copying back using in-place data works because the
	 * original order is retained and no item gets longer
	 * than what it used to be.
	 */
	char *pos = list;
	for (i = 0; i < count; ++i) {
		char *item = in[i];
		if (!item)
			continue;
		if (pos > list)
			*pos++ = ',';
		while (*item)
			*pos++ = *item++;
	}
	*pos = 0;
	return list;
}

void profile_list_augment(char **list, const char *items)
{
	char *tmp = 0;
	if (asprintf(&tmp, "%s,%s", *list ?: "", items ?: "") < 0)
		errExit("asprintf");
	free(*list);
	*list = profile_list_compress(tmp);

	// lists should not grow indefinitely
	if (strlen(*list) > MAX_LIST) {
		fprintf(stderr, "Error: argument list is too long\n");
		exit(1);
	}
}
