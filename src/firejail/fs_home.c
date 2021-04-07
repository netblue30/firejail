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
#include "firejail.h"
#include <sys/mount.h>
#include <linux/limits.h>
#include <dirent.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <grp.h>
//#include <ftw.h>

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif

static void skel(const char *homedir, uid_t u, gid_t g) {
	char *fname;

	// zsh
	if (!arg_shell_none && (strcmp(cfg.shell,"/usr/bin/zsh") == 0 || strcmp(cfg.shell,"/bin/zsh") == 0)) {
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
			fs_logger2("clone", fname);
		}
		else {
			touch_file_as_user(fname, 0644);
			fs_logger2("touch", fname);
		}
		selinux_relabel_path(fname, fname);
		free(fname);
	}
	// csh
	else if (!arg_shell_none && strcmp(cfg.shell,"/bin/csh") == 0) {
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
			fs_logger2("clone", fname);
		}
		else {
			touch_file_as_user(fname, 0644);
			fs_logger2("touch", fname);
		}
		selinux_relabel_path(fname, fname);
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
			fs_logger2("clone", fname);
		}
		selinux_relabel_path(fname, fname);
		free(fname);
	}
}

static int store_xauthority(void) {
	if (arg_x11_block)
		return 0;

	// put a copy of .Xauthority in XAUTHORITY_FILE
	char *dest = RUN_XAUTHORITY_FILE;
	char *src;
	if (asprintf(&src, "%s/.Xauthority", cfg.homedir) == -1)
		errExit("asprintf");

	struct stat s;
	if (stat(src, &s) == 0) {
		if (is_link(src)) {
			fwarning("invalid .Xauthority file\n");
			free(src);
			return 0;
		}

		// create an empty file as root, and change ownership to user
		FILE *fp = fopen(dest, "w");
		if (fp) {
			fprintf(fp, "\n");
			SET_PERMS_STREAM(fp, getuid(), getgid(), 0600);
			fclose(fp);
		}
		else
			errExit("fopen");

		copy_file_as_user(src, dest, getuid(), getgid(), 0600); // regular user
		fs_logger2("clone", dest);
		selinux_relabel_path(dest, src);
		free(src);
		return 1; // file copied
	}

	free(src);
	return 0;
}

static int store_asoundrc(void) {
	if (arg_nosound)
		return 0;

	// put a copy of .asoundrc in ASOUNDRC_FILE
	char *dest = RUN_ASOUNDRC_FILE;
	char *src;
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
			if (strncmp(rp, cfg.homedir, strlen(cfg.homedir)) != 0 || rp[strlen(cfg.homedir)] != '/') {
				fprintf(stderr, "Error: .asoundrc is a symbolic link pointing to a file outside home directory\n");
				exit(1);
			}
			free(rp);
		}

		// create an empty file as root, and change ownership to user
		FILE *fp = fopen(dest, "w");
		if (fp) {
			fprintf(fp, "\n");
			SET_PERMS_STREAM(fp, getuid(), getgid(), 0644);
			fclose(fp);
		}
		else
			errExit("fopen");

		copy_file_as_user(src, dest, getuid(), getgid(), 0644); // regular user
		selinux_relabel_path(dest, src);
		fs_logger2("clone", dest);
		free(src);
		return 1; // file copied
	}

	free(src);
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
	selinux_relabel_path(dest, src);
	fs_logger2("clone", dest);
	free(dest);

	// delete the temporary file
	unlink(src);
}

static void copy_asoundrc(void) {
	// copy ASOUNDRC_FILE in the new home directory
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
	free(dest);

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

	// mount bind private_homedir on top of homedir
	if (arg_debug)
		printf("Mount-bind %s on top of %s\n", private_homedir, homedir);
	// get file descriptors for homedir and private_homedir, fails if there is any symlink
	int src = safe_fd(private_homedir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (src == -1)
		errExit("opening private directory");
	int dst = safe_fd(homedir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (dst == -1)
		errExit("opening home directory");
	// both mount source and target should be owned by the user
	struct stat s;
	if (fstat(src, &s) == -1)
		errExit("fstat");
	if (s.st_uid != u) {
		fprintf(stderr, "Error: private directory is not owned by the current user\n");
		exit(1);
	}
	if ((S_IRWXU & s.st_mode) != S_IRWXU)
		fwarning("no full permissions on private directory\n");
	if (fstat(dst, &s) == -1)
		errExit("fstat");
	if (s.st_uid != u) {
		fprintf(stderr, "Error: cannot mount private directory:\n"
			"Home directory is not owned by the current user\n");
		exit(1);
	}
	// mount via the links in /proc/self/fd
	char *proc_src, *proc_dst;
	if (asprintf(&proc_src, "/proc/self/fd/%d", src) == -1)
		errExit("asprintf");
	if (asprintf(&proc_dst, "/proc/self/fd/%d", dst) == -1)
		errExit("asprintf");
	if (mount(proc_src, proc_dst, NULL, MS_NOSUID | MS_NODEV | MS_BIND | MS_REC, NULL) < 0)
		errExit("mount bind");
	free(proc_src);
	free(proc_dst);
	close(src);
	close(dst);
	// check /proc/self/mountinfo to confirm the mount is ok
	MountData *mptr = get_last_mount();
	size_t len = strlen(homedir);
	if (strncmp(mptr->dir, homedir, len) != 0 ||
	   (*(mptr->dir + len) != '\0' && *(mptr->dir + len) != '/'))
		errLogExit("invalid private mount");

	fs_logger3("mount-bind", private_homedir, homedir);
	fs_logger2("whitelist", homedir);
// preserve mode and ownership
//	if (chown(homedir, s.st_uid, s.st_gid) == -1)
//		errExit("mount-bind chown");
//	if (chmod(homedir, s.st_mode) == -1)
//		errExit("mount-bind chmod");

	if (u != 0) {
		// mask /root
		if (arg_debug)
			printf("Mounting a new /root directory\n");
		if (mount("tmpfs", "/root", "tmpfs", MS_NOSUID | MS_NODEV | MS_NOEXEC | MS_STRICTATIME,  "mode=700,gid=0") < 0)
			errExit("mounting /root directory");
		selinux_relabel_path("/root", "/root");
		fs_logger("tmpfs /root");
	}
	if (u == 0 && !arg_allusers) {
		// mask /home
		if (arg_debug)
			printf("Mounting a new /home directory\n");
		if (mount("tmpfs", "/home", "tmpfs", MS_NOSUID | MS_NODEV | MS_NOEXEC | MS_STRICTATIME,  "mode=755,gid=0") < 0)
			errExit("mounting /home directory");
		selinux_relabel_path("/home", "/home");
		fs_logger("tmpfs /home");
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

	// mask /root
	if (arg_debug)
		printf("Mounting a new /root directory\n");
	if (mount("tmpfs", "/root", "tmpfs", MS_NOSUID | MS_NODEV | MS_NOEXEC | MS_STRICTATIME,  "mode=700,gid=0") < 0)
		errExit("mounting /root directory");
	selinux_relabel_path("/root", "/root");
	fs_logger("tmpfs /root");

	// mask /home
	if (!arg_allusers) {
		if (arg_debug)
			printf("Mounting a new /home directory\n");
		if (mount("tmpfs", "/home", "tmpfs", MS_NOSUID | MS_NODEV | MS_NOEXEC | MS_STRICTATIME,  "mode=755,gid=0") < 0)
			errExit("mounting /home directory");
		selinux_relabel_path("/home", "/home");
		fs_logger("tmpfs /home");
	}

	if (u != 0) {
		if (!arg_allusers && strncmp(homedir, "/home/", 6) == 0) {
			// create new empty /home/user directory
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
			fs_logger2("tmpfs", homedir);
		}
		else
			// mask user home directory
			// the directory should be owned by the current user
			fs_tmpfs(homedir, 1);

		selinux_relabel_path(homedir, homedir);
	}

	skel(homedir, u, g);
	if (xflag)
		copy_xauthority();
	if (aflag)
		copy_asoundrc();
}

// check new private home directory (--private= option) - exit if it fails
void fs_check_private_dir(void) {
	EUID_ASSERT();
	invalid_filename(cfg.home_private, 0); // no globbing

	// Expand the home directory
	char *tmp = expand_macros(cfg.home_private);
	cfg.home_private = realpath(tmp, NULL);
	free(tmp);

	if (!cfg.home_private
	 || !is_dir(cfg.home_private)) {
		fprintf(stderr, "Error: invalid private directory\n");
		exit(1);
	}
}

// check new private working directory (--private-cwd= option) - exit if it fails
void fs_check_private_cwd(const char *dir) {
	EUID_ASSERT();
	invalid_filename(dir, 0); // no globbing

	// Expand the working directory
	cfg.cwd = expand_macros(dir);

	// realpath/is_dir not used because path may not exist outside of jail
	if (strstr(cfg.cwd, "..")) {
		fprintf(stderr, "Error: invalid private working directory\n");
		exit(1);
	}
}

//***********************************************************************************
// --private-home
//***********************************************************************************
static char *check_dir_or_file(const char *name) {
	assert(name);

	// basic checks
	invalid_filename(name, 0); // no globbing
	if (arg_debug)
		printf("Private home: checking %s\n", name);

	// expand home directory
	char *fname = expand_macros(name);
	assert(fname);

	// If it doesn't start with '/', it must be relative to homedir
	if (fname[0] != '/') {
		char* tmp;
		if (asprintf(&tmp, "%s/%s", cfg.homedir, fname) == -1)
			errExit("asprintf");
		free(fname);
		fname = tmp;
	}

	// we allow only files in user home directory or symbolic links to files or directories owned by the user
	struct stat s;
	if (lstat(fname, &s) == 0 && S_ISLNK(s.st_mode)) {
		if (strncmp(fname, cfg.homedir, strlen(cfg.homedir)) != 0 || fname[strlen(cfg.homedir)] != '/')
			goto errexit;
		if (stat(fname, &s) == 0) {
			if (s.st_uid != getuid()) {
				fprintf(stderr, "Error: symbolic link %s to file or directory not owned by the user\n", fname);
				exit(1);
			}
			return fname;
		}
		else // dangling link
			goto errexit;
	}
	else {
		// check the file is in user home directory
		char *rname = realpath(fname, NULL);
		if (!rname || strncmp(rname, cfg.homedir, strlen(cfg.homedir)) != 0)
			goto errexit;
		// a full home directory is not allowed
		char *ptr = rname + strlen(cfg.homedir);
		if (*ptr != '/')
			goto errexit;
		// only top files and directories in user home are allowed
		ptr = strchr(++ptr, '/');
		if (ptr) {
			fprintf(stderr, "Error: only top files and directories in user home are allowed\n");
			exit(1);
		}
		free(fname);
		return rname;
	}

errexit:
	fprintf(stderr, "Error: invalid file %s\n", name);
	exit(1);
}

static void duplicate(char *name) {
	char *fname = check_dir_or_file(name);

	if (arg_debug)
		printf("Private home: duplicating %s\n", fname);
	assert(strncmp(fname, cfg.homedir, strlen(cfg.homedir)) == 0);

	struct stat s;
	if (lstat(fname, &s) == -1) {
		free(fname);
		return;
	}
	else if (S_ISDIR(s.st_mode)) {
		// create the directory in RUN_HOME_DIR
		char *path;
		char *ptr = strrchr(fname, '/');
		ptr++;
		if (asprintf(&path, "%s/%s", RUN_HOME_DIR, ptr) == -1)
			errExit("asprintf");
		create_empty_dir_as_user(path, 0755);
		sbox_run(SBOX_USER| SBOX_CAPS_NONE | SBOX_SECCOMP, 3, PATH_FCOPY, fname, path);
		free(path);
	}
	else
		sbox_run(SBOX_USER| SBOX_CAPS_NONE | SBOX_SECCOMP, 3, PATH_FCOPY, fname, RUN_HOME_DIR);
	fs_logger2("clone", fname);
	fs_logger_print();	// save the current log

	free(fname);
}

// private mode (--private-home=list):
// 	mount homedir on top of /home/user,
// 	tmpfs on top of  /root in nonroot mode,
// 	tmpfs on top of /tmp in root mode,
// 	set skel files,
// 	restore .Xauthority
void fs_private_home_list(void) {
	timetrace_start();

	char *homedir = cfg.homedir;
	char *private_list = cfg.home_private_keep;
	assert(homedir);
	assert(private_list);

	int xflag = store_xauthority();
	int aflag = store_asoundrc();

	uid_t uid = getuid();
	gid_t gid = getgid();

	// create /run/firejail/mnt/home directory
	mkdir_attr(RUN_HOME_DIR, 0755, uid, gid);
	selinux_relabel_path(RUN_HOME_DIR, homedir);
	fs_logger_print();	// save the current log

	if (arg_debug)
		printf("Copying files in the new home:\n");

	// copy the list of files in the new home directory
	char *dlist = strdup(cfg.home_private_keep);
	if (!dlist)
		errExit("strdup");

	char *ptr = strtok(dlist, ",");
	if (!ptr) {
		fprintf(stderr, "Error: invalid private-home argument\n");
		exit(1);
	}
	duplicate(ptr);
	while ((ptr = strtok(NULL, ",")) != NULL)
		duplicate(ptr);

	fs_logger_print();	// save the current log
	free(dlist);

	if (arg_debug)
		printf("Mount-bind %s on top of %s\n", RUN_HOME_DIR, homedir);

	int fd = safe_fd(homedir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1)
		errExit("opening home directory");
	// home directory should be owned by the user
	struct stat s;
	if (fstat(fd, &s) == -1)
		errExit("fstat");
	if (s.st_uid != uid) {
		fprintf(stderr, "Error: cannot mount private directory:\n"
			"Home directory is not owned by the current user\n");
		exit(1);
	}
	// mount using the file descriptor
	char *proc;
	if (asprintf(&proc, "/proc/self/fd/%d", fd) == -1)
		errExit("asprintf");
	if (mount(RUN_HOME_DIR, proc, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
	free(proc);
	close(fd);
	// check /proc/self/mountinfo to confirm the mount is ok
	MountData *mptr = get_last_mount();
	if (strcmp(mptr->dir, homedir) != 0 || strcmp(mptr->fstype, "tmpfs") != 0)
		errLogExit("invalid private-home mount");
	fs_logger2("tmpfs", homedir);

	// mask RUN_HOME_DIR, it is writable and not noexec
	if (mount("tmpfs", RUN_HOME_DIR, "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
		errExit("mounting tmpfs");
	fs_logger2("tmpfs", RUN_HOME_DIR);

	if (uid != 0) {
		// mask /root
		if (arg_debug)
			printf("Mounting a new /root directory\n");
		if (mount("tmpfs", "/root", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME,  "mode=700,gid=0") < 0)
			errExit("mounting /root directory");
		selinux_relabel_path("/root", "/root");
		fs_logger("tmpfs /root");
	}
	if (uid == 0 && !arg_allusers) {
		// mask /home
		if (arg_debug)
			printf("Mounting a new /home directory\n");
		if (mount("tmpfs", "/home", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
			errExit("mounting /home directory");
		selinux_relabel_path("/home", "/home");
		fs_logger("tmpfs /home");
	}

	skel(homedir, uid, gid);
	if (xflag)
		copy_xauthority();
	if (aflag)
		copy_asoundrc();

	if (!arg_quiet)
		fprintf(stderr, "Home directory installed in %0.2f ms\n", timetrace_end());
}
