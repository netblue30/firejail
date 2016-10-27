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

#include "fnet.h"
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netdb.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <net/if_arp.h>
#include <net/route.h>
#include <linux/if_bridge.h>

// add a veth device to a bridge
void net_bridge_add_interface(const char *bridge, const char *dev) {
	if (strlen(bridge) > IFNAMSIZ) {
		fprintf(stderr, "Error fnet: invalid network device name %s\n", bridge);
		exit(1);
	}

	// somehow adding the interface to the bridge resets MTU on bridge device!!!
	// workaround: restore MTU on the bridge device
	// todo: put a real fix in
	int mtu1 = net_get_mtu(bridge);

	struct ifreq ifr;
	int err;
	int ifindex = if_nametoindex(dev);

	if (ifindex <= 0)
		errExit("if_nametoindex");

	int sock;
	if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
              	errExit("socket");

	memset(&ifr, 0, sizeof(ifr));
	strncpy(ifr.ifr_name, bridge, IFNAMSIZ);
#ifdef SIOCBRADDIF
	ifr.ifr_ifindex = ifindex;
	err = ioctl(sock, SIOCBRADDIF, &ifr);
	if (err < 0)
#endif
	{
		unsigned long args[4] = { BRCTL_ADD_IF, ifindex, 0, 0 };

		ifr.ifr_data = (char *) args;
		err = ioctl(sock, SIOCDEVPRIVATE, &ifr);
	}
	(void) err;
	close(sock);

	int mtu2 = net_get_mtu(bridge);
	if (mtu1 != mtu2) {
		net_set_mtu(bridge, mtu1);
	}
}


// bring interface up
void net_if_up(const char *ifname) {
	if (strlen(ifname) > IFNAMSIZ) {
		fprintf(stderr, "Error fnet: invalid network device name %s\n", ifname);
		exit(1);
	}
	
	int sock = socket(AF_INET,SOCK_DGRAM,0);
	if (sock < 0)
		errExit("socket");

	// get the existing interface flags
	struct ifreq ifr;
	memset(&ifr, 0, sizeof(ifr));
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ);
	ifr.ifr_addr.sa_family = AF_INET;

	// read the existing flags
	if (ioctl(sock, SIOCGIFFLAGS, &ifr ) < 0) {
		close(sock);
		printf("Error fnet: cannot bring up interface %s\n", ifname);
		errExit("ioctl");
	}

	ifr.ifr_flags |= IFF_UP;

	// set the new flags
	if (ioctl( sock, SIOCSIFFLAGS, &ifr ) < 0) {
		close(sock);
		printf("Error fnet: cannot bring up interface %s\n", ifname);
		errExit("ioctl");
	}

	// checking
	// read the existing flags
	if (ioctl(sock, SIOCGIFFLAGS, &ifr ) < 0) {
		close(sock);
		printf("Error fnet: cannot bring up interface %s\n", ifname);
		errExit("ioctl");
	}

	// wait not more than 500ms for the interface to come up
	int cnt = 0;
	while (cnt < 50) {
		usleep(10000);			  // sleep 10ms

		// read the existing flags
		if (ioctl(sock, SIOCGIFFLAGS, &ifr ) < 0) {
			close(sock);
			printf("Error fnet: cannot bring up interface %s\n", ifname);
			errExit("ioctl");
		}
		if (ifr.ifr_flags & IFF_RUNNING)
			break;
		cnt++;
	}

	close(sock);
}

int net_get_mtu(const char *ifname) {
	int mtu = 0;
	if (strlen(ifname) > IFNAMSIZ) {
		fprintf(stderr, "Error fnet: invalid network device name %s\n", ifname);
		exit(1);
	}

	int s;
	struct ifreq ifr;

	if ((s = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
		errExit("socket");

	memset(&ifr, 0, sizeof(ifr));
	ifr.ifr_addr.sa_family = AF_INET;
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ);
	if (ioctl(s, SIOCGIFMTU, (caddr_t)&ifr) == 0)
		mtu = ifr.ifr_mtu;
	close(s);
	
	
	return mtu;
}

void net_set_mtu(const char *ifname, int mtu) {
	if (strlen(ifname) > IFNAMSIZ) {
		fprintf(stderr, "Error fnet: invalid network device name %s\n", ifname);
		exit(1);
	}

	int s;
	struct ifreq ifr;

	if ((s = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
		errExit("socket");

	memset(&ifr, 0, sizeof(ifr));
	ifr.ifr_addr.sa_family = AF_INET;
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ);
	ifr.ifr_mtu = mtu;
	if (ioctl(s, SIOCSIFMTU, (caddr_t)&ifr) != 0)
		fprintf(stderr, "Warning fnet: cannot set mtu for interface %s\n", ifname);
	close(s);
}


