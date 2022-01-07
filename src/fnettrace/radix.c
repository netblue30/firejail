/*
 * Copyright (C) 2014-2021 Firejail Authors
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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>
#include "radix.h"
#include "fnettrace.h"

RNode *head = 0;

static inline RNode *addOne(RNode *ptr, uint32_t ip, uint32_t mask, char *name) {
	assert(ptr);
	if (ptr->one)
		return ptr->one;
	RNode *node = malloc(sizeof(RNode));
	if (!node)
		errExit("malloc");
	memset(node, 0, sizeof(RNode));
	node->ip = ip;
	node->mask = mask;
	if (name) {
		node->name = strdup(name);
		if (!node->name)
			errExit("strdup");
	}
	
	ptr->one = node;
	return node;
}

static inline RNode *addZero(RNode *ptr, uint32_t ip, uint32_t mask, char *name) {
	assert(ptr);
	if (ptr->zero)
		return ptr->zero;
	RNode *node = malloc(sizeof(RNode));
	if (!node)
		errExit("malloc");
	memset(node, 0, sizeof(RNode));
	node->ip = ip;
	node->mask = mask;
	if (name) {
		node->name = strdup(name);
		if (!node->name)
			errExit("strdup");
	}
	
	ptr->zero = node;
	return node;
}


// add to radix tree
void radix_add(uint32_t ip, uint32_t mask, char *name) {
	assert(name);
	char *tmp =  strdup(name);
	if (!tmp)
		errExit("strdup");
	name = tmp;

	uint32_t m = 0x80000000;
	uint32_t lastm = 0;
	if (head == 0) {
		head = malloc(sizeof(RNode));
		memset(head, 0, sizeof(RNode));
	}
	RNode *ptr = head;

	int i;
	for (i = 0; i < 32; i++, m >>= 1) {
		if (!(m & mask))
			break;

		lastm |= m;
		int valid = (lastm == mask)? 1: 0;
		if (m & ip)
			ptr = addOne(ptr, ip & lastm, mask & lastm, (valid)? name: NULL);
		else
			ptr = addZero(ptr, ip & lastm, mask & lastm, (valid)? name: NULL);
	}
	assert(ptr);
	if (!ptr->name) {
		ptr->name = strdup(name);
		if (!ptr->name)
			errExit("strdup");
	}
}

// find first match
char *radix_find_first(uint32_t ip) {
	if (!head)
		return NULL;

	uint32_t m = 0x80000000;
	RNode *ptr = head;

	int i;
	for (i = 0; i < 32; i++, m >>= 1) {
		if (m & ip)
			ptr = ptr->one;
		else
			ptr = ptr->zero;
		if (!ptr)
			return NULL;
		if (ptr->name)
			return ptr->name;
	}
	return NULL;
}

// find last match
char *radix_find_last(uint32_t ip) {
	if (!head)
		return NULL;

	uint32_t m = 0x80000000;
	RNode *ptr = head;
	RNode *rv = NULL;

	int i;
	for (i = 0; i < 32; i++, m >>= 1) {
		if (m & ip)
			ptr = ptr->one;
		else
			ptr = ptr->zero;
		if (!ptr)
			break;
		if (ptr->name)
			rv = ptr;
	}
	
	return (rv)? rv->name: NULL;
}

static void radix_print_node(RNode *ptr, int level) {
	assert(ptr);
	
	int i;
	for (i = 0; i < level; i++)
		printf(" ");
	printf("%08x %08x", ptr->ip, ptr->mask);
	if (ptr->name)
		printf(" (%s)\n", ptr->name);
	else
		printf(" (NULL)\n");

	if (ptr->zero)
		radix_print_node(ptr->zero, level + 1);
	if (ptr->one)
		radix_print_node(ptr->one, level + 1);
}

void radix_print(void) {
	if (!head) {
		printf("radix tree is empty\n");
		return;
	}
	
	printf("radix IPv4 tree\n");
	radix_print_node(head, 0);
}


static inline int mask2cidr(uint32_t mask) {
	uint32_t m = 0x80000000;
	int i;
	int cnt = 0;
	for (i = 0; i < 32; i++, m = m >> 1) {
		if (mask & m)
			cnt++;
	}
	
	return cnt;
}

static void radix_build_list_node(RNode *ptr) {
	assert(ptr);
	
	
	if (ptr->name) {
		printf("%d.%d.%d.%d/%d %s\n", PRINT_IP(ptr->ip), mask2cidr(ptr->mask), ptr->name);
		return;
	}
	else {
		if (ptr->zero)
			radix_build_list_node(ptr->zero);
		if (ptr->one)
			radix_build_list_node(ptr->one);
	}
}

void radix_build_list(void) {
	if (!head) {
		printf("radix tree is empty\n");
		return;
	}

	radix_build_list_node(head);	
}

