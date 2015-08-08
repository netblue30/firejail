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
#include <sys/time.h>
#include <sys/resource.h>

void set_rlimits(void) {
	// resource limits
	struct rlimit rl;
	if (arg_rlimit_nofile) {
		rl.rlim_cur = (rlim_t) cfg.rlimit_nofile;
		rl.rlim_max = (rlim_t) cfg.rlimit_nofile;
		if (setrlimit(RLIMIT_NOFILE, &rl) == -1)
			errExit("setrlimit");
		if (arg_debug)
			printf("Config rlimit: number of open file descriptors %u\n", cfg.rlimit_nofile);
	}

	if (arg_rlimit_nproc) {
		rl.rlim_cur = (rlim_t) cfg.rlimit_nproc;
		rl.rlim_max = (rlim_t) cfg.rlimit_nproc;
		if (setrlimit(RLIMIT_NPROC, &rl) == -1)
			errExit("setrlimit");
		if (arg_debug)
			printf("Config rlimit: number of processes %u\n", cfg.rlimit_nproc);
	}
	
	if (arg_rlimit_fsize) {
		rl.rlim_cur = (rlim_t) cfg.rlimit_fsize;
		rl.rlim_max = (rlim_t) cfg.rlimit_fsize;
		if (setrlimit(RLIMIT_FSIZE, &rl) == -1)
			errExit("setrlimit");
		if (arg_debug)
			printf("Config rlimit: maximum file size %u\n", cfg.rlimit_fsize);
	}
	
	if (arg_rlimit_sigpending) {
		rl.rlim_cur = (rlim_t) cfg.rlimit_sigpending;
		rl.rlim_max = (rlim_t) cfg.rlimit_sigpending;
		if (setrlimit(RLIMIT_SIGPENDING, &rl) == -1)
			errExit("setrlimit");
		if (arg_debug)
			printf("Config rlimit: maximum number of signals pending %u\n", cfg.rlimit_sigpending);
	}
}
