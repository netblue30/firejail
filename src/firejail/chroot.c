/*
 * Copyright (C) 2014-2020 Firejail Authors
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

#ifdef HAVE_CHROOT
#include "firejail.h"
#include <sys/mount.h>
#include <sys/sendfile.h>
#include <errno.h>

#include <fcntl.h>
#ifndef O_PATH
# define O_PATH 010000000
#endif


// exit if error
void fs_check_chroot_dir(void) {
	EUID_ASSERT();
	assert(cfg.chrootdir);
	if (strstr(cfg.chrootdir, "..") ||
	    is_link(cfg.chrootdir) ||
	    !is_dir(cfg.chrootdir))
		goto errout;

	// check chroot dirname exists, chrooting into the root directory is not allowed
	char *rpath = realpath(cfg.chrootdir, NULL);
	if (rpath == NULL || strcmp(rpath, "/") == 0)
		goto errout;

	char *overlay;
	if (asprintf(&overlay, "%s/.firejail", cfg.homedir) == -1)
		errExit("asprintf");
	if (strncmp(rpath, overlay, strlen(overlay)) == 0) {
		fprintf(stderr, "Error: invalid chroot directory: no directories in %s are allowed\n", overlay);
		exit(1);
	}
	free(overlay);
	cfg.chrootdir = rpath;
	return;

errout:
	fprintf(stderr, "Error: invalid chroot directory %s\n", cfg.chrootdir);
	exit(1);
}

// copy /etc/resolv.conf in chroot directory
static void copy_resolvconf(int parentfd) {
	int in = open("/etc/resolv.conf", O_RDONLY|O_CLOEXEC);
	if (in == -1)
		goto errout;
	struct stat src;
	if (fstat(in, &src) == -1)
		errExit("fstat");
	// try to detect if resolv.conf has been bind mounted into the chroot
	// do nothing in this case in order to not unlink the real file
	struct stat dst;
	if (fstatat(parentfd, "etc/resolv.conf", &dst, 0) == 0) {
		if (src.st_dev == dst.st_dev && src.st_ino == dst.st_ino) {
			close(in);
			return;
		}
	}
	if (arg_debug)
		printf("Updating /etc/resolv.conf in chroot\n");
	unlinkat(parentfd, "etc/resolv.conf", 0);
	int out = openat(parentfd, "etc/resolv.conf", O_WRONLY|O_CREAT|O_EXCL|O_CLOEXEC, S_IRUSR | S_IWRITE | S_IRGRP | S_IROTH);
	if (out == -1) {
		close(in);
		goto errout;
	}
	if (sendfile(out, in, NULL, src.st_size) == -1)
		errExit("sendfile");
	close(in);
	close(out);
	return;

errout:
	fwarning("/etc/resolv.conf not initialized\n");
}

// exit if error
static void check_subdir(int parentfd, const char *subdir, int check_writable) {
	assert(subdir);
	struct stat s;
	if (fstatat(parentfd, subdir, &s, AT_SYMLINK_NOFOLLOW) != 0) {
		fprintf(stderr, "Error: cannot find /%s in chroot directory\n", subdir);
		exit(1);
	}
	if (!S_ISDIR(s.st_mode)) {
		if (S_ISLNK(s.st_mode))
			fprintf(stderr, "Error: chroot /%s is a symbolic link\n", subdir);
		else
			fprintf(stderr, "Error: chroot /%s is not a directory\n", subdir);
		exit(1);
	}
	if (s.st_uid != 0) {
		fprintf(stderr, "Error: chroot /%s should be owned by root\n", subdir);
		exit(1);
	}
	if (check_writable && ((S_IWGRP|S_IWOTH) & s.st_mode) != 0) {
		fprintf(stderr, "Error: only root user should be given write permission on chroot /%s\n", subdir);
		exit(1);
	}
}

// chroot into an existing directory; mount existing /dev and update /etc/resolv.conf
void fs_chroot(const char *rootdir) {
	assert(rootdir);

	// fails if there is any symlink or if rootdir is not a directory
	int parentfd = safe_fd(rootdir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (parentfd == -1)
		errExit("safe_fd");
	// rootdir has to be owned by root and is not allowed to be generally writable,
	// this also excludes /tmp and friends
	struct stat s;
	if (fstat(parentfd, &s) == -1)
		errExit("fstat");
	if (s.st_uid != 0) {
		fprintf(stderr, "Error: chroot directory should be owned by root\n");
		exit(1);
	}
	if (((S_IWGRP|S_IWOTH) & s.st_mode) != 0) {
		fprintf(stderr, "Error: only root user should be given write permission on chroot directory\n");
		exit(1);
	}
	// check chroot subdirectories; /tmp/.X11-unix and /run are treated separately
	check_subdir(parentfd, "dev", 0);
	check_subdir(parentfd, "etc", 1);
	check_subdir(parentfd, "proc", 0);
	check_subdir(parentfd, "tmp", 0);
	check_subdir(parentfd, "var/tmp", 0);

	// mount-bind a /dev in rootdir
	if (arg_debug)
		printf("Mounting /dev on chroot /dev\n");
	// open chroot /dev to get a file descriptor,
	// then use this descriptor as a mount target
	int fd = openat(parentfd, "dev", O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1)
		errExit("open");
	char *proc;
	if (asprintf(&proc, "/proc/self/fd/%d", fd) == -1)
		errExit("asprintf");
	if (mount("/dev", proc, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mounting /dev");
	free(proc);
	close(fd);

	// x11
	// if users want this mount, they should set FIREJAIL_CHROOT_X11
	if (getenv("FIREJAIL_X11") || getenv("FIREJAIL_CHROOT_X11")) {
		if (arg_debug)
			printf("Mounting /tmp/.X11-unix on chroot /tmp/.X11-unix\n");
		check_subdir(parentfd, "tmp/.X11-unix", 0);
		fd = openat(parentfd, "tmp/.X11-unix", O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
		if (fd == -1)
			errExit("open");
		if (asprintf(&proc, "/proc/self/fd/%d", fd) == -1)
			errExit("asprintf");
		if (mount("/tmp/.X11-unix", proc, NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mounting /tmp/.X11-unix");
		free(proc);
		close(fd);
	}

	// some older distros don't have a /run directory, create one by default
	if (mkdirat(parentfd, "run", 0755) == -1 && errno != EEXIST)
		errExit("mkdir");
	check_subdir(parentfd, "run", 1);

	// create /run/firejail directory in chroot
	if (mkdirat(parentfd, RUN_FIREJAIL_DIR+1, 0755) == -1 && errno != EEXIST)
		errExit("mkdir");
	check_subdir(parentfd, RUN_FIREJAIL_DIR+1, 1);

	// create /run/firejail/lib directory in chroot
	if (mkdirat(parentfd, RUN_FIREJAIL_LIB_DIR+1, 0755) == -1 && errno != EEXIST)
		errExit("mkdir");
	check_subdir(parentfd, RUN_FIREJAIL_LIB_DIR+1, 1);
	// mount lib directory into the chroot
	fd = openat(parentfd, RUN_FIREJAIL_LIB_DIR+1, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1)
		errExit("open");
	if (asprintf(&proc, "/proc/self/fd/%d", fd) == -1)
		errExit("asprintf");
	if (mount(RUN_FIREJAIL_LIB_DIR, proc, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
	free(proc);
	close(fd);

	// create /run/firejail/mnt directory in chroot
	if (mkdirat(parentfd, RUN_MNT_DIR+1, 0755) == -1 && errno != EEXIST)
		errExit("mkdir");
	check_subdir(parentfd, RUN_MNT_DIR+1, 1);
	// mount the current mnt directory into the chroot
	fd = openat(parentfd, RUN_MNT_DIR+1, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1)
		errExit("open");
	if (asprintf(&proc, "/proc/self/fd/%d", fd) == -1)
		errExit("asprintf");
	if (mount(RUN_MNT_DIR, proc, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
	free(proc);
	close(fd);

	// update chroot resolv.conf
	copy_resolvconf(parentfd);

#ifdef HAVE_GCOV
	__gcov_flush();
#endif
	// create /run/firejail/mnt/oroot
	char *oroot = RUN_OVERLAY_ROOT;
	if (mkdir(oroot, 0755) == -1)
		errExit("mkdir");
	// mount the chroot dir on top of /run/firejail/mnt/oroot in order to reuse the apparmor rules for overlay
	if (asprintf(&proc, "/proc/self/fd/%d", parentfd) == -1)
		errExit("asprintf");
	if (mount(proc, oroot, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mounting rootdir oroot");
	free(proc);
	close(parentfd);
	// chroot into the new directory
	if (arg_debug)
		printf("Chrooting into %s\n", rootdir);
	if (chroot(oroot) < 0)
		errExit("chroot");

	// create all other /run/firejail files and directories
	preproc_build_firejail_dir();

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
}

#endif // HAVE_CHROOT
