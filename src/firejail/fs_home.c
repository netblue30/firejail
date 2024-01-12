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
#include "firejail.h"
#include <sys/mount.h>
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

static void disable_tab_completion(const char *homedir) {
	if (arg_tab)
		return;

	char *fname;
	if (asprintf(&fname, "%s/.inputrc", homedir) == -1)
		errExit("asprintf");

	// don't create a new one if we already have it
	if (access(fname, F_OK)) {
		FILE *fp = fopen(fname, "w");
		if (!fp)
			errExit("fopen");
		fprintf(fp, "set disable-completion on\n");
		fclose(fp);
		if (chmod(fname, 0644))
			errExit("chmod");
	}
	free(fname);
}


static void skel(const char *homedir) {
	EUID_ASSERT();
	char *fname;

	disable_tab_completion(homedir);

	// zsh
	if (strcmp(cfg.usershell,"/usr/bin/zsh") == 0 || strcmp(cfg.usershell,"/bin/zsh") == 0) {
		// copy skel files
		if (asprintf(&fname, "%s/.zshrc", homedir) == -1)
			errExit("asprintf");
		// don't copy it if we already have the file
		if (access(fname, F_OK) == 0)
			return;
		if (is_link(fname)) { // access(3) on dangling symlinks fails, try again using lstat
			fprintf(stderr, "Error: invalid %s file\n", fname);
			exit(1);
		}
		if (access("/etc/skel/.zshrc", R_OK) == 0) {
			copy_file_as_user("/etc/skel/.zshrc", fname, 0644); // regular user
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
	else if (strcmp(cfg.usershell,"/bin/csh") == 0) {
		// copy skel files
		if (asprintf(&fname, "%s/.cshrc", homedir) == -1)
			errExit("asprintf");
		// don't copy it if we already have the file
		if (access(fname, F_OK) == 0)
			return;
		if (is_link(fname)) { // access(3) on dangling symlinks fails, try again using lstat
			fprintf(stderr, "Error: invalid %s file\n", fname);
			exit(1);
		}
		if (access("/etc/skel/.cshrc", R_OK) == 0) {
			copy_file_as_user("/etc/skel/.cshrc", fname, 0644); // regular user
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
		// don't copy it if we already have the file
		if (access(fname, F_OK) == 0)
			return;
		if (is_link(fname)) { // access(3) on dangling symlinks fails, try again using lstat
			fprintf(stderr, "Error: invalid %s file\n", fname);
			exit(1);
		}
		if (access("/etc/skel/.bashrc", R_OK) == 0) {
			copy_file_as_user("/etc/skel/.bashrc", fname, 0644); // regular user
			fs_logger("clone /etc/skel/.bashrc");
			fs_logger2("clone", fname);
		}
		selinux_relabel_path(fname, fname);
		free(fname);
	}
}

static int store_xauthority(void) {
	EUID_ASSERT();
	if (arg_x11_block)
		return 0;

	// put a copy of .Xauthority in XAUTHORITY_FILE
	char *dest = RUN_XAUTHORITY_FILE;
	char *src;
	if (asprintf(&src, "%s/.Xauthority", cfg.homedir) == -1)
		errExit("asprintf");

	struct stat s;
	if (lstat(src, &s) == 0) {
		if (S_ISLNK(s.st_mode)) {
			fwarning("invalid .Xauthority file\n");
			free(src);
			return 0;
		}

		// create an empty file as root, and change ownership to user
		EUID_ROOT();
		FILE *fp = fopen(dest, "we");
		if (fp) {
			fprintf(fp, "\n");
			SET_PERMS_STREAM(fp, getuid(), getgid(), 0600);
			fclose(fp);
		}
		else
			errExit("fopen");
		EUID_USER();

		copy_file_as_user(src, dest, 0600); // regular user
		selinux_relabel_path(dest, src);
		fs_logger2("clone", dest);
		free(src);
		return 1; // file copied
	}

	free(src);
	return 0;
}

static int store_asoundrc(void) {
	EUID_ASSERT();
	if (arg_nosound)
		return 0;

	// put a copy of .asoundrc in ASOUNDRC_FILE
	char *dest = RUN_ASOUNDRC_FILE;
	char *src;
	if (asprintf(&src, "%s/.asoundrc", cfg.homedir) == -1)
		errExit("asprintf");

	struct stat s;
	if (stat(src, &s) == 0) {
		if (s.st_uid != getuid()) {
			fwarning(".asoundrc is not owned by the current user, skipping...\n");
			return 0;
		}

		// create an empty file as root, and change ownership to user
		EUID_ROOT();
		FILE *fp = fopen(dest, "we");
		if (fp) {
			fprintf(fp, "\n");
			SET_PERMS_STREAM(fp, getuid(), getgid(), 0644);
			fclose(fp);
		}
		else
			errExit("fopen");
		EUID_USER();

		copy_file_as_user(src, dest, 0644); // regular user
		fs_logger2("clone", dest);
		selinux_relabel_path(dest, src);
		free(src);
		return 1; // file copied
	}

	free(src);
	return 0;
}

static void copy_xauthority(void) {
	EUID_ASSERT();
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

	copy_file_as_user(src, dest, S_IRUSR | S_IWUSR); // regular user
	fs_logger2("clone", dest);
	selinux_relabel_path(dest, dest);
	free(dest);

	EUID_ROOT();
	unlink(src); // delete the temporary file
	EUID_USER();
}

static void copy_asoundrc(void) {
	EUID_ASSERT();
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

	copy_file_as_user(src, dest, S_IRUSR | S_IWUSR); // regular user
	fs_logger2("clone", dest);
	selinux_relabel_path(dest, dest);
	free(dest);

	EUID_ROOT();
	unlink(src); // delete the temporary file
	EUID_USER();
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
	EUID_ASSERT();

	uid_t u = getuid();
	// gid_t g = getgid();

	int xflag = store_xauthority();
	int aflag = store_asoundrc();

	// mount bind private_homedir on top of homedir
	if (arg_debug)
		printf("Mount-bind %s on top of %s\n", private_homedir, homedir);
	// get file descriptors for homedir and private_homedir, fails if there is any symlink
	int src = safer_openat(-1, private_homedir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (src == -1)
		errExit("opening private directory");
	int dst = safer_openat(-1, homedir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
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
	EUID_ROOT();
	if (bind_mount_by_fd(src, dst))
		errExit("mount bind");
	EUID_USER();

	// check /proc/self/mountinfo to confirm the mount is ok
	MountData *mptr = get_last_mount();
	size_t len = strlen(homedir);
	if (strncmp(mptr->dir, homedir, len) != 0 ||
	   (*(mptr->dir + len) != '\0' && *(mptr->dir + len) != '/'))
		errLogExit("invalid private mount");

	close(src);
	close(dst);
	fs_logger3("mount-bind", private_homedir, homedir);
	fs_logger2("whitelist", homedir);
// preserve mode and ownership
//	if (chown(homedir, s.st_uid, s.st_gid) == -1)
//		errExit("mount-bind chown");
//	if (chmod(homedir, s.st_mode) == -1)
//		errExit("mount-bind chmod");

	EUID_ROOT();
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
	EUID_USER();

	if (!arg_keep_shell_rc)
		skel(homedir);
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
	EUID_ASSERT();

	uid_t u = getuid();
	gid_t g = getgid();

	int xflag = store_xauthority();
	int aflag = store_asoundrc();

	EUID_ROOT();
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
	EUID_USER();

	if (u != 0) {
		if (!arg_allusers && strncmp(homedir, "/home/", 6) == 0) {
			// create new empty /home/user directory
			if (arg_debug)
				printf("Create a new user directory\n");
			EUID_ROOT();
			if (mkdir(homedir, S_IRWXU) == -1) {
				if (mkpath_as_root(homedir) == -1)
					errExit("mkpath");
				if (mkdir(homedir, S_IRWXU) == -1)
					errExit("mkdir");
			}
			if (chown(homedir, u, g) < 0)
				errExit("chown");
			EUID_USER();
			fs_logger2("mkdir", homedir);
			fs_logger2("tmpfs", homedir);
		}
		else
			// mask user home directory
			// the directory should be owned by the current user
			fs_tmpfs(homedir, 1);

		selinux_relabel_path(homedir, homedir);
	}

	if (!arg_keep_shell_rc)
		skel(homedir);
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
// for testing:
//    $ firejail --private --private-cwd=. --noprofile ls
//	issue #4780: exposes full home directory, not the --private one
//   $ firejail --private-cwd=.. --noprofile ls  -> error: full dir path required
//   $ firejail --private-cwd=/etc --noprofile ls  -> OK
//   $ firejail --private-cwd=FULL-SYMLINK-PATH  --noprofile ls  -> error: no symlinks
//   $ firejail --private --private-cwd="${HOME}" --noprofile ls -al  --> OK
//   $ firejail --private --private-cwd='${HOME}' --noprofile ls -al  --> OK
//   $ firejail --private-cwd  --> OK: should go in top of the home dir
//   profile with "private-cwd ${HOME}
void fs_check_private_cwd(const char *dir) {
	EUID_ASSERT();
	invalid_filename(dir, 0); // no globbing
	if (strcmp(dir, ".") == 0)
		goto errout;

	// Expand the working directory
	cfg.cwd = expand_macros(dir);

	// realpath/is_dir not used because path may not exist outside of jail
	if (strstr(cfg.cwd, "..") || *cfg.cwd != '/')
		goto errout;

	return;
errout:
	fprintf(stderr, "Error: invalid private working directory\n");
	exit(1);
}

//***********************************************************************************
// --private-home
//***********************************************************************************
static char *check_dir_or_file(const char *name) {
	EUID_ASSERT();
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
	EUID_ASSERT();
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
	char *homedir = cfg.homedir;
	char *private_list = cfg.home_private_keep;
	assert(homedir);
	assert(private_list);
	EUID_ASSERT();

	timetrace_start();

	uid_t uid = getuid();
	gid_t gid = getgid();

	int xflag = store_xauthority();
	int aflag = store_asoundrc();

	EUID_ROOT();
	// create /run/firejail/mnt/home directory
	mkdir_attr(RUN_HOME_DIR, 0755, uid, gid);
	selinux_relabel_path(RUN_HOME_DIR, homedir);

	// save the current log
	fs_logger_print();
	EUID_USER();

	// copy the list of files in the new home directory
	if (arg_debug)
		printf("Copying files in the new home:\n");
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

	int fd = safer_openat(-1, homedir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
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
	EUID_ROOT();
	if (bind_mount_path_to_fd(RUN_HOME_DIR, fd))
		errExit("mount bind");
	EUID_USER();
	close(fd);

	// check /proc/self/mountinfo to confirm the mount is ok
	MountData *mptr = get_last_mount();
	if (strcmp(mptr->dir, homedir) != 0 || strcmp(mptr->fstype, "tmpfs") != 0)
		errLogExit("invalid private-home mount");
	fs_logger2("tmpfs", homedir);

	EUID_ROOT();
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

	// mask RUN_HOME_DIR, it is writable and not noexec
	if (mount("tmpfs", RUN_HOME_DIR, "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
		errExit("mounting tmpfs");
	EUID_USER();

	if (!arg_keep_shell_rc)
		skel(homedir);
	if (xflag)
		copy_xauthority();
	if (aflag)
		copy_asoundrc();

	if (!arg_quiet)
		fprintf(stderr, "Home directory installed in %0.2f ms\n", timetrace_end());
}
