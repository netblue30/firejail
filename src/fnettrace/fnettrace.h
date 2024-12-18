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
#ifndef FNETTRACE_H
#define FNETTRACE_H

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
#define DISPLAY_INTERVAL 2	// seconds
#define DISPLAY_TTL 4		// display intervals (4 * 2 seconds)
#define DISPLAY_BW_UNITS 20	// length of the bandwidth bar


static inline void ansi_topleft(void) {
	char str[] = {0x1b, '[', '1', ';',  '1', 'H', '\0'};
	printf("%s", str);
	fflush(0);
}

static inline void ansi_clrscr(void) {
	ansi_topleft();
	char str[] = {0x1b, '[', '0', 'J', '\0'};
	printf("%s", str);
	fflush(0);
}

static inline void ansi_bold(const char *str) {
	char str1[] = {0x1b, '[', '1', 'm', '\0'};
	char str2[] = {0x1b, '[', '0', 'm', '\0'};
	printf("%s%s%s", str1, str, str2);
	fflush(0);
}

static inline void ansi_faint(const char *str) {
	char str1[] = {0x1b, '[', '2', 'm', '\0'};
	char str2[] = {0x1b, '[', '0', 'm', '\0'};
	printf("%s%s%s", str1, str, str2);
	fflush(0);
}

static inline void ansi_red(const char *str) {
	char str1[] = {0x1b, '[', '9', '1', 'm', '\0'};
	char str2[] = {0x1b, '[', '0', 'm', '\0'};
	printf("%s%s%s", str1, str, str2);
	fflush(0);
}

static inline uint8_t hash(uint32_t ip) {
	uint8_t *ptr = (uint8_t *) &ip;
	// simple byte xor
	return *ptr ^ *(ptr + 1) ^ *(ptr + 2) ^ *(ptr + 3);
}

// main.c
void logprintf(char* fmt, ...);

// hostnames.c
extern int geoip_calls;
void load_hostnames(const char *fname);
char* retrieve_hostname(uint32_t ip);

// tail.c
void tail(const char *logfile);

// terminal.c
void terminal_handler(int s);
void terminal_set(void);
void terminal_restore(void);

// runprog.c
int runprog(const char *program);

// event.c
extern int ev_cnt;
void ev_clear(void);
void ev_add(char *record);
void ev_print(FILE *fp);


#endif
