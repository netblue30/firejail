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
#include <ftw.h>

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
	else if (!arg_shell_none && strcmp(cfg.shell,"/bin/csh") == 0) {
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
		if (is_link(src)) {
			fprintf(stderr, "Error: invalid .Xauthority file\n");
			exit(1);
		}
			
		int rv = copy_file(src, dest);
		if (rv) {
			fprintf(stderr, "Warning: cannot transfer .Xauthority in private home directory\n");
			return 0;
		}
		return 1; // file copied
	}
	
	return 0;
}

static int store_asoundrc(void) {
	// put a copy of .Xauthority in XAUTHORITY_FILE
	fs_build_mnt_dir();

	char *src;
	char *dest = RUN_ASOUNDRC_FILE;
	if (asprintf(&src, "%s/.asoundrc", cfg.homedir) == -1)
		errExit("asprintf");
	
	struct stat s;
	if (stat(src, &s) == 0) {
		if (is_link(src)) {
			// make sure the real path of the file is inside the home directory
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

		int rv = copy_file(src, dest);
		if (rv) {
			fprintf(stderr, "Warning: cannot transfer .asoundrc in private home directory\n");
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
	else {
		fs_logger2("clone", dest);
	
		// set permissions and ownership
		if (chown(dest, getuid(), getgid()) < 0)
			errExit("chown");
		if (chmod(dest, S_IRUSR | S_IWUSR) < 0)
			errExit("chmod");
	}
	
	// delete the temporary file
	unlink(src);
}

static void copy_asoundrc(void) {
	// copy XAUTHORITY_FILE in the new home directory
	char *src = RUN_ASOUNDRC_FILE ;
	char *dest;
	if (asprintf(&dest, "%s/.asoundrc", cfg.homedir) == -1)
		errExit("asprintf");
	int rv = copy_file(src, dest);
	if (rv)
		fprintf(stderr, "Warning: cannot transfer .asoundrc in private home directory\n");
	else {
		fs_logger2("clone", dest);
	
		// set permissions and ownership
		if (chown(dest, getuid(), getgid()) < 0)
			errExit("chown");
		if (chmod(dest, S_IRUSR | S_IWUSR) < 0)
			errExit("chmod");
	}

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
	if (mount(private_homedir, homedir, NULL, MS_NOSUID | MS_NODEV | MS_BIND | MS_REC, NULL) < 0)
		errExit("mount bind");
	fs_logger3("mount-bind", private_homedir, cfg.homedir);
	fs_logger2("whitelist", cfg.homedir);
// preserve mode and ownership
//	if (chown(homedir, s.st_uid, s.st_gid) == -1)
//		errExit("mount-bind chown");
//	if (chmod(homedir, s.st_mode) == -1)
//		errExit("mount-bind chmod");

	if (u != 0) {
		// mask /root
		if (arg_debug)
			printf("Mounting a new /root directory\n");
		if (mount("tmpfs", "/root", "tmpfs", MS_NOSUID | MS_NODEV | MS_NOEXEC | MS_STRICTATIME | MS_REC,  "mode=700,gid=0") < 0)
			errExit("mounting home directory");
		fs_logger("tmpfs /root");
	}
	else {
		// mask /home
		if (arg_debug)
			printf("Mounting a new /home directory\n");
		if (mount("tmpfs", "/home", "tmpfs", MS_NOSUID | MS_NODEV | MS_NOEXEC | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting home directory");
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

	// mask /home
	if (arg_debug)
		printf("Mounting a new /home directory\n");
	if (mount("tmpfs", "/home", "tmpfs", MS_NOSUID | MS_NODEV | MS_NOEXEC | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
		errExit("mounting home directory");
	fs_logger("tmpfs /home");

	// mask /root
	if (arg_debug)
		printf("Mounting a new /root directory\n");
	if (mount("tmpfs", "/root", "tmpfs", MS_NOSUID | MS_NODEV | MS_NOEXEC | MS_STRICTATIME | MS_REC,  "mode=700,gid=0") < 0)
		errExit("mounting root directory");
	fs_logger("tmpfs /root");

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

int fs_copydir(const char *path, const struct stat *st, int ftype, struct FTW *sftw);


int fs_copydir(const char *path, const struct stat *st, int ftype, struct FTW *sftw)
{
(void) st;
(void) sftw;
   char *homedir = cfg.homedir;
   char *dest;
	int  srcbaselen = 0;
   assert(homedir);
   uid_t u = getuid();
   gid_t g = getgid();
	srcbaselen = strlen(cfg.private_template);

   if(ftype == FTW_F || ftype == FTW_D) {
    	if (asprintf(&dest, "%s/%s", homedir, path + srcbaselen) == -1)
         errExit("asprintf");
      struct stat s;
      // don't copy it if we already have the file
      if (stat(dest, &s) == 0)
         return(0);
      if (stat(path, &s) == 0) {
         if(ftype == FTW_F) {
            if (copy_file(path, dest) == 0) {
               if (arg_debug)
                  printf("copy from %s to %s\n", path, dest);
               if (chown(dest, u, g) == -1)
                  errExit("chown");
               fs_logger2("clone", path);
            }
         }
         else if(ftype == FTW_D) {
            if (mkdir(dest, s.st_mode) == -1) 
               errExit("mkdir");
            if (chown(dest, u, g) < 0)
                errExit("chown");
            if (arg_debug)
               printf("copy from %s to %s\n", path, dest);
            fs_logger2("clone", path);
         }
      }
		free(dest);
   }
 	return(0);
}

void fs_private_template(void) {

	fs_private();
	if(nftw(cfg.private_template, fs_copydir, 1, FTW_PHYS) != 0) {
		fprintf(stderr, "Error: unable to copy template dir\n");
		exit(1);
	}

}

// check new private home directory (--private= option) - exit if it fails
void fs_check_private_dir(void) {
	EUID_ASSERT();
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

// check new template home directoty (--private-template= option) - exit if it fails
void fs_check_private_template(void) {
   EUID_ASSERT();
   invalid_filename(cfg.private_template);

   // Expand the home directory
   char *tmp = expand_home(cfg.private_template, cfg.homedir);
   cfg.private_template = realpath(tmp, NULL);
   free(tmp);

   if (!cfg.private_template
    || !is_dir(cfg.private_template)
    || is_link(cfg.private_template)
    || strstr(cfg.private_template, "..")) {
      fprintf(stderr, "Error: invalid private template directory\n");
      exit(1);
   }

   // check home directory and chroot home directory have the same owner
   struct stat s2;
   int rv = stat(cfg.private_template, &s2);
   if (rv < 0) {
      fprintf(stderr, "Error: cannot find %s directory\n", cfg.private_template);
      exit(1);
   }

   struct stat s1;
   rv = stat(cfg.homedir, &s1);
   if (rv < 0) {
      fprintf(stderr, "Error: cannot find %s directory, full path name required\n", cfg.homedir);
      exit(1);
   }
   if (s1.st_uid != s2.st_uid) {
      printf("Error: --private-template directory should be owned by the current user\n");
      exit(1);
   }
}


