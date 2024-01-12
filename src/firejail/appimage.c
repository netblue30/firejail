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
// https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=770fe30a46a12b6fb6b63fbe1737654d28e84844
// sudo mount -o loop krita-3.0-x86_64.appimage mnt

#include "firejail.h"
#include "../include/gcov_wrapper.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mount.h>
#include <fcntl.h>
#include <linux/loop.h>
#include <errno.h>

static char *devloop = NULL;	// device file
static long unsigned size = 0;	// offset into appimage file
#define MAXBUF 4096

static void err_loop(char *msg) {
	fprintf(stderr, "%s\n", msg);
	exit(1);
}

// return 1 if found
int appimage_find_profile(const char *archive) {
	assert(archive);
	assert(strlen(archive));

	// extract the name of the appimage from a full path
	// example: archive = /opt/kdenlive-20.12.2-x86_64.appimage
	const char *arc = strrchr(archive, '/');
	if (arc)
		arc++;
	else
		arc = archive;
	if (arg_debug)
		printf("Looking for a %s profile\n", arc);

	// try to match the name of the archive with the list of programs in /etc/firejail/firecfg.config
	FILE *fp = fopen(SYSCONFDIR "/firecfg.config", "r");
	if (!fp) {
		fprintf(stderr, "Error: cannot find %s, firejail is not correctly installed\n", SYSCONFDIR "/firecfg.config");
		exit(1);
	}
	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp)) {
		if (*buf == '#')
			continue;
		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';
		char *found = strcasestr(arc, buf);
		if (found == arc) {
			fclose(fp);
			return profile_find_firejail(buf, 1);
		}
	}

	fclose(fp);
	return 0;

}


void appimage_set(const char *appimage) {
	assert(appimage);
	assert(devloop == NULL);	// don't call this twice!
	EUID_ASSERT();

	// open appimage file
	invalid_filename(appimage, 0); // no globbing
	int ffd = open(appimage, O_RDONLY|O_CLOEXEC);
	if (ffd == -1) {
		fprintf(stderr, "Error: cannot read AppImage file\n");
		exit(1);
	}
	struct stat s;
	if (fstat(ffd, &s) == -1)
		errExit("fstat");
	if (!S_ISREG(s.st_mode)) {
		fprintf(stderr, "Error: invalid AppImage file\n");
		exit(1);
	}

	// get appimage type and ELF size
	// a value of 0 means we are dealing with a type1 appimage
	size = appimage2_size(ffd);
	if (arg_debug)
		printf("AppImage ELF size %lu\n", size);

	// find or allocate a free loop device to use
	EUID_ROOT();
	int cfd; // loop control fd
	if ((cfd = open("/dev/loop-control", O_RDWR|O_CLOEXEC)) == -1) {
		sleep(1); // sleep 1 second and try again
		if ((cfd = open("/dev/loop-control", O_RDWR|O_CLOEXEC)) == -1)
			err_loop("cannot open /dev/loop-control");
	}

	int devnr; // loop device number
	if ((devnr = ioctl(cfd, LOOP_CTL_GET_FREE)) == -1) {
		sleep(1); // sleep 1 second and try again
		if ((devnr = ioctl(cfd, LOOP_CTL_GET_FREE)) == -1)
			err_loop("cannot get a free loop device number");
	}
	close(cfd);
	if (asprintf(&devloop, "/dev/loop%d", devnr) == -1)
		errExit("asprintf");

	int lfd; // loopback fd
	if ((lfd = open(devloop, O_RDONLY|O_CLOEXEC)) == -1) {
		sleep (1); // sleep 1 second and try again
		if ((lfd = open(devloop, O_RDONLY|O_CLOEXEC)) == -1)
			err_loop("cannot open loop device");
	}

	// associate loop device with appimage
	if (ioctl(lfd, LOOP_SET_FD, ffd) == -1) {
		sleep(1); // sleep 1 second and try again
		if (ioctl(lfd, LOOP_SET_FD, ffd) == -1)
			err_loop("cannot associate loop device with appimage file");
	}

	if (size) {
		struct loop_info64 info;
		memset(&info, 0, sizeof(struct loop_info64));
		info.lo_offset = size;
		if (ioctl(lfd,  LOOP_SET_STATUS64, &info) == -1) {
			sleep(1); // sleep 1 second and try again
			if (ioctl(lfd,  LOOP_SET_STATUS64, &info) == -1)
				err_loop("cannot set loop status");
		}
	}
	close(lfd);
	close(ffd);
	EUID_USER();

	// set environment
	char* abspath = realpath(appimage, NULL);
	if (abspath == NULL)
		errExit("Failed to obtain absolute path");
	env_store_name_val("APPIMAGE", abspath, SETENV);
	free(abspath);

	env_store_name_val("APPDIR", RUN_FIREJAIL_APPIMAGE_DIR, SETENV);

	if (size != 0)
		env_store_name_val("ARGV0", appimage, SETENV);

	if (cfg.cwd)
		env_store_name_val("OWD", cfg.cwd, SETENV);

	__gcov_flush();
}

// mount appimage into sandbox file system
void appimage_mount(void) {
	if (!devloop)
		return;

	unsigned long flags = MS_MGC_VAL|MS_RDONLY;
	if (getuid())
		flags |= MS_NODEV|MS_NOSUID;

	if (size == 0) {
		fmessage("Mounting appimage type 1\n");
		char *mode;
		if (asprintf(&mode, "mode=700,uid=%d,gid=%d", getuid(), getgid()) == -1)
			errExit("asprintf");
		if (mount(devloop, RUN_FIREJAIL_APPIMAGE_DIR, "iso9660", flags, mode) < 0)
			errExit("mounting appimage");
		free(mode);
	}
	else {
		fmessage("Mounting appimage type 2\n");
		if (mount(devloop, RUN_FIREJAIL_APPIMAGE_DIR, "squashfs", flags, NULL) < 0)
			errExit("mounting appimage");
	}
}

void appimage_clear(void) {
	EUID_ROOT();
	if (devloop) {
		int lfd = open(devloop, O_RDONLY|O_CLOEXEC);
		if (lfd != -1) {
			if (ioctl(lfd, LOOP_CLR_FD, 0) != -1)
				fmessage("AppImage detached\n");
			close(lfd);
		}
	}
}
