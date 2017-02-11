/*
 * Copyright (C) 2014-2017 Firejail Authors
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

#ifdef HAVE_GIT_INSTALL
 
#include "firejail.h"
#include <sys/utsname.h>
#include <sched.h>
#include <sys/mount.h>

// install a very simple mount namespace sandbox with a tmpfs on top of /tmp
// and drop privileges
static void sbox_ns(void) {
	if (unshare(CLONE_NEWNS) < 0)
		errExit("unshare");

	// mount events are not forwarded between the host the sandbox
	if (mount(NULL, "/", NULL, MS_SLAVE | MS_REC, NULL) < 0) {
		errExit("mount");
	}

	// mount a tmpfs on top of /tmp
	if (mount(NULL, "/tmp", "tmpfs", 0, NULL) < 0)
		errExit("mount");


	// drop privileges
	if (setgid(getgid()) < 0)
		errExit("setgid/getgid");
	if (setuid(getuid()) < 0)
		errExit("setuid/getuid");
	assert(getenv("LD_PRELOAD") == NULL);	

	printf("Running as "); fflush(0);
	int rv = system("whoami");
	(void) rv;
	printf("/tmp directory: "); fflush(0);
	rv = system("ls -l /tmp");
	(void) rv;
}
		

void git_install(void) {
	// redirect to "/usr/bin/firejail --noprofile --private-tmp /usr/lib/firejail/fgit-install.sh"
	EUID_ASSERT();
	EUID_ROOT();
	
	// install a mount namespace with a tmpfs on top of /tmp
	sbox_ns();
	
	// run command
	const char *cmd = LIBDIR "/firejail/fgit-install.sh";
	int rv = system(cmd);
	(void) rv;
	exit(0);
}

void git_uninstall(void) {
	// redirect to "/usr/bin/firejail --noprofile --private-tmp /usr/lib/firejail/fgit-install.sh"
	EUID_ASSERT();
	EUID_ROOT();
	
	// install a mount namespace with a tmpfs on top of /tmp
	sbox_ns();
	
	// run command
	const char *cmd = LIBDIR "/firejail/fgit-uninstall.sh";
	int rv = system(cmd);
	(void) rv;
	exit(0);
}
	
#endif // HAVE_GIT_INSTALL
