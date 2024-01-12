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

#ifdef HAVE_OVERLAYFS
#include "firejail.h"
#include "../include/gcov_wrapper.h"
#include <sys/mount.h>
#include <sys/wait.h>
#include <ftw.h>
#include <errno.h>

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif


char *fs_check_overlay_dir(const char *subdirname, int allow_reuse) {
	assert(subdirname);
	EUID_ASSERT();
	struct stat s;
	char *dirname;

	if (asprintf(&dirname, "%s/.firejail", cfg.homedir) == -1)
		errExit("asprintf");
	// check if ~/.firejail already exists
	if (lstat(dirname, &s) == 0) {
		if (!S_ISDIR(s.st_mode)) {
			if (S_ISLNK(s.st_mode))
				fprintf(stderr, "Error: %s is a symbolic link\n", dirname);
			else
				fprintf(stderr, "Error: %s is not a directory\n", dirname);
			exit(1);
		}
		if (s.st_uid != getuid()) {
			fprintf(stderr, "Error: %s is not owned by the current user\n", dirname);
			exit(1);
		}
	}
	else {
		// create ~/.firejail directory
		create_empty_dir_as_user(dirname, 0700);
		if (stat(dirname, &s) == -1) {
			fprintf(stderr, "Error: cannot create directory %s\n", dirname);
			exit(1);
		}
	}
	free(dirname);

	// check overlay directory
	if (asprintf(&dirname, "%s/.firejail/%s", cfg.homedir, subdirname) == -1)
		errExit("asprintf");
	if (lstat(dirname, &s) == 0) {
		if (!S_ISDIR(s.st_mode)) {
			if (S_ISLNK(s.st_mode))
				fprintf(stderr, "Error: %s is a symbolic link\n", dirname);
			else
				fprintf(stderr, "Error: %s is not a directory\n", dirname);
			exit(1);
		}
		if (s.st_uid != 0) {
			fprintf(stderr, "Error: overlay directory %s is not owned by the root user\n", dirname);
			exit(1);
		}
		if (allow_reuse == 0) {
			fprintf(stderr, "Error: overlay directory exists, but reuse is not allowed\n");
			exit(1);
		}
	}

	return dirname;
}


// mount overlayfs on top of / directory
// mounting an overlay and chrooting into it:
//
// Old Ubuntu kernel
// # cd ~
// # mkdir -p overlay/root
// # mkdir -p overlay/diff
// # mount -t overlayfs -o lowerdir=/,upperdir=/root/overlay/diff overlayfs /root/overlay/root
// # chroot /root/overlay/root
// to shutdown, first exit the chroot and then  unmount the overlay
// # exit
// # umount /root/overlay/root
//
// Kernels 3.18+
// # cd ~
// # mkdir -p overlay/root
// # mkdir -p overlay/diff
// # mkdir -p overlay/work
// # mount -t overlay -o lowerdir=/,upperdir=/root/overlay/diff,workdir=/root/overlay/work overlay /root/overlay/root
// # cat /etc/mtab | grep overlay
// /root/overlay /root/overlay/root overlay rw,relatime,lowerdir=/,upperdir=/root/overlay/diff,workdir=/root/overlay/work 0 0
// # chroot /root/overlay/root
// to shutdown, first exit the chroot and then  unmount the overlay
// # exit
// # umount /root/overlay/root

// to do: fix the code below
#include <sys/utsname.h>
void fs_overlayfs(void) {
	struct stat s;

	// check kernel version
	struct utsname u;
	int rv = uname(&u);
	if (rv != 0)
		errExit("uname");
	int major;
	int minor;
	if (2 != sscanf(u.release, "%d.%d", &major, &minor)) {
		fprintf(stderr, "Error: cannot extract Linux kernel version: %s\n", u.version);
		exit(1);
	}

	if (arg_debug)
		printf("Linux kernel version %d.%d\n", major, minor);
	int oldkernel = 0;
	if (major < 3) {
		fprintf(stderr, "Error: minimum kernel version required 3.x\n");
		exit(1);
	}
	if (major == 3 && minor < 18)
		oldkernel = 1;

	// mounting an overlayfs on top of / seems to be broken for kernels > 4.19
	// we disable overlayfs for now, pending fixing
	if (major >= 4 &&minor >= 19) {
		fprintf(stderr, "Error: OverlayFS disabled for Linux kernels 4.19 and newer, pending fixing.\n");
		exit(1);
	}

	char *oroot = RUN_OVERLAY_ROOT;
	mkdir_attr(oroot, 0755, 0, 0);

	// set base for working and diff directories
	char *basedir = RUN_MNT_DIR;
	int basefd = -1;

	if (arg_overlay_keep) {
		basedir = cfg.overlay_dir;
		assert(basedir);
		// get a file descriptor for ~/.firejail, fails if there is any symlink
		char *firejail;
		if (asprintf(&firejail, "%s/.firejail", cfg.homedir) == -1)
			errExit("asprintf");
		int fd = safer_openat(-1, firejail, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
		if (fd == -1)
			errExit("safer_openat");
		free(firejail);
		// create basedir if it doesn't exist
		// the new directory will be owned by root
		const char *dirname = gnu_basename(basedir);
		if (mkdirat(fd, dirname, 0755) == -1 && errno != EEXIST) {
			perror("mkdir");
			fprintf(stderr, "Error: cannot create overlay directory %s\n", basedir);
			exit(1);
		}
		// open basedir
		basefd = openat(fd, dirname, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
		close(fd);
	}
	else {
		basefd = open(basedir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	}
	if (basefd == -1) {
		perror("open");
		fprintf(stderr, "Error: cannot open overlay directory %s\n", basedir);
		exit(1);
	}

	// confirm once more base is owned by root
	if (fstat(basefd, &s) == -1)
		errExit("fstat");
	if (s.st_uid != 0) {
		fprintf(stderr, "Error: overlay directory %s is not owned by the root user\n", basedir);
		exit(1);
	}
	// confirm permissions of base are 0755
	if (((S_IRWXU|S_IRGRP|S_IXGRP|S_IROTH|S_IXOTH) & s.st_mode) != (S_IRWXU|S_IRGRP|S_IXGRP|S_IROTH|S_IXOTH)) {
		fprintf(stderr, "Error: invalid permissions on overlay directory %s\n", basedir);
		exit(1);
	}

	// create diff and work directories inside base
	// no need to check arg_overlay_reuse
	char *odiff;
	if (asprintf(&odiff, "%s/odiff", basedir) == -1)
		errExit("asprintf");
	// the new directory will be owned by root
	if (mkdirat(basefd, "odiff", 0755) == -1 && errno != EEXIST) {
		perror("mkdir");
		fprintf(stderr, "Error: cannot create overlay directory %s\n", odiff);
		exit(1);
	}
	ASSERT_PERMS(odiff, 0, 0, 0755);

	char *owork;
	if (asprintf(&owork, "%s/owork", basedir) == -1)
		errExit("asprintf");
	// the new directory will be owned by root
	if (mkdirat(basefd, "owork", 0755) == -1 && errno != EEXIST) {
		perror("mkdir");
		fprintf(stderr, "Error: cannot create overlay directory %s\n", owork);
		exit(1);
	}
	ASSERT_PERMS(owork, 0, 0, 0755);

	// mount overlayfs
	if (arg_debug)
		printf("Mounting OverlayFS\n");
	char *option;
	if (oldkernel) { // old Ubuntu/OpenSUSE kernels
		if (arg_overlay_keep) {
			fprintf(stderr, "Error: option --overlay= not available for kernels older than 3.18\n");
			exit(1);
		}
		if (asprintf(&option, "lowerdir=/,upperdir=%s", odiff) == -1)
			errExit("asprintf");
		if (mount("overlayfs", oroot, "overlayfs", MS_MGC_VAL, option) < 0)
			errExit("mounting overlayfs");
	}
	else { // kernel 3.18 or newer
		if (asprintf(&option, "lowerdir=/,upperdir=%s,workdir=%s", odiff, owork) == -1)
			errExit("asprintf");
		if (mount("overlay", oroot, "overlay", MS_MGC_VAL, option) < 0) {
			fprintf(stderr, "Debug: running on kernel version %d.%d\n", major, minor);
			errExit("mounting overlayfs");
		}

		//***************************
		// issue #263 start code
		// My setup has a separate mount point for /home. When the overlay is mounted,
		// the overlay does not contain the original /home contents.
		// I added code to create a second overlay for /home if the overlay home dir is empty and this seems to work
		// @dshmgh, Jan 2016
		{
			char *overlayhome;
			struct stat s;
			char *hroot;
			char *hdiff;
			char *hwork;

			// dons add debug
			if (arg_debug) printf ("DEBUG: chroot dirs are oroot %s  odiff %s  owork %s\n",oroot,odiff,owork);

			// BEFORE NEXT, WE NEED TO TEST IF /home has any contents or do we need to mount it?
			// must create var for oroot/cfg.homedir
			if (asprintf(&overlayhome, "%s%s", oroot, cfg.homedir) == -1)
				errExit("asprintf");
			if (arg_debug) printf ("DEBUG: overlayhome var holds ##%s##\n", overlayhome);

			// if no homedir in overlay -- create another overlay for /home
			if (stat(cfg.homedir, &s) == 0 && stat(overlayhome, &s) == -1) {

				// no need to check arg_overlay_reuse
				if (asprintf(&hdiff, "%s/hdiff", basedir) == -1)
					errExit("asprintf");
				// the new directory will be owned by root
				if (mkdirat(basefd, "hdiff", 0755) == -1 && errno != EEXIST) {
					perror("mkdir");
					fprintf(stderr, "Error: cannot create overlay directory %s\n", hdiff);
					exit(1);
				}
				ASSERT_PERMS(hdiff, 0, 0, 0755);

				// no need to check arg_overlay_reuse
				if (asprintf(&hwork, "%s/hwork", basedir) == -1)
					errExit("asprintf");
				// the new directory will be owned by root
				if (mkdirat(basefd, "hwork", 0755) == -1 && errno != EEXIST) {
					perror("mkdir");
					fprintf(stderr, "Error: cannot create overlay directory %s\n", hwork);
					exit(1);
				}
				ASSERT_PERMS(hwork, 0, 0, 0755);

				// no homedir in overlay so now mount another overlay for /home
				if (asprintf(&hroot, "%s/home", oroot) == -1)
					errExit("asprintf");
				if (asprintf(&option, "lowerdir=/home,upperdir=%s,workdir=%s", hdiff, hwork) == -1)
					errExit("asprintf");
				if (mount("overlay", hroot, "overlay", MS_MGC_VAL, option) < 0)
					errExit("mounting overlayfs for mounted home directory");

				printf("OverlayFS for /home configured in %s directory\n", basedir);
				free(hroot);
				free(hdiff);
				free(hwork);

			} // stat(overlayhome)
			free(overlayhome);
		}
		// issue #263 end code
		//***************************
	}
	fmessage("OverlayFS configured in %s directory\n", basedir);
	close(basefd);

	// /dev, /run and /tmp are not covered by the overlay
	// mount-bind dev directory
	if (arg_debug)
		printf("Mounting /dev\n");
	char *dev;
	if (asprintf(&dev, "%s/dev", oroot) == -1)
		errExit("asprintf");
	if (mount("/dev", dev, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mounting /dev");
	fs_logger("whitelist /dev");

	// mount-bind run directory
	if (arg_debug)
		printf("Mounting /run\n");
	char *run;
	if (asprintf(&run, "%s/run", oroot) == -1)
		errExit("asprintf");
	if (mount("/run", run, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mounting /run");
	fs_logger("whitelist /run");

	// mount-bind tmp directory
	if (arg_debug)
		printf("Mounting /tmp\n");
	char *tmp;
	if (asprintf(&tmp, "%s/tmp", oroot) == -1)
		errExit("asprintf");
	if (mount("/tmp", tmp, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mounting /tmp");
	fs_logger("whitelist /tmp");

	// chroot in the new filesystem
	__gcov_flush();

	if (chroot(oroot) == -1)
		errExit("chroot");

	// mount a new proc filesystem
	if (arg_debug)
		printf("Mounting /proc filesystem representing the PID namespace\n");
	if (mount("proc", "/proc", "proc", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_REC, NULL) < 0)
		errExit("mounting /proc");

	// update /var directory in order to support multiple sandboxes running on the same root directory
//	if (!arg_private_dev)
//		fs_dev_shm();
	fs_var_lock();
	if (!arg_keep_var_tmp)
		fs_var_tmp();
	if (!arg_writable_var_log)
		fs_var_log();
	fs_var_lib();
	fs_var_cache();
	fs_var_utmp();
	fs_machineid();

	// don't leak user information
	restrict_users();

	// when starting as root, firejail config is not disabled;
	if (getuid() != 0)
		disable_config();

	// cleanup and exit
	free(option);
	free(odiff);
	free(owork);
	free(dev);
	free(run);
	free(tmp);
}


static int remove_callback(const char *fpath, const struct stat *sb, int typeflag, struct FTW *ftwbuf) {
	(void) sb;
	(void) typeflag;
	(void) ftwbuf;
	assert(fpath);

	if (strcmp(fpath, ".") == 0)	// rmdir would fail with EINVAL
		return 0;

	if (remove(fpath)) {	// removes the link not the actual file
		fprintf(stderr, "Error: cannot remove file: %s\n", strerror(errno));
		exit(1);
	}

	return 0;
}

int remove_overlay_directory(void) {
	EUID_ASSERT();
	sleep(1);

	char *path;
	if (asprintf(&path, "%s/.firejail", cfg.homedir) == -1)
		errExit("asprintf");

	if (access(path, F_OK) == 0) {
		pid_t child = fork();
		if (child < 0)
			errExit("fork");
		if (child == 0) {
			// open ~/.firejail
			int fd = safer_openat(-1, path, O_PATH|O_NOFOLLOW|O_CLOEXEC);
			if (fd == -1) {
				fprintf(stderr, "Error: cannot open %s\n", path);
				exit(1);
			}
			struct stat s;
			if (fstat(fd, &s) == -1)
				errExit("fstat");
			if (!S_ISDIR(s.st_mode)) {
				if (S_ISLNK(s.st_mode))
					fprintf(stderr, "Error: %s is a symbolic link\n", path);
				else
					fprintf(stderr, "Error: %s is not a directory\n", path);
				exit(1);
			}
			if (s.st_uid != getuid()) {
				fprintf(stderr, "Error: %s is not owned by the current user\n", path);
				exit(1);
			}
			// chdir to ~/.firejail
			if (fchdir(fd) == -1)
				errExit("fchdir");
			close(fd);

			EUID_ROOT();
			// FTW_PHYS - do not follow symbolic links
			if (nftw(".", remove_callback, 64, FTW_DEPTH | FTW_PHYS) == -1)
				errExit("nftw");

			EUID_USER();
			// remove ~/.firejail
			if (rmdir(path) == -1)
				errExit("rmdir");

			__gcov_flush();

			_exit(0);
		}
		// wait for the child to finish
		waitpid(child, NULL, 0);
		// check if ~/.firejail was deleted
		if (access(path, F_OK) == 0)
			return 1;
	}
	return 0;
}

#endif // HAVE_OVERLAYFS
