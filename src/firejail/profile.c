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
#include <dirent.h>
#include <sys/stat.h>
extern char *xephyr_screen;

#define MAX_READ 8192				  // line buffer for profile files

// find and read the profile specified by name from dir directory
int profile_find(const char *name, const char *dir) {
	EUID_ASSERT();
	assert(name);
	assert(dir);

	int rv = 0;
	DIR *dp;
	char *pname;
	if (asprintf(&pname, "%s.profile", name) == -1)
		errExit("asprintf");

	dp = opendir (dir);
	if (dp != NULL) {
		struct dirent *ep;
		while ((ep = readdir(dp)) != NULL) {
			if (strcmp(ep->d_name, pname) == 0) {
				if (arg_debug)
					printf("Found %s profile in %s directory\n", name, dir);
				char *etcpname;
				if (asprintf(&etcpname, "%s/%s", dir, pname) == -1)
					errExit("asprintf");
				profile_read(etcpname);
				free(etcpname);
				rv = 1;
				break;
			}
		}
		(void) closedir (dp);
	}

	free(pname);
	return rv;
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


// check profile line; if line == 0, this was generated from a command line option
// return 1 if the command is to be added to the linked list of profile commands
// return 0 if the command was already executed inside the function
int profile_check_line(char *ptr, int lineno, const char *fname) {
	EUID_ASSERT();

	// check ignore list
	if (is_in_ignore_list(ptr))
		return 0;

	if (strncmp(ptr, "ignore ", 7) == 0) {
		profile_add_ignore(ptr + 7);
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
#ifdef HAVE_SECCOMP
		if (checkcfg(CFG_SECCOMP))
			arg_seccomp = 1;
		else
			warning_feature_disabled("seccomp");
#endif
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
	else if (strcmp(ptr, "shell none") == 0) {
		arg_shell_none = 1;
		return 0;
	}
	else if (strcmp(ptr, "private") == 0) {
		arg_private = 1;
		return 0;
	}
	else if (strcmp(ptr, "allusers") == 0) {
		arg_allusers = 1;
		return 0;
	}
	else if (strcmp(ptr, "private-cache") == 0) {
		if (checkcfg(CFG_PRIVATE_CACHE))
			arg_private_cache = 1;
		else
			warning_feature_disabled("private-cache");
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
		arg_noautopulse = 1;
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
	else if (strcmp(ptr, "nodbus") == 0) {
		arg_nodbus = 1;
		return 0;
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
			arg_netfilter_file = strdup(ptr + 10);
			if (!arg_netfilter_file)
				errExit("strdup");
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
			arg_netfilter6_file = strdup(ptr + 11);
			if (!arg_netfilter6_file)
				errExit("strdup");
			check_netfilter_file(arg_netfilter6_file);
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
			else {
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
			if (br->ip6sandbox) {
				fprintf(stderr, "Error: cannot configure the IP address twice for the same interface\n");
				exit(1);
			}

			// configure this IP address for the last bridge defined
			if (check_ip46_address(ptr + 4) == 0) {
				fprintf(stderr, "Error: invalid IPv6 address\n");
				exit(1);
			}

			br->ip6sandbox = strdup(ptr + 4);
			if (br->ip6sandbox == NULL)
				errExit("strdup");

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
#endif
		return 0;
	}

	if (strncmp(ptr, "protocol ", 9) == 0) {
#ifdef HAVE_SECCOMP
		if (checkcfg(CFG_SECCOMP)) {
			if (cfg.protocol) {
				fwarning("two protocol lists are present, \"%s\" will be installed\n", cfg.protocol);
				return 0;
			}

			// store list
			cfg.protocol = strdup(ptr + 9);
			if (!cfg.protocol)
				errExit("strdup");
		}
		else
			warning_feature_disabled("seccomp");
#endif
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
#ifdef HAVE_SECCOMP
		if (checkcfg(CFG_SECCOMP)) {
			arg_seccomp = 1;
			cfg.seccomp_list = seccomp_check_list(ptr + 8);
		}
		else if (!arg_quiet)
			warning_feature_disabled("seccomp");
#endif

		return 0;
	}

	if (strcmp(ptr, "seccomp.block-secondary") == 0) {
#ifdef HAVE_SECCOMP
		if (checkcfg(CFG_SECCOMP)) {
			arg_seccomp_block_secondary = 1;
		}
		else
			warning_feature_disabled("seccomp");
#endif
		return 0;
	}
	// seccomp drop list without default list
	if (strcmp(ptr, "seccomp.drop") == 0) {
		fprintf(stderr, "Error: line %d in %s is invalid\n", lineno, fname);
		exit(1);
	}
	if (strncmp(ptr, "seccomp.drop ", 13) == 0) {
#ifdef HAVE_SECCOMP
		if (checkcfg(CFG_SECCOMP)) {
			arg_seccomp = 1;
			cfg.seccomp_list_drop = seccomp_check_list(ptr + 13);
		}
		else
			warning_feature_disabled("seccomp");
#endif
		return 0;
	}

	// seccomp keep list
	if (strcmp(ptr, "seccomp.keep") == 0) {
		fprintf(stderr, "Error: line %d in %s is invalid\n", lineno, fname);
		exit(1);
	}
	if (strncmp(ptr, "seccomp.keep ", 13) == 0) {
#ifdef HAVE_SECCOMP
		if (checkcfg(CFG_SECCOMP)) {
			arg_seccomp = 1;
			cfg.seccomp_list_keep= seccomp_check_list(ptr + 13);
		}
		else
			warning_feature_disabled("seccomp");
#endif
		return 0;
	}

	// memory deny write&execute
	if (strcmp(ptr, "memory-deny-write-execute") == 0) {
#ifdef HAVE_SECCOMP
		if (checkcfg(CFG_SECCOMP))
			arg_memory_deny_write_execute = 1;
		else
			warning_feature_disabled("seccomp");
#endif
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
			fprintf(stderr, "Error: up to 4 DNS servers can be specified\n");
			free(dns);
			return 1;
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
		arg_writable_etc = 1;
		return 0;
	}

	if (strcmp(ptr, "machine-id") == 0) {
		arg_machineid = 1;
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

	// filesystem bind
	if (strncmp(ptr, "bind ", 5) == 0) {
		if (checkcfg(CFG_BIND)) {
			if (getuid() != 0) {
				fprintf(stderr, "Error: --bind option is available only if running as root\n");
				exit(1);
			}

			// extract two directories
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


	if (strncmp(ptr, "timeout ", 8) == 0) {
		cfg.timeout = extract_timeout(ptr +8);
		return 0;
	}

	if (strncmp(ptr, "join-or-start ", 14) == 0) {
		// try to join by name only
		pid_t pid;
		if (!name2pid(ptr + 14, &pid)) {
			if (!cfg.shell && !arg_shell_none)
				cfg.shell = guess_shell();

			// find first non-option arg
			int i;
			for (i = 1; i < cfg.original_argc && strncmp(cfg.original_argv[i], "--", 2) != 0; i++);

			join(pid, cfg.original_argc,cfg.original_argv, i + 1);
			exit(0);
		}

		// set sandbox name and start normally
		cfg.name = ptr + 14;
		if (strlen(cfg.name) == 0) {
			fprintf(stderr, "Error: invalid sandbox name\n");
			exit(1);
		}
		return 0;
	}

	if (strcmp(ptr, "disable-mnt") == 0) {
		arg_disable_mnt = 1;
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
#ifdef HAVE_WHITELIST
		if (checkcfg(CFG_WHITELIST)) {
			arg_whitelist = 1;
			ptr += 10;
		}
		else
			return 0;
#else
		return 0;
#endif
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
		if (getuid() != 0) {
			fprintf(stderr, "Error: tmpfs available only when running the sandbox as root\n");
			exit(1);
		}
		ptr += 6;
	}
	else {
		if (lineno == 0) {
			fprintf(stderr, "Error: \"%s\" as a command line option is invalid\n", ptr);
			exit(1);
		}
		else {
			fwarning("\"%s\" is not supported in LTS build\n", ptr);
			return 0;
		}
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
		// if the file ends in ".local", do not exit
		const char *base = gnu_basename(fname);
		char *ptr = strstr(base, ".local");
		if (ptr && strlen(ptr) == 6)
			return;

		fprintf(stderr, "Error: cannot access profile file\n");
		exit(1);
	}

	// allow debuggers
	if (arg_allow_debuggers) {
		char *tmp = strrchr(fname, '/');
		if (tmp && *(tmp + 1) != '\0') {
			tmp++;
			if (strcmp(tmp, "disable-devel.inc") == 0)
				return;
		}
	}

	// open profile file:
	FILE *fp = fopen(fname, "r");
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
		// remove empty space - ptr in allocated memory
		char *ptr = line_remove_spaces(buf);
		if (ptr == NULL)
			continue;

		// comments
		if (*ptr == '#' || *ptr == '\0') {
			free(ptr);
			continue;
		}

		// process quiet
		// todo: a quiet in the profile file cannot be disabled by --ignore on command line
		if (strcmp(ptr, "quiet") == 0) {
			if (is_in_ignore_list(ptr))
				arg_quiet = 0;
			else
				arg_quiet = 1;
			free(ptr);
			continue;
		}
		if (!msg_printed) {
			fmessage("Reading profile %s\n", fname);
			msg_printed = 1;
		}

		// process include
		if (strncmp(ptr, "include ", 8) == 0) {
			include_level++;

			// extract profile filename and new skip params
			char *newprofile = ptr + 8; // profile name

			// expand ${HOME}/ in front of the new profile file
			char *newprofile2 = expand_home(newprofile, cfg.homedir);

			// recursivity
			profile_read((newprofile2)? newprofile2:newprofile);
			include_level--;
			if (newprofile2)
				free(newprofile2);
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
#ifdef HAVE_GCOV
		__gcov_flush();
#endif
	}
	fclose(fp);
}
