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
#include "firejail.h"
#include <sys/mount.h>
#include <linux/limits.h>
#include <glob.h>
#include <dirent.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <grp.h>

static void skel(const char *homedir, uid_t u, gid_t g) {
	char *fname;
	// zsh
	if (arg_zsh) {
		// copy skel files
		if (asprintf(&fname, "%s/.zshrc", homedir) == -1)
			errExit("asprintf");
		struct stat s;
		// don't copy it if we already have the file
		if (stat(fname, &s) == 0)
			return;
		if (is_link(fname)) { // stat on dangling symlinks fails, try again using lstat
			fprintf(stderr, "Error: invalid %s file\n", fname);
			exit(1);
		}
		if (stat("/etc/skel/.zshrc", &s) == 0) {
			copy_file_as_user("/etc/skel/.zshrc", fname, u, g, 0644); // regular user
			fs_logger("clone /etc/skel/.zshrc");
		}
		else {
			touch_file_as_user(fname, u, g, 0644);
			fs_logger2("touch", fname);
		}
		free(fname);
	}
	// csh
	else if (arg_csh) {
		// copy skel files
		if (asprintf(&fname, "%s/.cshrc", homedir) == -1)
			errExit("asprintf");
		struct stat s;
		// don't copy it if we already have the file
		if (stat(fname, &s) == 0)
			return;
		if (is_link(fname)) { // stat on dangling symlinks fails, try again using lstat
			fprintf(stderr, "Error: invalid %s file\n", fname);
			exit(1);
		}
		if (stat("/etc/skel/.cshrc", &s) == 0) {
			copy_file_as_user("/etc/skel/.cshrc", fname, u, g, 0644); // regular user
			fs_logger("clone /etc/skel/.cshrc");
		}
		else {
			touch_file_as_user(fname, u, g, 0644);
			fs_logger2("touch", fname);
		}
		free(fname);
	}
	// bash etc.
	else {
		// copy skel files
		if (asprintf(&fname, "%s/.bashrc", homedir) == -1)
			errExit("asprintf");
		struct stat s;
		// don't copy it if we already have the file
		if (stat(fname, &s) == 0) 
			return;
		if (is_link(fname)) { // stat on dangling symlinks fails, try again using lstat
			fprintf(stderr, "Error: invalid %s file\n", fname);
			exit(1);
		}
		if (stat("/etc/skel/.bashrc", &s) == 0) {
			copy_file_as_user("/etc/skel/.bashrc", fname, u, g, 0644); // regular user
			fs_logger("clone /etc/skel/.bashrc");
		}
		free(fname);
	}
}

static int store_xauthority(void) {
	// put a copy of .Xauthority in XAUTHORITY_FILE
	fs_build_mnt_dir();

	char *src;
	char *dest = RUN_XAUTHORITY_FILE;
	// create an empty file as root, and change ownership to user
	FILE *fp = fopen(dest, "w");
	if (fp) {
		fprintf(fp, "\n");
		SET_PERMS_STREAM(fp, getuid(), getgid(), 0600);
		fclose(fp);
	}
	
	if (asprintf(&src, "%s/.Xauthority", cfg.homedir) == -1)
		errExit("asprintf");
	
	struct stat s;
	if (stat(src, &s) == 0) {
		if (is_link(src)) {
			fprintf(stderr, "Warning: invalid .Xauthority file\n");
			return 0;
		}

		copy_file_as_user(src, dest, getuid(), getgid(), 0600); // regular user
		fs_logger2("clone", dest);
		return 1; // file copied
	}
	
	return 0;
}

static int store_asoundrc(void) {
	// put a copy of .Xauthority in XAUTHORITY_FILE
	fs_build_mnt_dir();

	char *src;
	char *dest = RUN_ASOUNDRC_FILE;
	// create an empty file as root, and change ownership to user
	FILE *fp = fopen(dest, "w");
	if (fp) {
		fprintf(fp, "\n");
		SET_PERMS_STREAM(fp, getuid(), getgid(), 0644);
		fclose(fp);
	}
	
	if (asprintf(&src, "%s/.asoundrc", cfg.homedir) == -1)
		errExit("asprintf");
	
	struct stat s;
	if (stat(src, &s) == 0) {
		if (is_link(src)) {
			// make sure the real path of the file is inside the home directory
			/* coverity[toctou] */
			char* rp = realpath(src, NULL);
			if (!rp) {
				fprintf(stderr, "Error: Cannot access %s\n", src);
				exit(1);
			}
			if (strncmp(rp, cfg.homedir, strlen(cfg.homedir)) != 0) {
				fprintf(stderr, "Error: .asoundrc is a symbolic link pointing to a file outside home directory\n");
				exit(1);
			}
			free(rp);
		}

		copy_file_as_user(src, dest, getuid(), getgid(), 0644); // regular user
		fs_logger2("clone", dest);
		return 1; // file copied
	}
	
	return 0;
}

static void copy_xauthority(void) {
	// copy XAUTHORITY_FILE in the new home directory
	char *src = RUN_XAUTHORITY_FILE ;
	char *dest;
	if (asprintf(&dest, "%s/.Xauthority", cfg.homedir) == -1)
		errExit("asprintf");
	
	// if destination is a symbolic link, exit the sandbox!!!
	if (is_link(dest)) {
		fprintf(stderr, "Error: %s is a symbolic link\n", dest);
		exit(1);
	}

	copy_file_as_user(src, dest, getuid(), getgid(), S_IRUSR | S_IWUSR); // regular user
	fs_logger2("clone", dest);
	
	// delete the temporary file
	unlink(src);
}

static void copy_asoundrc(void) {
	// copy XAUTHORITY_FILE in the new home directory
	char *src = RUN_ASOUNDRC_FILE ;
	char *dest;
	if (asprintf(&dest, "%s/.asoundrc", cfg.homedir) == -1)
		errExit("asprintf");
	
	// if destination is a symbolic link, exit the sandbox!!!
	if (is_link(dest)) {
		fprintf(stderr, "Error: %s is a symbolic link\n", dest);
		exit(1);
	}

	copy_file_as_user(src, dest, getuid(), getgid(), S_IRUSR | S_IWUSR); // regular user
	fs_logger2("clone", dest);

	// delete the temporary file
	unlink(src);
}

// private mode (--private=homedir):
// 	mount homedir on top of /home/user,
// 	tmpfs on top of  /root in nonroot mode,
// 	set skel files,
// 	restore .Xauthority
void fs_private_homedir(void) {
	char *homedir = cfg.homedir;
	char *private_homedir = cfg.home_private;
	assert(homedir);
	assert(private_homedir);
	
	int xflag = store_xauthority();
	int aflag = store_asoundrc();
	
	uid_t u = getuid();
	gid_t g = getgid();
	struct stat s;
	if (stat(homedir, &s) == -1) {
		fprintf(stderr, "Error: cannot find user home directory\n");
		exit(1);
	}
	

	// mount bind private_homedir on top of homedir
	if (arg_debug)
		printf("Mount-bind %s on top of %s\n", private_homedir, homedir);
	if (mount(private_homedir, homedir, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
	fs_logger3("mount-bind", private_homedir, cfg.homedir);
// preserve mode and ownership
//	if (chown(homedir, s.st_uid, s.st_gid) == -1)
//		errExit("mount-bind chown");
//	if (chmod(homedir, s.st_mode) == -1)
//		errExit("mount-bind chmod");

	if (u != 0) {
		// mask /root
		if (arg_debug)
			printf("Mounting a new /root directory\n");
		if (mount("tmpfs", "/root", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME | MS_REC,  "mode=700,gid=0") < 0)
			errExit("mounting home directory");
		fs_logger("mount tmpfs on /root");
	}
	else {
		// mask /home
		if (arg_debug)
			printf("Mounting a new /home directory\n");
		if (mount("tmpfs", "/home", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting home directory");
		fs_logger("mount tmpfs on /home");
	}
	

	skel(homedir, u, g);
	if (xflag)
		copy_xauthority();
	if (aflag)
		copy_asoundrc();
}

// private mode (--private):
//	mount tmpfs over /home/user,
// 	tmpfs on top of  /root in nonroot mode,
// 	set skel files,
// 	restore .Xauthority
void fs_private(void) {
	char *homedir = cfg.homedir;
	assert(homedir);
	uid_t u = getuid();
	gid_t g = getgid();

	int xflag = store_xauthority();
	int aflag = store_asoundrc();

	// mask /home
	if (arg_debug)
		printf("Mounting a new /home directory\n");
	if (mount("tmpfs", "/home", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
		errExit("mounting home directory");
	fs_logger("mount tmpfs on /home");

	// mask /root
	if (arg_debug)
		printf("Mounting a new /root directory\n");
	if (mount("tmpfs", "/root", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME | MS_REC,  "mode=700,gid=0") < 0)
		errExit("mounting root directory");
	fs_logger("mount tmpfs on /root");

	if (u != 0) {
		// create /home/user
		if (arg_debug)
			printf("Create a new user directory\n");
		if (mkdir(homedir, S_IRWXU) == -1) {
			if (mkpath_as_root(homedir) == -1)
				errExit("mkpath");
			if (mkdir(homedir, S_IRWXU) == -1)
				errExit("mkdir");
		}
		if (chown(homedir, u, g) < 0)
			errExit("chown");
		fs_logger2("mkdir", homedir);
	}
	
	skel(homedir, u, g);
	if (xflag)
		copy_xauthority();
	if (aflag)
		copy_asoundrc();
}


// check new private home directory (--private= option) - exit if it fails
void fs_check_private_dir(void) {
	invalid_filename(cfg.home_private);
	
	// Expand the home directory
	char *tmp = expand_home(cfg.home_private, cfg.homedir);
	cfg.home_private = realpath(tmp, NULL);
	free(tmp);
	
	if (!cfg.home_private
	 || !is_dir(cfg.home_private)
	 || is_link(cfg.home_private)
	 || strstr(cfg.home_private, "..")) {
		fprintf(stderr, "Error: invalid private directory\n");
		exit(1);
	}

	// check home directory and chroot home directory have the same owner
	struct stat s2;
	int rv = stat(cfg.home_private, &s2);
	if (rv < 0) {
		fprintf(stderr, "Error: cannot find %s directory\n", cfg.home_private);
		exit(1);
	}

	struct stat s1;
	rv = stat(cfg.homedir, &s1);
	if (rv < 0) {
		fprintf(stderr, "Error: cannot find %s directory, full path name required\n", cfg.homedir);
		exit(1);
	}
	if (s1.st_uid != s2.st_uid) {
		printf("Error: --private directory should be owned by the current user\n");
		exit(1);
	}
}

