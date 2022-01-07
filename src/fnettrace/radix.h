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
#ifndef RADIX_H
#define RADIX_H

typedef struct rnode_t {
	struct rnode_t *zero;
	struct rnode_t *one;
	uint32_t ip;
	uint32_t mask;
	char *name;
} RNode;

char *radix_find_first(uint32_t ip);
char *radix_find_last(uint32_t ip);
void radix_add(uint32_t ip, uint32_t mask, char *name);
void radix_print(void);
void radix_build_list(void);

#endif