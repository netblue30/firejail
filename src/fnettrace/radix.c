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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>
#include "radix.h"
#include "fnettrace.h"

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

	if (strcmp(name, "Amazon") == 0)
		return "Amazon";
	else if (strcmp(name, "Digital Ocean") == 0)
		return "Digital Ocean";
	else if (strcmp(name, "Linode") == 0)
		return "Linode";
	else if (strcmp(name, "Google") == 0)
		return "Google";
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
RNode *radix_add(uint32_t ip, uint32_t mask, char *name) {
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
	if (name && !ptr->name) {
		ptr->name = duplicate_name(name);
		if (!ptr->name)
			errExit("duplicate_name");
	}

	return ptr;
}

// find last match
RNode *radix_longest_prefix_match(uint32_t ip) {
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

	return rv;
}

static uint32_t sum;
static void print(FILE *fp, RNode *ptr, int level, int pkts) {
	assert(fp);
	if (!ptr)
		return;
	if (ptr->name) {
		if (pkts) {
			if (ptr->pkts) {
				fprintf(fp, "   %d.%d.%d.%d/%d ", PRINT_IP(sum << (32 - level)), level);
				fprintf(fp, "%s", ptr->name);
				fprintf(fp, " (%u)\n", ptr->pkts);
			}
		}
		else {
			fprintf(fp, "%d.%d.%d.%d/%d ", PRINT_IP(sum << (32 - level)), level);
			fprintf(fp, "%s", ptr->name);
			fprintf(fp, "\n");
		}
	}

	if (ptr->zero == NULL && ptr->one == NULL)
		return;

	level++;
	sum <<= 1;
	print(fp, ptr->zero, level, pkts);
	sum++;
	print(fp, ptr->one, level, pkts);
	sum--;
	sum >>= 1;
}

void radix_print(FILE *fp, int pkts) {
	if (!head)
		return;
	sum = 0;
	print(fp, head->zero, 1, pkts);
	assert(sum == 0);
	sum = 1;
	print(fp, head->one, 1, pkts);
	assert(sum == 1);
}

static inline int strnullcmp(const char *a, const char *b) {
	if (!a || !b)
		return -1;
	return strcmp(a, b);
}

void squash(RNode *ptr, int level) {
	if (!ptr)
		return;

	if (ptr->name == NULL &&
	    ptr->zero && ptr->one &&
	    strnullcmp(ptr->zero->name, ptr->one->name) == 0 &&
	    !ptr->zero->zero && !ptr->zero->one &&
	    !ptr->one->zero && !ptr->one->one) {
	    	ptr->name = ptr->one->name;
//		fprintf(stderr, "squashing %d.%d.%d.%d/%d ", PRINT_IP(sum << (32 - level)), level);
//		fprintf(stderr, "%s\n", ptr->name);
		ptr->zero = NULL;
		ptr->one = NULL;
		radix_nodes--;
		return;
	}

	if (ptr->zero == NULL && ptr->one == NULL)
		return;

	level++;
	sum <<= 1;
	squash(ptr->zero, level);
	sum++;
	squash(ptr->one, level);
	sum--;
	sum >>= 1;
}

// using stderr for printing
void radix_squash(void) {
	if (!head)
		return;

	sum = 0;
	squash(head->zero, 1);
	assert(sum == 0);
	sum = 1;
	squash(head->one, 1);
	assert(sum == 1);

}

static void clear_data(RNode *ptr) {
	if (!ptr)
		return;
	ptr->pkts = 0;
	clear_data(ptr->zero);
	clear_data(ptr->one);
}

void radix_clear_data(void) {
	if (!head)
		return;
	clear_data(head->zero);
	clear_data(head->one);
}
