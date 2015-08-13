/*
 * Copyright (C) 2014, 2015 netblue30 (netblue30@yahoo.com)
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
			}
		}
		free(fname);
	}
}

static int store_xauthority(void) {
	// put a copy of .Xauthority in MNT_DIR
	fs_build_mnt_dir();

	char *src;
	char *dest;
	if (asprintf(&src, "%s/.Xauthority", cfg.homedir) == -1)
		errExit("asprintf");
	if (asprintf(&dest, "%s/.Xauthority", MNT_DIR) == -1)
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
	// put a copy of .Xauthority in MNT_DIR
	fs_build_mnt_dir();

	char *src;
	char *dest;
	if (asprintf(&dest, "%s/.Xauthority", cfg.homedir) == -1)
		errExit("asprintf");
	if (asprintf(&src, "%s/.Xauthority", MNT_DIR) == -1)
		errExit("asprintf");
	int rv = copy_file(src, dest);
	if (rv)
		fprintf(stderr, "Warning: cannot transfer .Xauthority in private home directory\n");

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
// 	tmpfs on top of /tmp in root mode,
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
	}
	else {
		// mask /home
		if (arg_debug)
			printf("Mounting a new /home directory\n");
		if (mount("tmpfs", "/home", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting home directory");

		// mask /tmp only in root mode; KDE keeps all kind of sockets in /tmp!
		if (arg_debug)
			printf("Mounting a new /tmp directory\n");
		if (mount("tmpfs", "/tmp", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME | MS_REC,  "mode=777,gid=0") < 0)
			errExit("mounting tmp directory");
	}
	

	skel(homedir, u, g);
	if (xflag)
		copy_xauthority();
}

// private mode (--private):
//	mount tmpfs over /home/user,
// 	tmpfs on top of  /root in nonroot mode,
// 	tmpfs on top of /tmp in root mode
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

	// mask /root
	if (arg_debug)
		printf("Mounting a new /root directory\n");
	if (mount("tmpfs", "/root", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME | MS_REC,  "mode=700,gid=0") < 0)
		errExit("mounting home directory");

	if (u != 0) {
		// create /home/user
		if (arg_debug)
			printf("Create a new user directory\n");
		int rv = mkdir(homedir, S_IRWXU);
		if (rv == -1)
			errExit("mkdir");
		if (chown(homedir, u, g) < 0)
			errExit("chown");
	}
	else {
		// mask tmp only in root mode; KDE keeps all kind of sockets in /tmp!
		if (arg_debug)
			printf("Mounting a new /tmp directory\n");
		if (mount("tmpfs", "/tmp", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME | MS_REC,  "mode=777,gid=0") < 0)
			errExit("mounting tmp directory");
	}
	
	skel(homedir, u, g);
	if (xflag)
		copy_xauthority();
}

static void check_dir_or_file(const char *name) {
	assert(name);
	struct stat s;
	char *fname;
	if (asprintf(&fname, "%s/%s", cfg.homedir, name) == -1)
		errExit("asprintf");
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
	// if the directory starts with ~, expand the home directory
	if (*cfg.home_private == '~') {
		char *tmp;
		if (asprintf(&tmp, "%s%s", cfg.homedir, cfg.home_private + 1) == -1)
			errExit("asprintf");
		cfg.home_private = tmp;
	}
	
	if (!is_dir(cfg.home_private) || is_link(cfg.home_private) || strstr(cfg.home_private, "..")) {
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
		printf("Error: the two home directories must have the same owner\n");
		exit(1);
	}
}

#if 0
static int mkpath(char* file_path, mode_t mode) {
	assert(file_path && *file_path);
	char* p;
	for (p=strchr(file_path+1, '/'); p; p=strchr(p+1, '/')) {
		*p='\0';
		if (mkdir(file_path, mode)==-1) {
			if (errno!=EEXIST) { *p='/'; return -1; }
		}
		*p='/';
	}
	return 0;
}
#endif

static void duplicate(char *fname) {
	char *cmd;

	// copy the file
	if (asprintf(&cmd, "cp -a --parents %s/%s %s", cfg.homedir, fname, HOME_DIR) == -1)
		errExit("asprintf");
	if (arg_debug)
		printf("%s\n", cmd);
	if (system(cmd))
		errExit("system cp -a --parents");
	free(cmd);
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
	int rv = mkdir(HOME_DIR, S_IRWXU | S_IRWXG | S_IRWXO);
	if (rv == -1)
		errExit("mkdir");
	if (chown(HOME_DIR, u, g) < 0)
		errExit("chown");
	if (chmod(HOME_DIR, 0755) < 0)
		errExit("chmod");
	
	// copy the list of files in the new home directory
	// using a new child process without root privileges
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
		exit(0);
	}
	// wait for the child to finish
	waitpid(child, NULL, 0);

	// mount bind private_homedir on top of homedir
	char *newhome;
	if (asprintf(&newhome, "%s%s", HOME_DIR, cfg.homedir) == -1)
		errExit("asprintf");

	if (arg_debug)
		printf("Mount-bind %s on top of %s\n", newhome, homedir);
	if (mount(newhome, homedir, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
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
	}
	else {
		// mask /home
		if (arg_debug)
			printf("Mounting a new /home directory\n");
		if (mount("tmpfs", "/home", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting home directory");

		// mask /tmp only in root mode; KDE keeps all kind of sockets in /tmp!
		if (arg_debug)
			printf("Mounting a new /tmp directory\n");
		if (mount("tmpfs", "/tmp", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME | MS_REC,  "mode=777,gid=0") < 0)
			errExit("mounting tmp directory");
	}

	skel(homedir, u, g);
	if (xflag)
		copy_xauthority();

}

