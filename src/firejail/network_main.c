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
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <net/if.h>
#include <stdarg.h>
#include <sys/wait.h>

// configure bridge structure
// - extract ip address and mask from the bridge interface
static void net_configure_bridge(Bridge *br) {
	assert(br);
	assert(br->dev);

	// check the bridge device exists
	char sysbridge[30 + strlen(br->dev)];
	sprintf(sysbridge, "/sys/class/net/%s/bridge", br->dev);
	struct stat s;
	int rv = stat(sysbridge, &s);
	if (rv == 0) {
		// this is a bridge device
		br->macvlan = 0;
	}
	else {
		// is this a regular Ethernet interface
		if (if_nametoindex(br->dev) > 0) {
			br->macvlan = 1;
			char *newname;
			if (asprintf(&newname, "%s-%u", br->devsandbox, getpid()) == -1)
				errExit("asprintf");
			br->devsandbox = newname;
		}
		else {
			fprintf(stderr, "Error: cannot find network device %s\n", br->dev);
			exit(1);
		}
	}

	int mtu = br->mtu;	// preserve mtu value in case the user changed it with --mtu
	if (net_get_if_addr(br->dev, &br->ip, &br->mask, br->mac, &br->mtu))
		// allow unconfigured interfaces
		fwarning("the network interface %s is not configured\n", br->dev);
	if (mtu)
		br->mtu = mtu;

	if (arg_debug) {
		if (br->macvlan == 0)
			printf("Bridge device %s at %d.%d.%d.%d/%d\n",
				br->dev, PRINT_IP(br->ip), mask2bits(br->mask));
		else
			printf("macvlan parent device %s at %d.%d.%d.%d/%d\n",
				br->dev, PRINT_IP(br->ip), mask2bits(br->mask));
	}

	if (br->mask) {
		uint32_t range = ~br->mask + 1;		  // the number of potential addresses
		// this software is not supported for /31 networks
		if (range < 4) {
			fprintf(stderr, "Error: the software is not supported for /31 networks\n");
			exit(1);
		}
	}


	// no interface network mask - no ip address will be configured
	if (br->mask == 0)
		goto err_no_ip;
	// no interface ip - extract the network address from the address configured by the user
	else if (br->ip == 0 && br->ipsandbox)
		br->ip = br->ipsandbox & br->mask;
	// no interface ip - extract the network address from the default gateway configured by the user
	else if (br->ip == 0 && cfg.defaultgw)
		br->ip = cfg.defaultgw & br->mask;
	// no ip address will be configured
	else if (br->ip == 0)
		goto err_no_ip;

	if ((br->iprange_start && in_netrange(br->iprange_start, br->ip, br->mask)) ||
	    (br->iprange_end && in_netrange(br->iprange_end, br->ip, br->mask))) {
		fprintf(stderr, "Error: IP range addresses not in network range\n");
		exit(1);
	}

	return;

err_no_ip:
	br->arg_ip_none = 1;
	fwarning("Not enough information to configure an IP address for\n   interface --net=%s\n", br->dev);
}


void net_configure_sandbox_ip(Bridge *br) {
	assert(br);
	if (br->configured == 0)
		return;

	if (br->arg_ip_none)
		br->ipsandbox = 0;
	else if (br->ipsandbox) {
		// check network range
		char *rv = in_netrange(br->ipsandbox, br->ip, br->mask);
		if (rv) {
			fprintf(stderr, "%s\n", rv);
			exit(1);
		}
		// send an ARP request and check if there is anybody on this IP address
		if (arp_check(br->dev, br->ipsandbox)) {
			fprintf(stderr, "Error: IP address %d.%d.%d.%d is already in use\n", PRINT_IP(br->ipsandbox));
			exit(1);
		}
	}
	else
		// ip address assigned by arp-scan for a bridge device
		br->ipsandbox = arp_assign(br->dev, br); //br->ip, br->mask);
}


// create a veth pair
// - br - bridge device
// - ifname - interface name in sandbox namespace
// - child - child process running the namespace

void net_configure_veth_pair(Bridge *br, const char *ifname, pid_t child) {
	assert(br);
	if (br->configured == 0)
		return;

	// create a veth pair
	char *dev;
	if (br->veth_name == NULL) {
		if (asprintf(&dev, "veth%u%s", getpid(), ifname) < 0)
			errExit("asprintf");
	}
	else
		dev = br->veth_name;

	char *cstr;
	if (asprintf(&cstr, "%d", child) == -1)
		errExit("asprintf");
	sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 7, PATH_FNET_MAIN, "create", "veth", dev, ifname, br->dev, cstr);
	free(cstr);

	char *msg;
	if (asprintf(&msg, "%d.%d.%d.%d address assigned to sandbox", PRINT_IP(br->ipsandbox)) == -1)
		errExit("asprintf");
	logmsg(msg);
	fflush(0);
	free(msg);
}

// the default address should be in the range of at least on of the bridge devices
void check_default_gw(uint32_t defaultgw) {
	assert(defaultgw);
	if (cfg.bridge0.configured) {
		char *rv = in_netrange(defaultgw, cfg.bridge0.ip, cfg.bridge0.mask);
		if (rv == 0)
			return;
	}
	if (cfg.bridge1.configured) {
		char *rv = in_netrange(defaultgw, cfg.bridge1.ip, cfg.bridge1.mask);
		if (rv == 0)
			return;
	}
	if (cfg.bridge2.configured) {
		char *rv = in_netrange(defaultgw, cfg.bridge2.ip, cfg.bridge2.mask);
		if (rv == 0)
			return;
	}
	if (cfg.bridge3.configured) {
		char *rv = in_netrange(defaultgw, cfg.bridge3.ip, cfg.bridge3.mask);
		if (rv == 0)
			return;
	}

	fprintf(stderr, "Error: default gateway %d.%d.%d.%d is not in the range of any network\n", PRINT_IP(defaultgw));
	exit(1);
}

void net_check_cfg(void) {
	EUID_ASSERT();
	int net_configured = 0;
	if (cfg.bridge0.configured) {
		net_configure_bridge(&cfg.bridge0);
		net_configured++;
	}
	if (cfg.bridge1.configured) {
		net_configure_bridge(&cfg.bridge1);
		net_configured++;
	}
	if (cfg.bridge2.configured) {
		net_configure_bridge(&cfg.bridge2);
		net_configured++;
	}
	if (cfg.bridge3.configured) {
		net_configure_bridge(&cfg.bridge3);
		net_configured++;
	}

	int if_configured = 0;
	if (cfg.interface0.configured)
		if_configured++;
	if (cfg.interface1.configured)
		if_configured++;
	if (cfg.interface2.configured)
		if_configured++;
	if (cfg.interface3.configured)
		if_configured++;

	// --defaultgw requires a network or an interface
	if (cfg.defaultgw && net_configured == 0 && if_configured == 0) {
		fprintf(stderr, "Error: option --defaultgw requires at least one network or one interface to be configured\n");
		exit(1);
	}

	if (net_configured == 0) // nothing to check
		return;

	// --net=none
	if (arg_nonetwork && net_configured) {
		fprintf(stderr, "Error: --net and --net=none are mutually exclusive\n");
		exit(1);
	}

	// check default gateway address or assign one
	assert(cfg.bridge0.configured);
	if (cfg.defaultgw)
		check_default_gw(cfg.defaultgw);
	else {
		// if the first network has no assigned address,
		// do not try to set up a gateway, because it will fail
		if (cfg.bridge0.arg_ip_none)
			return;
		// first network is a regular bridge
		if (cfg.bridge0.macvlan == 0)
			cfg.defaultgw = cfg.bridge0.ip;
		// first network is a mac device
		else {
			// get the host default gw
			EUID_ROOT();	// rise permissions for grsecurity
			// Error fopen:network_get_defaultgw(479): Permission denied
			uint32_t gw = network_get_defaultgw();
			EUID_USER();
			// check the gateway is network range
			if (in_netrange(gw, cfg.bridge0.ip, cfg.bridge0.mask))
				gw = 0;
			cfg.defaultgw = gw;
		}
	}
}

#define MAXBUF 4096
void net_dns_print(pid_t pid) {
	EUID_ASSERT();
	ProcessHandle sandbox = pin_sandbox_process(pid);

	// chroot in the sandbox
	process_rootfs_chroot(sandbox);
	unpin_process(sandbox);

	drop_privs(0);

	// read /etc/resolv.conf
	FILE *fp = fopen("/etc/resolv.conf", "re");
	if (!fp) {
		fprintf(stderr, "Error: cannot read /etc/resolv.conf\n");
		exit(1);
	}

	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp))
		printf("%s", buf);

	exit(0);
}

void network_main(pid_t child) {
	char *cstr;
	if (asprintf(&cstr, "%d", child) == -1)
		errExit("asprintf");

	// create veth pair or macvlan device
	if (cfg.bridge0.configured) {
		if (cfg.bridge0.macvlan == 0) {
			net_configure_veth_pair(&cfg.bridge0, "eth0", child);
		}
		else
			sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 6, PATH_FNET_MAIN, "create", "macvlan", cfg.bridge0.devsandbox, cfg.bridge0.dev, cstr);
	}

	if (cfg.bridge1.configured) {
		if (cfg.bridge1.macvlan == 0)
			net_configure_veth_pair(&cfg.bridge1, "eth1", child);
		else
			sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 6, PATH_FNET_MAIN, "create", "macvlan", cfg.bridge1.devsandbox, cfg.bridge1.dev, cstr);
	}

	if (cfg.bridge2.configured) {
		if (cfg.bridge2.macvlan == 0)
			net_configure_veth_pair(&cfg.bridge2, "eth2", child);
		else
			sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 6, PATH_FNET_MAIN, "create", "macvlan", cfg.bridge2.devsandbox, cfg.bridge2.dev, cstr);
	}

	if (cfg.bridge3.configured) {
		if (cfg.bridge3.macvlan == 0)
			net_configure_veth_pair(&cfg.bridge3, "eth3", child);
		else
			sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 6, PATH_FNET_MAIN, "create", "macvlan", cfg.bridge3.devsandbox, cfg.bridge3.dev, cstr);
	}

	// move interfaces in sandbox
	if (cfg.interface0.configured) {
		sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 4, PATH_FNET_MAIN, "moveif", cfg.interface0.dev, cstr);
	}
	if (cfg.interface1.configured) {
		sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 4, PATH_FNET_MAIN, "moveif", cfg.interface1.dev, cstr);
	}
	if (cfg.interface2.configured) {
		sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 4, PATH_FNET_MAIN, "moveif", cfg.interface2.dev, cstr);
	}
	if (cfg.interface3.configured) {
		sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 4, PATH_FNET_MAIN, "moveif", cfg.interface3.dev, cstr);
	}

	free(cstr);
}

void net_print(pid_t pid) {
	EUID_ASSERT();

	enter_network_namespace(pid);
	sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 2, PATH_FNET_MAIN, "printif");
}
