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
#include "firejail.h"
#include "../include/gcov_wrapper.h"
#include <sys/time.h>
#include <sys/resource.h>

void set_rlimits(void) {
	EUID_ASSERT();
	// resource limits
	struct rlimit rl;
	if (arg_rlimit_cpu) {
		if (getrlimit(RLIMIT_CPU, &rl) == -1)
			errExit("getrlimit");
		if (cfg.rlimit_cpu > rl.rlim_max && getuid() != 0)
			cfg.rlimit_cpu = rl.rlim_max;
		// set the new limit
		rl.rlim_cur = (rlim_t) cfg.rlimit_cpu;
		rl.rlim_max = (rlim_t) cfg.rlimit_cpu;

		__gcov_dump();

		if (setrlimit(RLIMIT_CPU, &rl) == -1)
			errExit("setrlimit");
		if (arg_debug)
			printf("Config rlimit: max cpu time %llu\n", cfg.rlimit_cpu);
	}

	if (arg_rlimit_nofile) {
		if (getrlimit(RLIMIT_NOFILE, &rl) == -1)
			errExit("getrlimit");
		if (cfg.rlimit_nofile > rl.rlim_max && getuid() != 0)
			cfg.rlimit_nofile = rl.rlim_max;
		// set the new limit
		rl.rlim_cur = (rlim_t) cfg.rlimit_nofile;
		rl.rlim_max = (rlim_t) cfg.rlimit_nofile;

		// gcov-instrumented programs might crash at this point
		__gcov_dump();

		if (setrlimit(RLIMIT_NOFILE, &rl) == -1)
			errExit("setrlimit");
		if (arg_debug)
			printf("Config rlimit: number of open file descriptors %llu\n", cfg.rlimit_nofile);
	}

	if (arg_rlimit_nproc) {
		if (getrlimit(RLIMIT_NPROC, &rl) == -1)
			errExit("getrlimit");
		if (cfg.rlimit_nproc > rl.rlim_max && getuid() != 0)
			cfg.rlimit_nproc = rl.rlim_max;
		// set the new limit
		rl.rlim_cur = (rlim_t) cfg.rlimit_nproc;
		rl.rlim_max = (rlim_t) cfg.rlimit_nproc;

		__gcov_dump();

		if (setrlimit(RLIMIT_NPROC, &rl) == -1)
			errExit("setrlimit");
		if (arg_debug)
			printf("Config rlimit: number of processes %llu\n", cfg.rlimit_nproc);
	}

	if (arg_rlimit_fsize) {
		if (getrlimit(RLIMIT_FSIZE, &rl) == -1)
			errExit("getrlimit");
		if (cfg.rlimit_fsize > rl.rlim_max && getuid() != 0)
			cfg.rlimit_fsize = rl.rlim_max;
		// set the new limit
		rl.rlim_cur = (rlim_t) cfg.rlimit_fsize;
		rl.rlim_max = (rlim_t) cfg.rlimit_fsize;

		__gcov_dump();

		if (setrlimit(RLIMIT_FSIZE, &rl) == -1)
			errExit("setrlimit");
		if (arg_debug)
			printf("Config rlimit: maximum file size %llu\n", cfg.rlimit_fsize);
	}

	if (arg_rlimit_sigpending) {
		if (getrlimit(RLIMIT_SIGPENDING, &rl) == -1)
			errExit("getrlimit");
		if (cfg.rlimit_sigpending > rl.rlim_max && getuid() != 0)
			cfg.rlimit_sigpending = rl.rlim_max;
		// set the new limit
		rl.rlim_cur = (rlim_t) cfg.rlimit_sigpending;
		rl.rlim_max = (rlim_t) cfg.rlimit_sigpending;

		__gcov_dump();

		if (setrlimit(RLIMIT_SIGPENDING, &rl) == -1)
			errExit("setrlimit");
		if (arg_debug)
			printf("Config rlimit: maximum number of signals pending %llu\n", cfg.rlimit_sigpending);
	}

	if (arg_rlimit_as) {
		if (getrlimit(RLIMIT_AS, &rl) == -1)
			errExit("getrlimit");
		if (cfg.rlimit_as > rl.rlim_max && getuid() != 0)
			cfg.rlimit_as = rl.rlim_max;
		// set the new limit
		rl.rlim_cur = (rlim_t) cfg.rlimit_as;
		rl.rlim_max = (rlim_t) cfg.rlimit_as;

		__gcov_dump();

		if (setrlimit(RLIMIT_AS, &rl) == -1)
			errExit("setrlimit");
		if (arg_debug)
			printf("Config rlimit: maximum virtual memory %llu\n", cfg.rlimit_as);
	}
}
