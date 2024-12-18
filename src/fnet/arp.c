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
#include "fnet.h"
#include <sys/socket.h>
#include <sys/ioctl.h>
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


// scan interface (--scan option)
void arp_scan(const char *dev, uint32_t ifip, uint32_t ifmask) {
	assert(dev);
	assert(ifip);

//	printf("Scanning interface %s (%d.%d.%d.%d/%d)\n",
//		dev, PRINT_IP(ifip & ifmask), mask2bits(ifmask));

	if (strlen(dev) > IFNAMSIZ) {
		fprintf(stderr, "Error: invalid network device name %s\n", dev);
		exit(1);
	}

	// find interface mac address
	int sock;
	if ((sock = socket(AF_INET, SOCK_RAW, IPPROTO_RAW)) < 0)
		errExit("socket");
	struct ifreq ifr;
	memset(&ifr, 0, sizeof (ifr));
	strncpy(ifr.ifr_name, dev, IFNAMSIZ - 1);
	if (ioctl(sock, SIOCGIFHWADDR, &ifr) < 0)
		errExit("ioctl");
	close(sock);
	uint8_t mac[6];
	memcpy (mac, ifr.ifr_hwaddr.sa_data, 6);

	// open layer2 socket
	if ((sock = socket(PF_PACKET, SOCK_RAW, htons (ETH_P_ALL))) < 0)
		errExit("socket");

	// try all possible ip addresses in ascending order
	uint32_t range = ~ifmask + 1; // the number of potential addresses
	// this software is not supported for /31 networks
	if (range < 4) {
		fprintf(stderr, "Warning: this option is not supported for /31 networks\n");
		close(sock);
		return;
	}

	uint32_t dest = (ifip & ifmask) + 1;
	uint32_t last = dest + range - 1;
	uint32_t src = htonl(ifip);

	// wait not more than one second for an answer
	int header_printed = 0;
	uint32_t last_ip = 0;
	struct timeval ts;
	ts.tv_sec = 2; // 2 seconds receive timeout
	ts.tv_usec = 0;

	while (1) {
		fd_set rfds;
		FD_ZERO(&rfds);
		FD_SET(sock, &rfds);
		fd_set wfds;
		FD_ZERO(&wfds);
		FD_SET(sock, &wfds);
		int maxfd = sock;

		uint8_t frame[ETH_FRAME_LEN]; // includes eht header, vlan, and crc
		memset(frame, 0, ETH_FRAME_LEN);

		int nready;
		if (dest < last)
			nready = select(maxfd + 1,  &rfds, &wfds, (fd_set *) 0, NULL);
		else
			nready = select(maxfd + 1,  &rfds,  (fd_set *) 0, (fd_set *) 0, &ts);

		if (nready < 0)
			errExit("select");

		if (nready == 0) { // timeout
			break;
		}

		if (FD_ISSET(sock, &wfds) && dest < last) {
			// configure layer2 socket address information
			struct sockaddr_ll addr;
			memset(&addr, 0, sizeof(addr));
			if ((addr.sll_ifindex = if_nametoindex(dev)) == 0)
				errExit("if_nametoindex");
			addr.sll_family = AF_PACKET;
			memcpy (addr.sll_addr, mac, 6);
			addr.sll_halen = ETH_ALEN;

			// build the arp packet header
			ArpHdr hdr;
			memset(&hdr, 0, sizeof(hdr));
			hdr.htype = htons(1);
			hdr.ptype = htons(ETH_P_IP);
			hdr.hlen = 6;
			hdr.plen = 4;
			hdr.opcode = htons(1); //ARPOP_REQUEST
			memcpy(hdr.sender_mac, mac, 6);
			memcpy(hdr.sender_ip, (uint8_t *)&src, 4);
			uint32_t dst = htonl(dest);
			memcpy(hdr.target_ip, (uint8_t *)&dst, 4);

			// build ethernet frame
			uint8_t frame[ETH_FRAME_LEN]; // includes eht header, vlan, and crc
			memset(frame, 0, sizeof(frame));
			frame[0] = frame[1] = frame[2] = frame[3] = frame[4] = frame[5] = 0xff;
			memcpy(frame + 6, mac, 6);
			frame[12] = ETH_P_ARP / 256;
			frame[13] = ETH_P_ARP % 256;
			memcpy (frame + 14, &hdr, sizeof(hdr));

			// send packet
			if (sendto (sock, frame, 14 + sizeof(ArpHdr), 0, (struct sockaddr *) &addr, sizeof (addr)) <= 0)
				errExit("send");
			fflush(0);
			dest++;
		}

		if (FD_ISSET(sock, &rfds)) {
			// read the incoming packet
			int len = recvfrom(sock, frame, ETH_FRAME_LEN, 0, NULL, NULL);
			if (len < 0) {
				perror("recvfrom");
			}

			// parse the incoming packet
			if ((unsigned int) len < 14 + sizeof(ArpHdr))
				continue;

			// look only at ARP packets
			if (frame[12] != (ETH_P_ARP / 256) || frame[13] != (ETH_P_ARP % 256))
				continue;

			ArpHdr hdr;
			memcpy(&hdr, frame + 14, sizeof(ArpHdr));

			if (hdr.opcode == htons(2)) {
				// check my mac and my address
				if (memcmp(mac, hdr.target_mac, 6) != 0)
					continue;
				uint32_t ip;
				memcpy(&ip, hdr.target_ip, 4);
				if (ip != src)
					continue;
				memcpy(&ip, hdr.sender_ip, 4);
				ip = ntohl(ip);

				if (ip == last_ip) // filter duplicates
					continue;
				last_ip = ip;

				// printing
				if (header_printed == 0) {
					fmessage("   Network scan:\n");
					header_printed = 1;
				}
				fmessage("   %02x:%02x:%02x:%02x:%02x:%02x\t%d.%d.%d.%d\n",
					PRINT_MAC(hdr.sender_mac), PRINT_IP(ip));
			}
		}
	}

	close(sock);
}
