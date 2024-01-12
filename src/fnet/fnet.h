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
#ifndef FNET_H
#define FNET_H

#include "../include/common.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdarg.h>

// main.c
extern int arg_quiet;
extern void fmessage(char* fmt, ...); // TODO: this function is duplicated in src/firejail/util.c

// veth.c
int net_create_veth(const char *dev, const char *nsdev, unsigned pid);
int net_create_macvlan(const char *dev, const char *parent, unsigned pid);
int net_create_ipvlan(const char *dev, const char *parent, unsigned pid);
int net_move_interface(const char *dev, unsigned pid);

// interface.c
void net_bridge_add_interface(const char *bridge, const char *dev);
void net_if_up(const char *ifname);
int net_get_mtu(const char *ifname);
void net_set_mtu(const char *ifname, int mtu);
void net_ifprint(int scan);
int net_get_mac(const char *ifname, unsigned char mac[6]);
void net_if_ip(const char *ifname, uint32_t ip, uint32_t mask, int mtu);
int net_if_mac(const char *ifname, const unsigned char mac[6]);
void net_if_ip6(const char *ifname, const char *addr6);
void net_if_waitll(const char *ifname);


// arp.c
void arp_scan(const char *dev, uint32_t ifip, uint32_t ifmask);

#endif
