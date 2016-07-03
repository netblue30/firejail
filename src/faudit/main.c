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
#include "faudit.h"
char *prog;

int main(int argc, char **argv) {
	if (argc != 1) {
		int i;
		
		for (i = 1; i < argc; i++) {
			if (strcmp(argv[i], "syscall")) {
				syscall_helper(argc, argv);
				return 0;
			}
		}
		return 1;
	}

	printf("\n---------------- Firejail Audit: the GOOD, the BAD and the UGLY ----------------\n");

	// extract program name
	prog = realpath(argv[0], NULL);
	if (prog == NULL) {
		fprintf(stderr, "Error: cannot extract the path of the audit program\n");
		return 1;
	}
	printf("INFO: starting %s\n", prog);
	
	
	// check pid namespace
	pid_test();
	
	// check capabilities
	caps_test();

	// check seccomp
	seccomp_test();
	
	// check some well-known problematic files and directories
	files_test();
	
	// network
	network_test();
	
	free(prog);
	printf("--------------------------------------------------------------------------------\n");
	return 0;
}
