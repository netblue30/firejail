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
#include <limits.h>
char *prog;

int main(int argc, char **argv) {
	printf("\n-------- Firejail Audit: the Good, the Bad and the Ugly --------\n");

	// extract program name
	prog = realpath(argv[0], NULL);
	if (prog == NULL) {
		fprintf(stderr, "Error: cannot extract the path of the audit program\n");
		return 1;
	}
	printf("Running %s\n", prog);
	
	
	// check pid namespace
	pid_test();
	
	// check capabilities
	caps_test();

	// check seccomp
	seccomp_test();
	
	free(prog);
	printf("----------------------------------------------------------------\n");
	return 0;
}
