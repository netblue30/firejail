/*
 * Copyright (C) 2014, 2015 Firejail Authors
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
		if (stat("/etc/skel/.zshrc", &s) == 0) {
			if (copy_file("/etc/skel/.zshrc", fname) == 0) {
				if (chown(fname, u, g) == -1)
					errExit("chown");
				fs_logger("clone /etc/skel/.zshrc");
			}
		}
		else { // 
			FILE *fp = fopen(fname, "w");
			if (fp) {
				fprintf(fp, "\n");
				fclose(fp);
				if (chown(fname, u, g) == -1)
					errExit("chown");
				if (chmod(fname, S_IRUSR | S_IWUSR) < 0)
					errExit("chown");
				fs_logger2("touch", fname);
			}
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
		if (stat("/etc/skel/.cshrc", &s) == 0) {
			if (copy_file("/etc/skel/.cshrc", fname) == 0) {
				if (chown(fname, u, g) == -1)
					errExit("chown");
				fs_logger("clone /etc/skel/.cshrc");
			}
		}
		else { // 
			/* coverity[toctou] */
			FILE *fp = fopen(fname, "w");
			if (fp) {
				fprintf(fp, "\n");
				fclose(fp);
				if (chown(fname, u, g) == -1)
					errExit("chown");
				if (chmod(fname, S_IRUSR | S_IWUSR) < 0)
					errExit("chown");
				fs_logger2("touch", fname);
			}
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
		if (stat("/etc/skel/.bashrc", &s) == 0) {
			if (copy_file("/etc/skel/.bashrc", fname) == 0) {
				/* coverity[toctou] */
				if (chown(fname, u, g) == -1)
					errExit("chown");
				fs_logger("clone /etc/skel/.bashrc");
			}
		}
		free(fname);
	}
}

static int store_xauthority(void) {
	// put a copy of .Xauthority in XAUTHORITY_FILE
	fs_build_mnt_dir();

	char *src;
	char *dest = RUN_XAUTHORITY_FILE;
	if (asprintf(&src, "%s/.Xauthority", cfg.homedir) == -1)
		errExit("asprintf");
	
	struct stat s;
	if (stat(src, &s) == 0) {	
		int rv = copy_file(src, dest);
		if (rv) {
			fprintf(stderr, "Warning: cannot transfer .Xauthority in private home directory\n");
			return 0;
		}
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
	int rv = copy_file(src, dest);
	if (rv)
		fprintf(stderr, "Warning: cannot transfer .Xauthority in private home directory\n");
	fs_logger2("clone", dest);

	// set permissions and ownership
	if (chown(dest, getuid(), getgid()) < 0)
		errExit("chown");
	if (chmod(dest, S_IRUSR | S_IWUSR) < 0)
		errExit("chmod");

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
}

static void check_dir_or_file(const char *name) {
	assert(name);
	struct stat s;
	
	invalid_filename(name);
	
	
	char *fname = expand_home(name, cfg.homedir);
	if (!fname) {
		fprintf(stderr, "Error: file %s not found.\n", name);
		exit(1);
	}
	if (fname[0] != '/') {
		// If it doesn't start with '/', it must be relative to homedir
		char* tmp;
		if (asprintf(&tmp, "%s/%s", cfg.homedir, fname) == -1)
			errExit("asprintf");
		free(fname);
		fname = tmp;
	}
	if (arg_debug)
		printf("Checking %s\n", fname);		
	if (stat(fname, &s) == -1) {
		fprintf(stderr, "Error: file %s not found.\n", fname);
		exit(1);
	}
	
	// check uid
	uid_t uid = getuid();
	gid_t gid = getgid();
	if (s.st_uid != uid || s.st_gid != gid) {
		fprintf(stderr, "Error: only files or directories created by the current user are allowed.\n");
		exit(1);
	}

	// dir or regular file
	if (S_ISDIR(s.st_mode) || S_ISREG(s.st_mode)) {
		free(fname);
		return;
	}

	if (!is_link(fname)) {
		free(fname);
		return;
	}
	
	fprintf(stderr, "Error: invalid file type, %s.\n", fname);
	exit(1);
}

// check directory list specified by user (--private-home option) - exit if it fails
void fs_check_home_list(void) {
	if (strstr(cfg.home_private_keep, "..")) {
		fprintf(stderr, "Error: invalid private-home list\n");
		exit(1);
	}
	
	char *dlist = strdup(cfg.home_private_keep);
	if (!dlist)
		errExit("strdup");

	char *ptr = strtok(dlist, ",");
	check_dir_or_file(ptr);
	while ((ptr = strtok(NULL, ",")) != NULL)
		check_dir_or_file(ptr);
	
	free(dlist);
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


static void duplicate(char *name) {
	char *cmd;
	
	char *fname = expand_home(name, cfg.homedir);
	if (!fname) {
		fprintf(stderr, "Error: file %s not found.\n", name);
		exit(1);
	}
	if (fname[0] != '/') {
		// If it doesn't start with '/', it must be relative to homedir
		char* tmp;
		if (asprintf(&tmp, "%s/%s", cfg.homedir, fname) == -1)
			errExit("asprintf");
		free(fname);
		fname = tmp;
	}

	// copy the file
	if (asprintf(&cmd, "%s -a --parents \"%s\" %s", RUN_CP_COMMAND, fname, RUN_HOME_DIR) == -1)
		errExit("asprintf");
	if (arg_debug)
		printf("%s\n", cmd);
	if (system(cmd))
		errExit("system cp -a --parents");
	fs_logger2("clone", fname);
	free(cmd);
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
	
	int xflag = store_xauthority();
	
	uid_t u = getuid();
	gid_t g = getgid();
	struct stat s;
	if (stat(homedir, &s) == -1) {
		fprintf(stderr, "Error: cannot find user home directory\n");
		exit(1);
	}

	// create /tmp/firejail/mnt/home directory
	fs_build_mnt_dir();
	int rv = mkdir(RUN_HOME_DIR, S_IRWXU | S_IRWXG | S_IRWXO);
	if (rv == -1)
		errExit("mkdir");
	if (chown(RUN_HOME_DIR, u, g) < 0)
		errExit("chown");
	if (chmod(RUN_HOME_DIR, 0755) < 0)
		errExit("chmod");

	
	// copy the list of files in the new home directory
	// using a new child process without root privileges
	fs_logger_print();	// save the current log
	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
		if (arg_debug)
			printf("Copying files in the new home:\n");
		
		// drop privileges
		if (setgroups(0, NULL) < 0)
			errExit("setgroups");
		if (setgid(getgid()) < 0)
			errExit("setgid/getgid");
		if (setuid(getuid()) < 0)
			errExit("setuid/getuid");
		
		// copy the list of files in the new home directory
		char *dlist = strdup(cfg.home_private_keep);
		if (!dlist)
			errExit("strdup");
		
		char *ptr = strtok(dlist, ",");
		duplicate(ptr);
	
		while ((ptr = strtok(NULL, ",")) != NULL)
			duplicate(ptr);
		free(dlist);	
		fs_logger_print();
		exit(0);
	}
	// wait for the child to finish
	waitpid(child, NULL, 0);

	// mount bind private_homedir on top of homedir
	char *newhome;
	if (asprintf(&newhome, "%s%s", RUN_HOME_DIR, cfg.homedir) == -1)
		errExit("asprintf");

	if (arg_debug)
		printf("Mount-bind %s on top of %s\n", newhome, homedir);
	if (mount(newhome, homedir, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
	fs_logger2("mount", homedir);
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

}

