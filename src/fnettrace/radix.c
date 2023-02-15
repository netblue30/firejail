/*
 * Copyright (C) 2014-2023 Firejail Authors
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

// get rid of the malloc overhead
#define RNODE_MAX_MALLOC 128
static RNode *rnode_unused = NULL;
static int rnode_malloc_cnt = 0;
static RNode *rmalloc(void) {
	if (rnode_unused == NULL || rnode_malloc_cnt >= RNODE_MAX_MALLOC) {
		rnode_unused = malloc(sizeof(RNode) * RNODE_MAX_MALLOC);
		if (!rnode_unused)
			errExit("malloc");
		memset(rnode_unused, 0, sizeof(RNode) * RNODE_MAX_MALLOC);
		rnode_malloc_cnt = 0;
	}

	rnode_malloc_cnt++;
	return rnode_unused + rnode_malloc_cnt - 1;
}


static inline char *duplicate_name(const char *name) {
	assert(name);

	if (strcmp(name, "United States") == 0)
		return "United States";
	else if (strcmp(name, "Amazon") == 0)
		return "Amazon";
	return strdup(name);
}

static inline RNode *addOne(RNode *ptr, char *name) {
	assert(ptr);
	if (ptr->one)
		return ptr->one;
	RNode *node = rmalloc();
	assert(node);
	if (name) {
		node->name = duplicate_name(name);
		if (!node->name)
			errExit("duplicate name");
	}

	ptr->one = node;
	return node;
}

static inline RNode *addZero(RNode *ptr, char *name) {
	assert(ptr);
	if (ptr->zero)
		return ptr->zero;
	RNode *node = rmalloc();
	assert(node);
	if (name) {
		node->name = duplicate_name(name);
		if (!node->name)
			errExit("duplicate name");
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
		ptr->name = duplicate_name(name);
		if (!ptr->name)
			errExit("duplicate_name");
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

