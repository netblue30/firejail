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
#include "fnettrace.h"
#include <termios.h>

static struct termios tlocal;	// startup terminal setting
static struct termios twait;	// no wait on key press
static int tset = 0;

void terminal_restore(void) {
	if (tset)
		tcsetattr(0, TCSANOW, &tlocal);
}

void terminal_handler(int s) {
	// Remove unused parameter warning
	(void)s;
	terminal_restore();
	_exit(0);
}

void terminal_set(void) {
	if (tset == 0) {
		tcgetattr(0, &twait);          // get current terminal attributes; 0 is the file descriptor for stdin
		memcpy(&tlocal, &twait, sizeof(tlocal));
		twait.c_lflag &= ~ICANON;      // disable canonical mode
		twait.c_lflag &= ~ECHO;	// no echo
		twait.c_cc[VMIN] = 1;          // wait until at least one keystroke available
		twait.c_cc[VTIME] = 0;         // no timeout
		tset = 1;
	}
	tcsetattr(0, TCSANOW, &twait);
}


