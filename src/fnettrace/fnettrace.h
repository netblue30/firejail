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
#ifndef FNETTRACE_H
#define FNETTRACE_H

#include "../include/common.h"
#include <unistd.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <time.h>
#include <stdarg.h>

//#define NETLOCK_INTERVAL 60
#define NETLOCK_INTERVAL 60
#define DISPLAY_INTERVAL 3

void logprintf(char* fmt, ...);

static inline void ansi_topleft(int tolog) {
	char str[] = {0x1b, '[', '1', ';',  '1', 'H', '\0'};
	if (tolog)
		logprintf("%s", str);
	else
		printf("%s", str);
	fflush(0);
}

static inline void ansi_clrscr(int tolog) {
	ansi_topleft(tolog);
	char str[] = {0x1b, '[', '0', 'J', '\0'};
	if (tolog)
		logprintf("%s", str);
	else
		printf("%s", str);
	fflush(0);
}

static inline void ansi_linestart(int tolog) {
	char str[] = {0x1b, '[', '0', 'G', '\0'};
	if (tolog)
		logprintf("%s", str);
	else
		printf("%s", str);
	fflush(0);
}

static inline void ansi_clrline(int tolog) {
	ansi_linestart(tolog);
	char str[] = {0x1b, '[', '0', 'K', '\0'};
	if (tolog)
		logprintf("%s", str);
	else
		printf("%s", str);
	fflush(0);
}

static inline uint8_t hash(uint32_t ip) {
	uint8_t *ptr = (uint8_t *) &ip;
	// simple byte xor
	return *ptr ^ *(ptr + 1) ^ *(ptr + 2) ^ *(ptr + 3);
}



#endif