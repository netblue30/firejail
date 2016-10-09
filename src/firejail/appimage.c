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
// http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=770fe30a46a12b6fb6b63fbe1737654d28e84844
// sudo mount -o loop krita-3.0-x86_64.appimage mnt

#include "firejail.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mount.h>
#include <fcntl.h>
#include <linux/loop.h>
#include <errno.h>

static char *devloop = NULL;	// device file 
static char *mntdir = NULL;	// mount point in /tmp directory

const char *appimage_getdir(void) {
	return mntdir;
}

void appimage_set(const char *appimage_path) {
	assert(appimage_path);
	assert(devloop == NULL);	// don't call this twice!
	EUID_ASSERT();

#ifdef LOOP_CTL_GET_FREE	// test for older kernels; this definition is found in /usr/include/linux/loop.h
	// check appimage_path
	if (access(appimage_path, R_OK) == -1) {
		fprintf(stderr, "Error: cannot access AppImage file\n");
		exit(1);
	}

	// open as user to prevent race condition
	int ffd = open(appimage_path, O_RDONLY|O_CLOEXEC);
	if (ffd == -1) {
		fprintf(stderr, "Error: /dev/loop-control interface is not supported by your kernel\n");
		exit(1);
	}

	// populate /run/firejail directory
	EUID_ROOT();
	fs_build_firejail_dir();
	EUID_USER();

	// find or allocate a free loop device to use
	EUID_ROOT();
	int cfd = open("/dev/loop-control", O_RDWR);
	int devnr = ioctl(cfd, LOOP_CTL_GET_FREE);
	if (devnr == -1) {
		fprintf(stderr, "Error: cannot allocate a new loopback device\n");
		exit(1);
	}
	close(cfd);
	if (asprintf(&devloop, "/dev/loop%d", devnr) == -1)
		errExit("asprintf");
		
	int lfd = open(devloop, O_RDONLY);
	if (ioctl(lfd, LOOP_SET_FD, ffd) == -1) {
		fprintf(stderr, "Error: cannot configure the loopback device\n");
		exit(1);
	}
	close(lfd);
	close(ffd);
	EUID_USER();

	// creates appimage mount point perms 0700
	if (asprintf(&mntdir, "%s/appimage-%u",  RUN_FIREJAIL_APPIMAGE_DIR, getpid()) == -1)
		errExit("asprintf");
	EUID_ROOT();
	if (mkdir(mntdir, 0700) == -1) {
		fprintf(stderr, "Error: cannot create appimage mount point\n");
		exit(1);
	}
	if (chmod(mntdir, 0700) == -1)
		errExit("chmod");
	if (chown(mntdir, getuid(), getgid()) == -1)
		errExit("chown");
	EUID_USER();
	ASSERT_PERMS(mntdir, getuid(), getgid(), 0700);
	
	// mount
	char *mode;
	if (asprintf(&mode, "mode=700,uid=%d,gid=%d", getuid(), getgid()) == -1)
		errExit("asprintf");
	EUID_ROOT();
	if (mount(devloop, mntdir, "iso9660",MS_MGC_VAL|MS_RDONLY,  mode) < 0)
		errExit("mounting appimage");
	if (arg_debug)
		printf("appimage mounted on %s\n", mntdir);
	EUID_USER();

	// set environment
	if (appimage_path && setenv("APPIMAGE", appimage_path, 1) < 0)
		errExit("setenv");
	if (mntdir && setenv("APPDIR", mntdir, 1) < 0)
		errExit("setenv");

	// build new command line
	if (asprintf(&cfg.command_line, "%s/AppRun", mntdir) == -1)
		errExit("asprintf");
	
	free(mode);
#else
	fprintf(stderr, "Error: /dev/loop-control interface is not supported by your kernel\n");
	exit(1);
#endif
}

void appimage_clear(void) {
	int rv;

	if (mntdir) {
		rv = umount2(mntdir, MNT_FORCE);
		if (rv == -1 && errno == EBUSY) {
			sleep(5);			
			rv = umount2(mntdir, MNT_FORCE);
			(void) rv;
			
		}
		rmdir(mntdir);
		free(mntdir);
	}

	if (devloop) {
		int lfd = open(devloop, O_RDONLY);
		rv = ioctl(lfd, LOOP_CLR_FD, 0);
		(void) rv;
		close(lfd);
	}
}
