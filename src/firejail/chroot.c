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

#ifdef HAVE_CHROOT
#include "firejail.h"
#include "../include/gcov_wrapper.h"
#include <sys/mount.h>
#include <errno.h>

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif

// exit if error
void fs_check_chroot_dir(void) {
	EUID_ASSERT();
	assert(cfg.chrootdir);

	// check chroot dirname exists, chrooting into the root directory is not allowed
	char *rpath = realpath(cfg.chrootdir, NULL);
	if (rpath == NULL || !is_dir(rpath) || strcmp(rpath, "/") == 0) {
		fprintf(stderr, "Error: invalid chroot directory %s\n", cfg.chrootdir);
		exit(1);
	}

	cfg.chrootdir = rpath;
	return;
}

// copy /etc/resolv.conf or /etc/machine-id in chroot directory
static void update_file(int parentfd, const char *relpath) {
	assert(relpath && relpath[0] && relpath[0] != '/');

	int rootfd = open("/", O_PATH|O_CLOEXEC);
	if (rootfd == -1)
		errExit("open");
	int in = openat(rootfd, relpath, O_RDONLY|O_CLOEXEC);
	close(rootfd);
	if (in == -1)
		goto errout;

	struct stat src;
	if (fstat(in, &src) == -1)
		errExit("fstat");
	// try to detect if file has been bind mounted into the chroot
	struct stat dst;
	if (fstatat(parentfd, relpath, &dst, 0) == 0) {
		if (src.st_dev == dst.st_dev && src.st_ino == dst.st_ino) {
			close(in);
			return;
		}
	}
	if (arg_debug)
		printf("Updating chroot /%s\n", relpath);
	unlinkat(parentfd, relpath, 0);
	int out = openat(parentfd, relpath, O_WRONLY|O_CREAT|O_EXCL|O_CLOEXEC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (out == -1) {
		close(in);
		goto errout;
	}
	if (copy_file_by_fd(in, out) != 0)
		errExit("copy_file_by_fd");
	close(in);
	close(out);
	return;

errout:
	fwarning("chroot /%s not initialized\n", relpath);
}

// exit if error
static void check_subdir(int parentfd, const char *subdir, int check_writable) {
	assert(subdir && subdir[0] && subdir[0] != '/');
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
	int parentfd = safer_openat(-1, rootdir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (parentfd == -1)
		errExit("safer_openat");

	if (faccessat(parentfd, ".", X_OK, 0) != 0) {
		fprintf(stderr, "Error: no search permission on chroot directory\n");
		exit(1);
	}
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
	check_subdir(parentfd, "var", 1);
	check_subdir(parentfd, "var/tmp", 0);

	// mount-bind a /dev in rootdir
	if (arg_debug)
		printf("Mounting /dev on chroot /dev\n");
	// open chroot /dev to get a file descriptor,
	// then use this descriptor as a mount target
	int fd = openat(parentfd, "dev", O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1)
		errExit("open");
	if (bind_mount_path_to_fd("/dev", fd))
		errExit("mounting /dev");
	close(fd);

#ifdef HAVE_X11
	// if users want this mount, they should set FIREJAIL_CHROOT_X11
	if (env_get("FIREJAIL_X11") || env_get("FIREJAIL_CHROOT_X11")) {
		if (arg_debug)
			printf("Mounting /tmp/.X11-unix on chroot /tmp/.X11-unix\n");
		struct stat s1, s2;
		if (stat("/tmp", &s1) || lstat("/tmp/.X11-unix", &s2))
			errExit("mounting /tmp/.X11-unix");
		if ((s1.st_mode & S_ISVTX) != S_ISVTX) {
			fprintf(stderr, "Error: sticky bit not set on /tmp directory\n");
			exit(1);
		}
		if (s2.st_uid != 0) {
			fprintf(stderr, "Error: /tmp/.X11-unix not owned by root user\n");
			exit(1);
		}

		check_subdir(parentfd, "tmp/.X11-unix", 0);
		fd = openat(parentfd, "tmp/.X11-unix", O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
		if (fd == -1)
			errExit("open");
		if (bind_mount_path_to_fd("/tmp/.X11-unix", fd))
			errExit("mounting /tmp/.X11-unix");
		close(fd);
	}
#endif // HAVE_X11

	// some older distros don't have a /run directory, create one by default
	if (mkdirat(parentfd, "run", 0755) == -1 && errno != EEXIST)
		errExit("mkdir");
	check_subdir(parentfd, "run", 1);

	// pulseaudio; only support for default directory /run/user/$UID/pulse
	if (env_get("FIREJAIL_CHROOT_PULSE")) {
		char *pulse;
		if (asprintf(&pulse, "%s/run/user/%d/pulse", cfg.chrootdir, getuid()) == -1)
			errExit("asprintf");
		char *orig_pulse = pulse + strlen(cfg.chrootdir);

		if (arg_debug)
			printf("Mounting %s on chroot %s\n", orig_pulse, orig_pulse);
		int src = safer_openat(-1, orig_pulse, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
		if (src == -1) {
			fprintf(stderr, "Error: cannot open %s\n", orig_pulse);
			exit(1);
		}
		int dst = safer_openat(-1, pulse, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
		if (dst == -1) {
			fprintf(stderr, "Error: cannot open %s\n", pulse);
			exit(1);
		}
		if (bind_mount_by_fd(src, dst))
			errExit("mounting pulseaudio");
		close(src);
		close(dst);
		free(pulse);

		// update /etc/machine-id in chroot
		update_file(parentfd, "etc/machine-id");
	}

	// create /run/firejail directory in chroot
	if (mkdirat(parentfd, &RUN_FIREJAIL_DIR[1], 0755) == -1 && errno != EEXIST)
		errExit("mkdir");
	check_subdir(parentfd, &RUN_FIREJAIL_DIR[1], 1);

	// create /run/firejail/lib directory in chroot
	if (mkdirat(parentfd, &RUN_FIREJAIL_LIB_DIR[1], 0755) == -1 && errno != EEXIST)
		errExit("mkdir");
	check_subdir(parentfd, &RUN_FIREJAIL_LIB_DIR[1], 1);
	// mount lib directory into the chroot
	fd = openat(parentfd, &RUN_FIREJAIL_LIB_DIR[1], O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1)
		errExit("open");
	if (bind_mount_path_to_fd(RUN_FIREJAIL_LIB_DIR, fd))
		errExit("mount bind");
	close(fd);

	// create /run/firejail/mnt directory in chroot
	if (mkdirat(parentfd, &RUN_MNT_DIR[1], 0755) == -1 && errno != EEXIST)
		errExit("mkdir");
	check_subdir(parentfd, &RUN_MNT_DIR[1], 1);
	// mount the current mnt directory into the chroot
	fd = openat(parentfd, &RUN_MNT_DIR[1], O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1)
		errExit("open");
	if (bind_mount_path_to_fd(RUN_MNT_DIR, fd))
		errExit("mount bind");
	close(fd);

	// update chroot resolv.conf
	update_file(parentfd, "etc/resolv.conf");

	__gcov_flush();

	// create /run/firejail/mnt/oroot
	char *oroot = RUN_OVERLAY_ROOT;
	if (mkdir(oroot, 0755) == -1)
		errExit("mkdir");
	// mount the chroot dir on top of /run/firejail/mnt/oroot in order to reuse the apparmor rules for overlay
	if (bind_mount_fd_to_path(parentfd, oroot))
		errExit("mounting rootdir oroot");
	close(parentfd);
	// chroot into the new directory
	if (arg_debug)
		printf("Chrooting into %s\n", rootdir);
	if (chroot(oroot) < 0)
		errExit("chroot");

	// mount a new proc filesystem
	if (arg_debug)
		printf("Mounting /proc filesystem representing the PID namespace\n");
	if (mount("proc", "/proc", "proc", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_REC, NULL) < 0)
		errExit("mounting /proc");

	// create all other /run/firejail files and directories
	preproc_build_firejail_dir();

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
