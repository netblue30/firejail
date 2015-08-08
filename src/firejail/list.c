/*
 * Copyright (C) 2014, 2015 netblue30 (netblue30@yahoo.com)
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
#include "firejail.h"

void top(void) {
	drop_privs(1);
	
	char *arg[4];
	arg[0] = "bash";
	arg[1] = "-c";
	arg[2] = "firemon --top";
	arg[3] = NULL;
	execvp("/bin/bash", arg); 
}

void netstats(void) {
	drop_privs(1);
	
	char *arg[4];
	arg[0] = "bash";
	arg[1] = "-c";
	arg[2] = "firemon --netstats";
	arg[3] = NULL;
	execvp("/bin/bash", arg); 
}

void list(void) {
	drop_privs(1);
	
	char *arg[4];
	arg[0] = "bash";
	arg[1] = "-c";
	arg[2] = "firemon --list";
	arg[3] = NULL;
	execvp("/bin/bash", arg); 
}

void tree(void) {
	drop_privs(1);
	
	char *arg[4];
	arg[0] = "bash";
	arg[1] = "-c";
	arg[2] = "firemon --tree";
	arg[3] = NULL;
	execvp("/bin/bash", arg); 
}

