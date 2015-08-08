/* code based on iproute2 ip/iplink.c, modified to be included in firejail project
 *
 * Original source code:
 * 
 * Information:
 *     http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2
 * 
 * Download:
 *     http://www.kernel.org/pub/linux/utils/net/iproute2/
 * 
 * Repository:
 *     git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git
 * 
 * License: GPL v2
 *
 * Original copyright header
 *
 * iplink.c		"ip link".
 *
 *		This program is free software; you can redistribute it and/or
 *		modify it under the terms of the GNU General Public License
 *		as published by the Free Software Foundation; either version
 *		2 of the License, or (at your option) any later version.
 *
 * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
 *
 */
 /*
 * Copyright (C) 2014, 2015 netblue30 (netblue30@yahoo.com)
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
#include "../include/libnetlink.h"
#include <linux/veth.h>

struct iplink_req
{
	struct nlmsghdr         n;
	struct ifinfomsg        i;
	char                    buf[1024];
};

static struct rtnl_handle rth = { .fd = -1 };

int net_create_veth(const char *dev, const char *nsdev, unsigned pid) {
	int len;
	struct iplink_req req;

	if (arg_debug)
		printf("create veth %s/%s/%u\n", dev, nsdev, pid);
	assert(dev);
	assert(nsdev);
	assert(pid);

	if (rtnl_open(&rth, 0) < 0) {
		fprintf(stderr, "cannot open netlink\n");
		exit(1);
	}

	memset(&req, 0, sizeof(req));

	req.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg));
	req.n.nlmsg_flags = NLM_F_REQUEST|NLM_F_CREATE|NLM_F_EXCL;
	req.n.nlmsg_type = RTM_NEWLINK;
	req.i.ifi_family = 0;

	if (dev) {
		len = strlen(dev) + 1;
		addattr_l(&req.n, sizeof(req), IFLA_IFNAME, dev, len);
	}

	struct rtattr *linkinfo = NLMSG_TAIL(&req.n);
	addattr_l(&req.n, sizeof(req), IFLA_LINKINFO, NULL, 0);
	addattr_l(&req.n, sizeof(req), IFLA_INFO_KIND, "veth", strlen("veth"));

	struct rtattr * data = NLMSG_TAIL(&req.n);
	addattr_l(&req.n, sizeof(req), IFLA_INFO_DATA, NULL, 0);

	struct rtattr * peerdata = NLMSG_TAIL(&req.n);
	addattr_l (&req.n, sizeof(req), VETH_INFO_PEER, NULL, 0);
	req.n.nlmsg_len += sizeof(struct ifinfomsg);

	// place the link in the child namespace
	addattr_l (&req.n, sizeof(req), IFLA_NET_NS_PID, &pid, 4);

	if (nsdev) {
		int len = strlen(nsdev) + 1;
		addattr_l(&req.n, sizeof(req), IFLA_IFNAME, nsdev, len);
	}
	peerdata->rta_len = (void *)NLMSG_TAIL(&req.n) - (void *)peerdata;

	data->rta_len = (void *)NLMSG_TAIL(&req.n) - (void *)data;
	linkinfo->rta_len = (void *)NLMSG_TAIL(&req.n) - (void *)linkinfo;

	// send message
	if (rtnl_talk(&rth, &req.n, 0, 0, NULL) < 0)
		exit(2);

	return 0;
}


int net_create_macvlan(const char *dev, const char *parent, unsigned pid) {
	int len;
	struct iplink_req req;
	if (arg_debug)
		printf("create macvlan %s, parent %s\n", dev, parent);
	assert(dev);
	assert(parent);

	if (rtnl_open(&rth, 0) < 0) {
		fprintf(stderr, "cannot open netlink\n");
		exit(1);
	}

	memset(&req, 0, sizeof(req));

	req.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg));
	req.n.nlmsg_flags = NLM_F_REQUEST|NLM_F_CREATE|NLM_F_EXCL;
	req.n.nlmsg_type = RTM_NEWLINK;
	req.i.ifi_family = 0;
	
	// we start with the parent
	int parent_ifindex = 2;
	addattr_l(&req.n, sizeof(req), IFLA_LINK, &parent_ifindex, 4);

	// add new interface name
	len = strlen(dev) + 1;
	addattr_l(&req.n, sizeof(req), IFLA_IFNAME, dev, len);
	
	// place the interface in child namespace
	addattr_l (&req.n, sizeof(req), IFLA_NET_NS_PID, &pid, 4);


	// add  link info for the new interface
	struct rtattr *linkinfo = NLMSG_TAIL(&req.n);
	addattr_l(&req.n, sizeof(req), IFLA_LINKINFO, NULL, 0);
	addattr_l(&req.n, sizeof(req), IFLA_INFO_KIND, "macvlan", strlen("macvlan"));

	// set macvlan bridge mode
	struct rtattr * data = NLMSG_TAIL(&req.n);
	addattr_l(&req.n, sizeof(req), IFLA_INFO_DATA, NULL, 0);
	int macvlan_type = MACVLAN_MODE_BRIDGE;
	addattr_l (&req.n, sizeof(req), IFLA_INFO_KIND, &macvlan_type, 4);

	data->rta_len = (void *)NLMSG_TAIL(&req.n) - (void *)data;
//	req.n.nlmsg_len += sizeof(struct ifinfomsg);


	data->rta_len = (void *)NLMSG_TAIL(&req.n) - (void *)data;
	linkinfo->rta_len = (void *)NLMSG_TAIL(&req.n) - (void *)linkinfo;

	// send message
	if (rtnl_talk(&rth, &req.n, 0, 0, NULL) < 0)
		exit(2);

	return 0;
}

/*
int main(int argc, char **argv) {
	printf("Hello\n");


	char *dev = argv[3];
	char *nsdev = argv[8];
	unsigned pid;
	sscanf(argv[10], "%u", &pid);


	net_create_veth(dev, nsdev, pid);

	return 0;
}
*/