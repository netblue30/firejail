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
#include "faudit.h"

#define MAXBUF 4098
static int extract_seccomp(int *val) {
	FILE *fp = fopen("/proc/self/status", "r");
	if (!fp)
		return 1;

	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp)) {
		if (strncmp(buf, "Seccomp:\t", 9) == 0) {
			char *ptr = buf + 9;
			int tmp;
			sscanf(ptr, "%d", &tmp);
			*val = tmp;
			fclose(fp);
			return 0;
		}
	}

	fclose(fp);
	return 1;
}

void seccomp_test(void) {
	int seccomp_status;
	int rv = extract_seccomp(&seccomp_status);

	if (rv) {
		printf("INFO: cannot extract seccomp configuration on this platform.\n");
		return;
	}

	if (seccomp_status == 0) {
		printf("BAD: seccomp disabled. Use \"firejail --seccomp\" to enable it.\n");
	}
	else if (seccomp_status == 1)
		printf("GOOD: seccomp strict mode - only  read, write, _exit, and sigreturn are allowed.\n");
	else if (seccomp_status == 2) {
		printf("GOOD: seccomp BPF enabled.\n");

		printf("checking syscalls: "); fflush(0);
		printf("mount... "); fflush(0);
		syscall_run("mount");

		printf("umount2... "); fflush(0);
		syscall_run("umount2");

		printf("ptrace... "); fflush(0);
		syscall_run("ptrace");

		printf("swapon... "); fflush(0);
		syscall_run("swapon");

		printf("swapoff... "); fflush(0);
		syscall_run("swapoff");

		printf("init_module... "); fflush(0);
		syscall_run("init_module");

		printf("delete_module... "); fflush(0);
		syscall_run("delete_module");

		printf("chroot... "); fflush(0);
		syscall_run("chroot");

		printf("pivot_root... "); fflush(0);
		syscall_run("pivot_root");

#if defined(__i386__) || defined(__x86_64__)
		printf("iopl... "); fflush(0);
		syscall_run("iopl");

		printf("ioperm... "); fflush(0);
		syscall_run("ioperm");
#endif
		printf("\n");
	}
	else
		fprintf(stderr, "Error: unrecognized seccomp mode\n");

}
