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
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <linux/if_ether.h>			  //TCP/IP Protocol Suite for Linux
#include <net/if.h>
#include <netinet/in.h>
#include <linux/ip.h>
#include <linux/udp.h>
#include <linux/tcp.h>
#include <linux/if_packet.h>

typedef struct arp_hdr_t {
	uint16_t htype;
	uint16_t ptype;
	uint8_t hlen;
	uint8_t plen;
	uint16_t opcode;
	uint8_t sender_mac[6];
	uint8_t sender_ip[4];
	uint8_t target_mac[6];
	uint8_t target_ip[4];
} ArpHdr;


// gracious arp announcing our address
void arp_announce(const char *dev, Bridge *br) {
	// RFC 5227 - using a source and destination IP address of the interface
	uint32_t srcaddr = br->ipsandbox;
	uint32_t destaddr = srcaddr;

	if (strlen(dev) > IFNAMSIZ) {
		fprintf(stderr, "Error: invalid network device name %s\n", dev);
		exit(1);
	}

	if (arg_debug)
		printf("Announce %d.%d.%d.%d ...\n", PRINT_IP(destaddr));

	// find interface address
	int sock;
	if ((sock = socket(AF_INET, SOCK_RAW, IPPROTO_RAW)) < 0)
		errExit("socket");

	srcaddr = htonl(srcaddr);
	destaddr = htonl(destaddr);

	// Find interface MAC address
	struct ifreq ifr;
	memset(&ifr, 0, sizeof (ifr));
	strncpy(ifr.ifr_name, dev, IFNAMSIZ - 1);
	if (ioctl(sock, SIOCGIFHWADDR, &ifr) < 0)
		errExit("ioctl");
	close(sock);

	// configure layer2 socket address information
	struct sockaddr_ll addr;
	memset(&addr, 0, sizeof(addr));
	if ((addr.sll_ifindex = if_nametoindex(dev)) == 0)
		errExit("if_nametoindex");
	addr.sll_family = AF_PACKET;
	memcpy (addr.sll_addr, ifr.ifr_hwaddr.sa_data, 6);
	addr.sll_halen = ETH_ALEN;

	// build the arp packet header
	ArpHdr hdr;
	memset(&hdr, 0, sizeof(hdr));
	hdr.htype = htons(1);
	hdr.ptype = htons(ETH_P_IP);
	hdr.hlen = 6;
	hdr.plen = 4;
	hdr.opcode = htons(1); //ARPOP_REQUEST
	memcpy(hdr.sender_mac, ifr.ifr_hwaddr.sa_data, 6);
	memcpy(hdr.sender_ip, (uint8_t *)&srcaddr, 4);
	memcpy(hdr.target_ip, (uint8_t *)&destaddr, 4);

	// build ethernet frame
	uint8_t frame[ETH_FRAME_LEN]; // includes eht header, vlan, and crc
	memset(frame, 0, sizeof(frame));
	frame[0] = frame[1] = frame[2] = frame[3] = frame[4] = frame[5] = 0xff;
	memcpy(frame + 6, ifr.ifr_hwaddr.sa_data, 6);
	frame[12] = ETH_P_ARP / 256;
	frame[13] = ETH_P_ARP % 256;
	memcpy (frame + 14, &hdr, sizeof(hdr));

	// open layer2 socket
	if ((sock = socket(PF_PACKET, SOCK_RAW, htons (ETH_P_ALL))) < 0)
		errExit("socket");

	if (sendto (sock, frame, 14 + sizeof(ArpHdr), 0, (struct sockaddr *) &addr, sizeof (addr)) <= 0)
		errExit("send");
	fflush(0);
	close(sock);
}



// returns 0 if the address is not in use, -1 otherwise
int arp_check(const char *dev, uint32_t destaddr) {
	// RFC 5227 - using a source IP address of 0 for probing
	uint32_t srcaddr = 0;

	if (strlen(dev) > IFNAMSIZ) {
		fprintf(stderr, "Error: invalid network device name %s\n", dev);
		exit(1);
	}

	if (arg_debug)
		printf("Trying %d.%d.%d.%d ...\n", PRINT_IP(destaddr));

	// find interface address
	int sock;
	if ((sock = socket(AF_INET, SOCK_RAW, IPPROTO_RAW)) < 0)
		errExit("socket");

	srcaddr = htonl(srcaddr);
	destaddr = htonl(destaddr);

	// Find interface MAC address
	struct ifreq ifr;
	memset(&ifr, 0, sizeof (ifr));
	strncpy(ifr.ifr_name, dev, IFNAMSIZ - 1);
	if (ioctl(sock, SIOCGIFHWADDR, &ifr) < 0)
		errExit("ioctl");
	close(sock);

	// configure layer2 socket address information
	struct sockaddr_ll addr;
	memset(&addr, 0, sizeof(addr));
	if ((addr.sll_ifindex = if_nametoindex(dev)) == 0)
		errExit("if_nametoindex");
	addr.sll_family = AF_PACKET;
	memcpy (addr.sll_addr, ifr.ifr_hwaddr.sa_data, 6);
	addr.sll_halen = ETH_ALEN;

	// build the arp packet header
	ArpHdr hdr;
	memset(&hdr, 0, sizeof(hdr));
	hdr.htype = htons(1);
	hdr.ptype = htons(ETH_P_IP);
	hdr.hlen = 6;
	hdr.plen = 4;
	hdr.opcode = htons(1); //ARPOP_REQUEST
	memcpy(hdr.sender_mac, ifr.ifr_hwaddr.sa_data, 6);
	memcpy(hdr.sender_ip, (uint8_t *)&srcaddr, 4);
	memcpy(hdr.target_ip, (uint8_t *)&destaddr, 4);

	// build ethernet frame
	uint8_t frame[ETH_FRAME_LEN]; // includes eth header, vlan, and crc
	memset(frame, 0, sizeof(frame));
	frame[0] = frame[1] = frame[2] = frame[3] = frame[4] = frame[5] = 0xff;
	memcpy(frame + 6, ifr.ifr_hwaddr.sa_data, 6);
	frame[12] = ETH_P_ARP / 256;
	frame[13] = ETH_P_ARP % 256;
	memcpy (frame + 14, &hdr, sizeof(hdr));

	// open layer2 socket
	if ((sock = socket(PF_PACKET, SOCK_RAW, htons (ETH_P_ALL))) < 0)
		errExit("socket");

	if (sendto (sock, frame, 14 + sizeof(ArpHdr), 0, (struct sockaddr *) &addr, sizeof (addr)) <= 0)
		errExit("send");
	fflush(0);

	// send two probes at 0.5 seconds interva;
	int  cnt = checkcfg(CFG_ARP_PROBES);
	uint8_t framerx[ETH_FRAME_LEN]; // includes eth header, vlan, and crc
	fd_set fds;
	FD_ZERO(&fds);
	FD_SET(sock, &fds);
	int maxfd = sock;
	struct timeval ts;
	gettimeofday(&ts, NULL);
	double timerend = ts.tv_sec + ts.tv_usec / 1000000.0 + 0.5;
	while (1) {
		gettimeofday(&ts, NULL);
		double now = ts.tv_sec + ts.tv_usec / 1000000.0;
		double timeout = timerend - now;
		ts.tv_sec = timeout;
		ts.tv_usec = (timeout - ts.tv_sec) * 1000000;
		if (ts.tv_sec < 0)
			ts.tv_sec = 0;
		if (ts.tv_usec < 0)
			ts.tv_usec = 0;
		int nready = select(maxfd + 1, &fds, (fd_set *) 0, (fd_set *) 0, &ts);
		if (nready < 0)
			errExit("select");
		else if (nready == 0) { // timeout
			if (--cnt <= 0) {
				close(sock);
				return 0;
			}
			if (sendto (sock, frame, 14 + sizeof(ArpHdr), 0, (struct sockaddr *) &addr, sizeof (addr)) <= 0)
				errExit("send");
			gettimeofday(&ts, NULL);
			timerend = ts.tv_sec + ts.tv_usec / 1000000.0 + 0.5;
			fflush(0);
		}
		else {
			// read the incoming packet
			int len = recvfrom(sock, framerx, ETH_FRAME_LEN, 0, NULL, NULL);
			if (len < 0) {
				perror("recvfrom");
				close(sock);
				return -1;
			}

			// parse the incoming packet
			if ((unsigned int) len < 14 + sizeof(ArpHdr))
				continue;
			if (framerx[12] != (ETH_P_ARP / 256) || framerx[13] != (ETH_P_ARP % 256))
				continue;
			memcpy(&hdr, framerx + 14, sizeof(ArpHdr));
			if (hdr.opcode == htons(1))
				continue;
			if (hdr.opcode == htons(2)) {
				// check my mac and my address
				if (memcmp(ifr.ifr_hwaddr.sa_data, hdr.target_mac, 6) != 0)
					continue;
				uint32_t ip;
				memcpy(&ip, hdr.target_ip, 4);
				if (ip != srcaddr) {
					continue;
				}
				close(sock);
				return -1;
			}
		}
	}

	__builtin_unreachable();
}

// assign a random IP address and check it
// the address needs to be in the range if it --iprange was specified
static uint32_t arp_random(const char *dev, Bridge *br) {
	assert(dev);
	assert(br);
	uint32_t ifip = br->ip;
	uint32_t ifmask = br->mask;
	assert(ifip);
	assert(ifmask);

	if (arg_debug)
		printf("ARP-scan %s, %d.%d.%d.%d/%d\n",
			dev, PRINT_IP(ifip), mask2bits(ifmask));

	// determine the range based on network address
	uint32_t range = ~ifmask + 1; // the number of potential addresses
	// this software is not supported for /31 networks
	if (range < 4)
		return 0; // the user will have to set the IP address manually
	range -= 2; // subtract the network address and the broadcast address
	uint32_t start = (ifip & ifmask) + 1;

	// adjust range based on --iprange params
	if (br->iprange_start && br->iprange_end) {
		start = br->iprange_start;
		range = br->iprange_end - br->iprange_start;
	}

	if (arg_debug)
		printf("IP address range from %d.%d.%d.%d to %d.%d.%d.%d\n",
			PRINT_IP(start), PRINT_IP(start + range));

	// generate a random address - 10 tries
	uint32_t dest = 0;
	int i = 0;
	for (i = 0; i < 10; i++) {
		dest = start + ((uint32_t) rand()) % range;
		if (dest == ifip || dest == cfg.defaultgw)	// do not allow the interface address or the default gateway
			continue;		// try again

		// if we've made it up to here, we have a valid address
		break;
	}
	if (i == 10)	// we failed 10 times
		return 0;

	// check address
	uint32_t rv = arp_check(dev, dest);
	if (!rv)
		return dest;
	return 0;
}

// go sequentially through all IP addresses and assign the first one not in use
static uint32_t arp_sequential(const char *dev, Bridge *br) {
	assert(dev);
	assert(br);
	uint32_t ifip = br->ip;
	uint32_t ifmask = br->mask;
	assert(ifip);
	assert(ifmask);

	// range based on network address
	uint32_t range = ~ifmask + 1; // the number of potential addresses
	// this software is not supported for /31 networks
	if (range < 4)
		return 0; // the user will have to set the IP address manually
	range -= 2; // subtract the network address and the broadcast address

	// try all possible ip addresses in ascending order
	// start address
	uint32_t dest = (ifip & ifmask) + 1;
	if (br->iprange_start)
		dest = br->iprange_start;
	// end address
	uint32_t last = dest + range - 1;
	if (br->iprange_end)
		last = br->iprange_end;

	if (arg_debug)
		printf("Trying IP address range from %d.%d.%d.%d to %d.%d.%d.%d\n",
			PRINT_IP(dest), PRINT_IP(last));

	// loop through addresses and stop as soon as you find an unused one
	while (dest <= last) {
		if (dest == ifip || dest == cfg.defaultgw) {
			dest++;
			continue;
		}
		uint32_t rv = arp_check(dev, dest);
		if (!rv)
			return dest;
		dest++;
	}

	return 0;
}

// assign an IP address first trying some random addresses, and if this fails
//    by doing an arp scan.
//
// dev is the name of the device to use in scanning,
// br is bridge structure holding the ip address and mask to use in
//    arp packets. It also holds values for for the range of addresses
//    if --iprange was set by the user
uint32_t arp_assign(const char *dev, Bridge *br) {
	assert(br);
	uint32_t ip = 0;

	// try two random IP addresses
	ip = arp_random(dev, br);
	if (!ip)
		ip = arp_random(dev, br);

	// try all possible IP addresses one by one
	if (!ip)
		ip = arp_sequential(dev, br);

	// print result
	if (!ip) {
		fprintf(stderr, "Error: cannot assign an IP address; it looks like all of them are in use.\n");
		logerr("Cannot assign an IP address; it looks like all of them are in use.");
		exit(1);
	}

	return ip;
}
