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
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <errno.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>

pid_t dhclient4_pid = 0;
pid_t dhclient6_pid = 0;

typedef struct {
	char *version_arg;
	char *pid_file;
	char *leases_file;
	uint8_t generate_duid;
	char *duid_leases_file;
	pid_t *pid;
	ptrdiff_t arg_offset;
} Dhclient;

static const Dhclient dhclient4 = {
	.version_arg = "-4",
	.pid_file = RUN_DHCLIENT_4_PID_FILE,
	.leases_file = RUN_DHCLIENT_4_LEASES_FILE,
	.generate_duid = 1,
	.pid = &dhclient4_pid,
	.arg_offset = offsetof(Bridge, arg_ip_dhcp)
};

static const Dhclient dhclient6 = {
	.version_arg = "-6",
	.pid_file = RUN_DHCLIENT_6_PID_FILE,
	.leases_file = RUN_DHCLIENT_6_LEASES_FILE,
	.duid_leases_file = RUN_DHCLIENT_4_LEASES_FILE,
	.pid = &dhclient6_pid,
	.arg_offset = offsetof(Bridge, arg_ip6_dhcp)
};

static void dhcp_run_dhclient(char *dhclient_path, const Dhclient *client) {
	char *argv[256] = {
		dhclient_path,
		client->version_arg,
		"-pf", client->pid_file,
		"-lf", client->leases_file,
	};
	int i = 6;
	if (client->generate_duid)
		argv[i++] = "-i";
	if (client->duid_leases_file) {
		argv[i++] = "-df";
		argv[i++] = client->duid_leases_file;
	}
	if (arg_debug)
		argv[i++] = "-v";
	if (*(uint8_t *)((char *)&cfg.bridge0 + client->arg_offset))
		argv[i++] = cfg.bridge0.devsandbox;
	if (*(uint8_t *)((char *)&cfg.bridge1 + client->arg_offset))
		argv[i++] = cfg.bridge1.devsandbox;
	if (*(uint8_t *)((char *)&cfg.bridge2 + client->arg_offset))
		argv[i++] = cfg.bridge2.devsandbox;
	if (*(uint8_t *)((char *)&cfg.bridge3 + client->arg_offset))
		argv[i++] = cfg.bridge3.devsandbox;

	sbox_run_v(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_CAPS_NET_SERVICE | SBOX_SECCOMP, argv);
}

static pid_t dhcp_read_pidfile(const Dhclient *client) {
	// We have to run dhclient as a forking daemon (not pass the -d option),
	// because we want to be notified of a successful DHCP lease by the parent process exit.
	int tries = 0;
	pid_t found = 0;
	while (found == 0 && tries < 10) {
		if (tries >= 1)
			usleep(100000);
		FILE *pidfile = fopen(client->pid_file, "re");
		if (pidfile) {
			long pid;
			if (fscanf(pidfile, "%ld", &pid) == 1)
				found = (pid_t) pid;
			fclose(pidfile);
		}
		++tries;
	}
	if (found == 0) {
		fprintf(stderr, "Error: Cannot get dhclient %s PID from %s\n",
						client->version_arg, client->pid_file);
		exit(1);
	}
	return found;
}

static void dhcp_start_dhclient(char *dhclient_path, const Dhclient *client) {
	dhcp_run_dhclient(dhclient_path, client);
	*(client->pid) = dhcp_read_pidfile(client);
}

static void dhcp_waitll(const char *ifname) {
	sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 3, PATH_FNET, "waitll", ifname);
}

static void dhcp_waitll_all() {
	if (cfg.bridge0.arg_ip6_dhcp)
		dhcp_waitll(cfg.bridge0.devsandbox);
	if (cfg.bridge1.arg_ip6_dhcp)
		dhcp_waitll(cfg.bridge1.devsandbox);
	if (cfg.bridge2.arg_ip6_dhcp)
		dhcp_waitll(cfg.bridge2.devsandbox);
	if (cfg.bridge3.arg_ip6_dhcp)
		dhcp_waitll(cfg.bridge3.devsandbox);
}

// Temporarily copy dhclient executable under /run/firejail/mnt and start it from there
// in order to recognize it later in firemon and firetools
void dhcp_store_exec(void) {
	if (!any_dhcp())
		return;

	char *dhclient_path = "/sbin/dhclient";
	struct stat s;
	if (stat(dhclient_path, &s) == -1) {
		dhclient_path = "/usr/sbin/dhclient";
		if (stat(dhclient_path, &s) == -1) {
			fprintf(stderr, "Error: dhclient was not found.\n");
			exit(1);
		}
	}

	sbox_run(SBOX_ROOT| SBOX_SECCOMP, 4, PATH_FCOPY, "--follow-link", dhclient_path, RUN_MNT_DIR);
}

void dhcp_start(void) {
	if (!any_dhcp())
		return;

	char *dhclient_path = RUN_MNT_DIR "/dhclient";
	struct stat s;
	if (stat(dhclient_path, &s) == -1) {
		fprintf(stderr, "Error: %s was not found.\n", dhclient_path);
		exit(1);
	}

	EUID_ROOT();
	if (mkdir(RUN_DHCLIENT_DIR, 0700))
		errExit("mkdir");

	if (any_ip_dhcp()) {
		dhcp_start_dhclient(dhclient_path, &dhclient4);
		if (arg_debug)
			printf("Running dhclient -4 in the background as pid %ld\n", (long) dhclient4_pid);
	}
	if (any_ip6_dhcp()) {
		dhcp_waitll_all();
		dhcp_start_dhclient(dhclient_path, &dhclient6);
		if (arg_debug)
			printf("Running dhclient -6 in the background as pid %ld\n", (long) dhclient6_pid);
		if (dhclient4_pid == dhclient6_pid) {
			fprintf(stderr, "Error: dhclient -4 and -6 have the same PID: %ld\n", (long) dhclient4_pid);
			exit(1);
		}
	}

	unlink(dhclient_path);
}
