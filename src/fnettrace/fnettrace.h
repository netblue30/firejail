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