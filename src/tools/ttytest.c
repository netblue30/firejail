// This file is part of Firejail project
// Copyright (C) 2014-2020 Firejail Authors
// License GPL v2
#define _XOPEN_SOURCE 600
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>

int main(void) {
	int fdm;
	int rc;

	// initial
	system("ls -l /dev/pts");

	fdm = posix_openpt(O_RDWR);
	if (fdm < 0) {
		perror("posix_openpt");
		return 1;
	}

	rc = grantpt(fdm);
	if (rc != 0) {
		perror("grantpt");
		return 1;
	}

	rc = unlockpt(fdm);
	if (rc != 0) {
		perror("unlockpt");
		return 1;
	}

	// final
	system("ls -l /dev/pts");

	return 0;
}
