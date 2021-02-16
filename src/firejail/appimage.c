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
// https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=770fe30a46a12b6fb6b63fbe1737654d28e84844
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

#ifdef LOOP_CTL_GET_FREE	// test for older kernels; this definition is found in /usr/include/linux/loop.h
static void err_loop(void) {
	fprintf(stderr, "Error: cannot configure loopback device\n");
	exit(1);
}
#endif

void appimage_set(const char *appimage) {
	assert(appimage);
	assert(devloop == NULL);	// don't call this twice!
	EUID_ASSERT();

#ifdef LOOP_CTL_GET_FREE
	// check appimage file
	invalid_filename(appimage, 0); // no globbing
	if (access(appimage, R_OK) == -1) {
		fprintf(stderr, "Error: cannot access AppImage file\n");
		exit(1);
	}

	// get appimage type and ELF size
	// a value of 0 means we are dealing with a type1 appimage
	long unsigned int size = appimage2_size(appimage);
	if (arg_debug)
		printf("AppImage ELF size %lu\n", size);

	// open appimage file
	/* coverity[toctou] */
	int ffd = open(appimage, O_RDONLY|O_CLOEXEC);
	if (ffd == -1) {
		fprintf(stderr, "Error: cannot open AppImage file\n");
		exit(1);
	}

	// find or allocate a free loop device to use
	EUID_ROOT();
	int cfd = open("/dev/loop-control", O_RDWR);
	if (cfd == -1)
		err_loop();
	int devnr = ioctl(cfd, LOOP_CTL_GET_FREE);
	if (devnr == -1)
		err_loop();
	close(cfd);
	if (asprintf(&devloop, "/dev/loop%d", devnr) == -1)
		errExit("asprintf");

	int lfd = open(devloop, O_RDONLY);
	if (lfd == -1)
		err_loop();
	if (ioctl(lfd, LOOP_SET_FD, ffd) == -1)
		err_loop();

	if (size) {
		struct loop_info64 info;
		memset(&info, 0, sizeof(struct loop_info64));
		info.lo_offset = size;
		if (ioctl(lfd,  LOOP_SET_STATUS64, &info) == -1)
			err_loop();
	}

	close(lfd);
	close(ffd);
	EUID_USER();

	// creates appimage mount point perms 0700
	if (asprintf(&mntdir, "%s/.appimage-%u",  RUN_FIREJAIL_APPIMAGE_DIR, getpid()) == -1)
		errExit("asprintf");
	EUID_ROOT();
	mkdir_attr(mntdir, 0700, getuid(), getgid());
	EUID_USER();

	// mount
	char *mode;
	if (asprintf(&mode, "mode=700,uid=%d,gid=%d", getuid(), getgid()) == -1)
		errExit("asprintf");
	unsigned long flags = MS_MGC_VAL|MS_RDONLY;
	if (getuid())
		flags |= MS_NODEV|MS_NOSUID;

	EUID_ROOT();
	if (size == 0) {
		fmessage("Mounting appimage type 1\n");
		if (mount(devloop, mntdir, "iso9660", flags, mode) < 0)
			errExit("mounting appimage");
	}
	else {
		fmessage("Mounting appimage type 2\n");
		if (mount(devloop, mntdir, "squashfs", flags, NULL) < 0)
			errExit("mounting appimage");
	}

	if (arg_debug)
		printf("appimage mounted on %s\n", mntdir);
	EUID_USER();

	char* abspath = realpath(appimage, NULL);
	if (abspath == NULL)
		errExit("Failed to obtain absolute path");

	// set environment
	env_store_name_val("APPIMAGE", abspath, SETENV);

	if (mntdir)
		env_store_name_val("APPDIR", mntdir, SETENV);

	if (size != 0)
		env_store_name_val("ARGV0", appimage, SETENV);

	if (cfg.cwd)
		env_store_name_val("OWD", cfg.cwd, SETENV);

	// build new command line
	if (asprintf(&cfg.command_line, "%s/AppRun", mntdir) == -1)
		errExit("asprintf");

	free(abspath);
	free(mode);
#ifdef HAVE_GCOV
	__gcov_flush();
#endif
#else
	fprintf(stderr, "Error: /dev/loop-control interface is not supported by your kernel\n");
	exit(1);
#endif
}

void appimage_clear(void) {
	int rv;

	EUID_ROOT();
	if (mntdir) {
		int i;
		int rv = 0;
		for (i = 0; i < 5; i++) {
			rv = umount2(mntdir, MNT_FORCE);
			if (rv == 0) {
				fmessage("AppImage unmounted\n");

				break;
			}
			if (rv == -1 && errno == EBUSY) {
				fwarning("EBUSY error trying to unmount %s\n", mntdir);
				sleep(2);
				continue;
			}

			// rv = -1
			if (!arg_quiet) {
				fwarning("error trying to unmount %s\n", mntdir);
				perror("umount");
			}
		}

		if (rv == 0) {
			rmdir(mntdir);
			free(mntdir);
		}
	}

	if (devloop) {
		int lfd = open(devloop, O_RDONLY);
		if (lfd != -1) {
			rv = ioctl(lfd, LOOP_CLR_FD, 0);
			(void) rv;
			close(lfd);
		}
	}
}
