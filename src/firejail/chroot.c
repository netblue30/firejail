/*
 * Copyright (C) 2014-2019 Firejail Authors
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
#include <sys/stat.h>
#include <sys/sendfile.h>
#include <errno.h>

#include <fcntl.h>
#ifndef O_PATH
# define O_PATH 010000000
#endif


// exit if error
static void fs_check_chroot_subdir(const char *subdir, int parentfd, int check_writable) {
	assert(subdir);
	int fd = openat(parentfd, subdir, O_PATH|O_CLOEXEC);
	if (fd == -1) {
		if (errno == ENOENT)
			fprintf(stderr, "Error: cannot find /%s in chroot directory\n", subdir);
		else {
			perror("open");
			fprintf(stderr, "Error: cannot open /%s in chroot directory\n", subdir);
		}
		exit(1);
	}
	struct stat s;
	if (fstat(fd, &s) == -1)
		errExit("fstat");
	close(fd);
	if (!S_ISDIR(s.st_mode) || s.st_uid != 0) {
		fprintf(stderr, "Error: chroot /%s should be a directory owned by root\n", subdir);
		exit(1);
	}
	if (check_writable && ((S_IWGRP|S_IWOTH) & s.st_mode) != 0) {
		fprintf(stderr, "Error: only root user should be given write permission on chroot /%s\n", subdir);
		exit(1);
	}
}

// exit if error
void fs_check_chroot_dir(const char *rootdir) {
	EUID_ASSERT();
	assert(rootdir);

	char *overlay;
	if (asprintf(&overlay, "%s/.firejail", cfg.homedir) == -1)
		errExit("asprintf");
	if (strncmp(rootdir, overlay, strlen(overlay)) == 0) {
		fprintf(stderr, "Error: invalid chroot directory: no directories in %s are allowed\n", overlay);
		exit(1);
	}
	free(overlay);

	// fails if there is any symlink or if rootdir is not a directory
	int parentfd = safe_fd(rootdir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (parentfd == -1) {
		fprintf(stderr, "Error: invalid chroot directory %s\n", rootdir);
		exit(1);
	}
	// rootdir has to be owned by root and is not allowed to be generally writable,
	// this also excludes /tmp, /var/tmp and such
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

	// check subdirectories in rootdir
	fs_check_chroot_subdir("dev", parentfd, 0);
	fs_check_chroot_subdir("etc", parentfd, 1);
	fs_check_chroot_subdir("proc", parentfd, 0);
	fs_check_chroot_subdir("tmp", parentfd, 0);
	fs_check_chroot_subdir("var/tmp", parentfd, 0);

	// there should be no checking on <chrootdir>/etc/resolv.conf
	// the file is replaced with the real /etc/resolv.conf anyway
#if 0
	if (asprintf(&name, "%s/etc/resolv.conf", rootdir) == -1)
		errExit("asprintf");
	if (stat(name, &s) == 0) {
		if (s.st_uid != 0) {
			fprintf(stderr, "Error: chroot /etc/resolv.conf should be owned by root\n");
			exit(1);
		}
	}
	else {
		fprintf(stderr, "Error: chroot /etc/resolv.conf not found\n");
		exit(1);
	}
	// on Arch /etc/resolv.conf could be a symlink to /run/systemd/resolve/resolv.conf
	// on Ubuntu 17.04 /etc/resolv.conf could be a symlink to /run/resolveconf/resolv.conf
	if (is_link(name)) {
		// check the link points in chroot
		char *rname = realpath(name, NULL);
		if (!rname || strncmp(rname, rootdir, strlen(rootdir)) != 0) {
			fprintf(stderr, "Error: chroot /etc/resolv.conf is pointing outside chroot\n");
			exit(1);
		}
	}
	free(name);
#endif

	// check x11 socket directory
	if (getenv("FIREJAIL_X11"))
		fs_check_chroot_subdir("tmp/.X11-unix", parentfd, 0);

	close(parentfd);
}

// copy /etc/resolv.conf in chroot directory
static void copy_resolvconf(int parentfd) {
	int in = open("/etc/resolv.conf", O_RDONLY|O_CLOEXEC);
	if (in == -1) {
		fwarning("/etc/resolv.conf not initialized\n");
		return;
	}
	struct stat instat;
	if (fstat(in, &instat) == -1)
		errExit("fstat");
	// try to detect if resolv.conf has been bind mounted into the chroot
	// do nothing in this case in order to not truncate the real file
	struct stat outstat;
	if (fstatat(parentfd, "etc/resolv.conf", &outstat, 0) == 0) {
		if (instat.st_dev == outstat.st_dev && instat.st_ino == outstat.st_ino) {
			close(in);
			return;
		}
	}
	if (arg_debug)
		printf("Updating /etc/resolv.conf in chroot\n");
	int out = openat(parentfd, "etc/resolv.conf", O_CREAT|O_WRONLY|O_TRUNC|O_CLOEXEC, S_IRUSR | S_IWRITE | S_IRGRP | S_IROTH);
	if (out == -1)
		errExit("open");
	if (sendfile(out, in, NULL, instat.st_size) == -1)
		errExit("sendfile");
	close(in);
	close(out);
}

// chroot into an existing directory; mount existing /dev and update /etc/resolv.conf
void fs_chroot(const char *rootdir) {
	assert(rootdir);

	int parentfd = safe_fd(rootdir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (parentfd == -1)
		errExit("safe_fd");

	// mount-bind a /dev in rootdir
	if (arg_debug)
		printf("Mounting /dev on chroot /dev\n");
	int fd = openat(parentfd, "dev", O_PATH|O_DIRECTORY|O_CLOEXEC);
	if (fd == -1)
		errExit("open");
	char *proc;
	if (asprintf(&proc, "/proc/self/fd/%d", fd) == -1)
		errExit("asprintf");
	if (mount("/dev", proc, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mounting /dev");
	free(proc);
	close(fd);

	// mount a brand new proc filesystem
	if (arg_debug)
		printf("Mounting /proc filesystem on chroot /proc\n");
	fd = openat(parentfd, "proc", O_PATH|O_DIRECTORY|O_CLOEXEC);
	if (fd == -1)
		errExit("open");
	if (asprintf(&proc, "/proc/self/fd/%d", fd) == -1)
		errExit("asprintf");
	if (mount("proc", proc, "proc", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_REC, NULL) < 0)
		errExit("mounting /proc");
	free(proc);
	close(fd);

	// x11
	if (getenv("FIREJAIL_X11")) {
		if (arg_debug)
			printf("Mounting /tmp/.X11-unix on chroot /tmp/.X11-unix\n");
		fd = openat(parentfd, "tmp/.X11-unix", O_PATH|O_DIRECTORY|O_CLOEXEC);
		if (fd == -1)
			errExit("open");
		if (asprintf(&proc, "/proc/self/fd/%d", fd) == -1)
			errExit("asprintf");
		if (mount("/tmp/.X11-unix", proc, NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mounting /tmp/.X11-unix");
		free(proc);
		close(fd);
	}

	// update chroot resolv.conf
	copy_resolvconf(parentfd);

	// some older distros don't have a /run directory, create one by default
	struct stat s;
	if (fstatat(parentfd, "run", &s, AT_SYMLINK_NOFOLLOW) == 0) {
		if (S_ISLNK(s.st_mode)) {
			fprintf(stderr, "Error: chroot /run is a symbolic link\n");
			exit(1);
		}
	}
	else if (mkdirat(parentfd, "run", 0755) == -1 && errno != EEXIST)
		errExit("mkdir");
	fs_check_chroot_subdir("run", parentfd, 1);

	// create /run/firejail directory in chroot
	if (mkdirat(parentfd, RUN_FIREJAIL_DIR+1, 0755) == -1 && errno != EEXIST)
		errExit("mkdir");

	// create /run/firejail/lib directory in chroot
	if (mkdirat(parentfd, RUN_FIREJAIL_LIB_DIR+1, 0755) == -1 && errno != EEXIST)
		errExit("mkdir");
	// mount lib directory into the chroot
	fd = openat(parentfd, RUN_FIREJAIL_LIB_DIR+1, O_PATH|O_DIRECTORY|O_CLOEXEC);
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
	// mount the current mnt directory into the chroot
	fd = openat(parentfd, RUN_MNT_DIR+1, O_PATH|O_DIRECTORY|O_CLOEXEC);
	if (fd == -1)
		errExit("open");
	if (asprintf(&proc, "/proc/self/fd/%d", fd) == -1)
		errExit("asprintf");
	if (mount(RUN_MNT_DIR, proc, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
	free(proc);
	close(fd);

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
