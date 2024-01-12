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
#ifndef FNETLOCK_H
#define FNETLOCK_H

#include "../include/common.h"
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <time.h>
#include <stdarg.h>
#include <fcntl.h>
#include <sys/mman.h>


//#define DEBUG 1

#define NETLOCK_INTERVAL 60	// seconds

static inline uint8_t hash(uint32_t ip) {
	uint8_t *ptr = (uint8_t *) &ip;
	// simple byte xor
	return *ptr ^ *(ptr + 1) ^ *(ptr + 2) ^ *(ptr + 3);
}

// main.c
void logprintf(char* fmt, ...);

// tail.c
void tail(const char *logfile);

#endif
