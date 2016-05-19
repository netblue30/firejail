/*
 * Copyright (C) 2014-2016 Firejail Authors
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
#include <sys/types.h>
#include <sys/stat.h>

static void set_privileges(void) {
	struct stat s;
	if (stat("/proc/sys/kernel/grsecurity", &s) == 0) {
		EUID_ROOT();

		// elevate privileges
		if (setreuid(0, 0))
			errExit("setreuid");
		if (setregid(0, 0))
			errExit("setregid");
	}
	else
		drop_privs(1);
}

static char *get_firemon_path(const char *cmd) {
	assert(cmd);
	
	// start the argv[0] program in a new sandbox
	char *firemon;
	if (asprintf(&firemon, "%s/bin/firemon %s", PREFIX, cmd) == -1)
		errExit("asprintf");

	return firemon;
}

void top(void) {
	EUID_ASSERT();
	drop_privs(1);
	char *cmd = get_firemon_path("--top");

	char *arg[4];
	arg[0] = "bash";
	arg[1] = "-c";
	arg[2] = cmd;
	arg[3] = NULL;
	execvp("/bin/bash", arg); 
}

void netstats(void) {
	EUID_ASSERT();
	set_privileges();	
	char *cmd = get_firemon_path("--netstats");
	
	char *arg[4];
	arg[0] = "bash";
	arg[1] = "-c";
	arg[2] = cmd;
	arg[3] = NULL;
	execvp("/bin/bash", arg); 
}

void list(void) {
	EUID_ASSERT();
	drop_privs(1);
	char *cmd = get_firemon_path("--list");
	
	char *arg[4];
	arg[0] = "bash";
	arg[1] = "-c";
	arg[2] = cmd;
	arg[3] = NULL;
	execvp("/bin/bash", arg); 
}

void tree(void) {
	EUID_ASSERT();
	drop_privs(1);
	char *cmd = get_firemon_path("--tree");
	
	char *arg[4];
	arg[0] = "bash";
	arg[1] = "-c";
	arg[2] = cmd;
	arg[3] = NULL;
	execvp("/bin/bash", arg); 
}

