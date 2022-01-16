/*
 * Copyright (C) 2014-2022 Firejail Authors
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

typedef struct rnode_t {
	struct rnode_t *zero;
	struct rnode_t *one;
	char *name;
} RNode;

RNode *head = 0;
int radix_nodes = 0;

static inline RNode *addOne(RNode *ptr, char *name) {
	assert(ptr);
	if (ptr->one)
		return ptr->one;
	RNode *node = malloc(sizeof(RNode));
	if (!node)
		errExit("malloc");
	memset(node, 0, sizeof(RNode));
	if (name) {
		node->name = strdup(name);
		if (!node->name)
			errExit("strdup");
	}

	ptr->one = node;
	return node;
}

static inline RNode *addZero(RNode *ptr, char *name) {
	assert(ptr);
	if (ptr->zero)
		return ptr->zero;
	RNode *node = malloc(sizeof(RNode));
	if (!node)
		errExit("malloc");
	memset(node, 0, sizeof(RNode));
	if (name) {
		node->name = strdup(name);
		if (!node->name)
			errExit("strdup");
	}

	ptr->zero = node;
	return node;
}


// add to radix tree
char *radix_add(uint32_t ip, uint32_t mask, char *name) {
	assert(name);
	uint32_t m = 0x80000000;
	uint32_t lastm = 0;
	if (head == 0) {
		head = malloc(sizeof(RNode));
		memset(head, 0, sizeof(RNode));
	}
	RNode *ptr = head;
	radix_nodes++;

	int i;
	for (i = 0; i < 32; i++, m >>= 1) {
		if (!(m & mask))
			break;

		lastm |= m;
		int valid = (lastm == mask)? 1: 0;
		if (m & ip)
			ptr = addOne(ptr, (valid)? name: NULL);
		else
			ptr = addZero(ptr, (valid)? name: NULL);
	}
	assert(ptr);
	if (!ptr->name) {
		ptr->name = strdup(name);
		if (!ptr->name)
			errExit("strdup");
	}

	return ptr->name;
}

// find last match
char *radix_longest_prefix_match(uint32_t ip) {
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

