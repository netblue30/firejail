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
#include <sys/stat.h>
#include <linux/limits.h>
#include <fnmatch.h>
#include <glob.h>
#include <dirent.h>
#include <fcntl.h>
#include <errno.h>

static int mkpath(const char* path, mode_t mode) {
	assert(path && *path);
	
	// create directories with uid/gid as root or as current user if inside home directory
	uid_t uid = getuid();
	gid_t gid = getgid();
	if (strncmp(path, cfg.homedir, strlen(cfg.homedir)) != 0) {
		uid = 0;
		gid = 0;
	}

	// work on a copy of the path
	char *file_path = strdup(path);
	if (!file_path)
		errExit("strdup");

	char* p;
	for (p=strchr(file_path+1, '/'); p; p=strchr(p+1, '/')) {
		*p='\0';
		if (mkdir(file_path, mode)==-1) {
			if (errno != EEXIST) {
				*p='/';
				free(file_path);
				return -1;
			}
		}
		else {
			if (chmod(file_path, mode) == -1)
				errExit("chmod");
			if (chown(file_path, uid, gid) == -1)
				errExit("chown");
		}			

		*p='/';
	}
	
	free(file_path);
	return 0;
}

static void whitelist_path(ProfileEntry *entry) {
	assert(entry);
	char *path = entry->data + 10;
	assert(path);
	const char *fname;
	char *wfile = NULL;
	
	if (entry->home_dir) {
		fname = path + strlen(cfg.homedir);
		if (*fname == '\0') {
			fprintf(stderr, "Error: file %s is not in user home directory, exiting...\n", path);
			exit(1);
		}
	
		if (asprintf(&wfile, "%s/%s", WHITELIST_HOME_USER_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->tmp_dir) {
		fname = path + 4; // strlen("/tmp")
		if (*fname == '\0') {
			fprintf(stderr, "Error: file %s is not in /tmp directory, exiting...\n", path);
			exit(1);
		}
	
		if (asprintf(&wfile, "%s/%s", WHITELIST_TMP_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->media_dir) {
		fname = path + 6; // strlen("/media")
		if (*fname == '\0') {
			fprintf(stderr, "Error: file %s is not in /media directory, exiting...\n", path);
			exit(1);
		}
	
		if (asprintf(&wfile, "%s/%s", WHITELIST_MEDIA_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->var_dir) {
		fname = path + 4; // strlen("/var")
		if (*fname == '\0') {
			fprintf(stderr, "Error: file %s is not in /var directory, exiting...\n", path);
			exit(1);
		}
	
		if (asprintf(&wfile, "%s/%s", WHITELIST_VAR_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->dev_dir) {
		fname = path + 4; // strlen("/dev")
		if (*fname == '\0') {
			fprintf(stderr, "Error: file %s is not in /dev directory, exiting...\n", path);
			exit(1);
		}
	
		if (asprintf(&wfile, "%s/%s", WHITELIST_DEV_DIR, fname) == -1)
			errExit("asprintf");
	}

	// check if the file exists
	struct stat s;
	if (wfile && stat(wfile, &s) == 0) {
		if (arg_debug)
			printf("Whitelisting %s\n", path);
	}
	else {
		if (arg_debug) {
			fprintf(stderr, "Warning: %s is an invalid file, skipping...\n", path);
		}
		return;
	}
	
	// create the path if necessary
	mkpath(path, s.st_mode);

	// process directory
	if (S_ISDIR(s.st_mode)) {	
		// create directory
		int rv = mkdir(path, 0755);
		if (rv == -1)
			errExit("mkdir");
		
	}
	
	// process regular file
	else {
		// create an empty file
		FILE *fp = fopen(path, "w");
		if (!fp) {
			fprintf(stderr, "Error: cannot create empty file in home directory\n");
			exit(1);
		}
		fclose(fp);
	}
	
	// set file properties
	if (chown(path, s.st_uid, s.st_gid) < 0)
		errExit("chown");
	if (chmod(path, s.st_mode) < 0)
		errExit("chmod");

	// mount
	if (mount(wfile, path, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");

	free(wfile);
}


// whitelist for /home/user directory
void fs_whitelist(void) {
	char *homedir = cfg.homedir;
	assert(homedir);
	ProfileEntry *entry = cfg.profile;
	if (!entry)
		return;

	char *new_name = NULL;
	int home_dir = 0;	// /home/user directory flag
	int tmp_dir = 0;	// /tmp directory flag
	int media_dir = 0;	// /media directory flag
	int var_dir = 0;		// /var directory flag
	int dev_dir = 0;		// /dev directory flag

	// verify whitelist files, extract symbolic links, etc.
	while (entry) {
		// handle only whitelist commands
		if (strncmp(entry->data, "whitelist ", 10)) {
			entry = entry->next;
			continue;
		}

		// replace ~/ or ${HOME} into /home/username
		new_name = expand_home(entry->data + 10, cfg.homedir);
		assert(new_name);

		// extract the absolute path of the file
		// realpath function will fail with ENOENT if the file is not found
		char *fname = realpath(new_name, NULL);
		if (!fname) {
			// file not found, blank the entry in the list and continue
			if (arg_debug) {
				printf("Removed whitelist path: %s\n", entry->data);
				printf("\texpanded: %s\n", new_name);
				printf("\treal path: (null)\n");
				printf("\t");fflush(0);
				perror("realpath");
			}
			*entry->data = '\0';
			continue;
		}
		
		// valid path referenced to filesystem root
		if (*new_name != '/')
			goto errexit;

		// check for supported directories
		if (strncmp(new_name, cfg.homedir, strlen(cfg.homedir)) == 0) {
			// whitelisting home directory is disabled if --private or --private-home option is present
			if (arg_private) {
				if (arg_debug)
					printf("Removed whitelist path %s, --private option is present\n", entry->data);

				*entry->data = '\0';
				continue;
			}

			entry->home_dir = 1;
			home_dir = 1;
			// both path and absolute path are under /home
			if (strncmp(fname, cfg.homedir, strlen(cfg.homedir)) != 0)
				goto errexit;
		}
		else if (strncmp(new_name, "/tmp/", 5) == 0) {
			entry->tmp_dir = 1;
			tmp_dir = 1;
			// both path and absolute path are under /tmp
			if (strncmp(fname, "/tmp/", 5) != 0)
				goto errexit;
		}
		else if (strncmp(new_name, "/media/", 7) == 0) {
			entry->media_dir = 1;
			media_dir = 1;
			// both path and absolute path are under /media
			if (strncmp(fname, "/media/", 7) != 0)
				goto errexit;
		}
		else if (strncmp(new_name, "/var/", 5) == 0) {
			entry->var_dir = 1;
			var_dir = 1;
			// both path and absolute path are under /var
			if (strncmp(fname, "/var/", 5) != 0)
				goto errexit;
		}
		else if (strncmp(new_name, "/dev/", 5) == 0) {
			entry->dev_dir = 1;
			dev_dir = 1;
			// both path and absolute path are under /dev
			if (strncmp(fname, "/dev/", 5) != 0)
				goto errexit;
		}
		else
			goto errexit;

		// mark symbolic links
		if (is_link(new_name))
			entry->link = new_name;
		else
			free(new_name);

		// change file name in entry->data
		if (strcmp(fname, entry->data + 10) != 0) {
			char *newdata;
			if (asprintf(&newdata, "whitelist %s", fname) == -1)
				errExit("asprintf");
			entry->data = newdata;
			if (arg_debug)
				printf("Replaced whitelist path: %s\n", entry->data);
		}
		free(fname);
		entry = entry->next;
	}
		
	// create mount points
	fs_build_mnt_dir();
	

	// /home/user
	if (home_dir) {
		// keep a copy of real home dir in WHITELIST_HOME_USER_DIR
		int rv = mkdir(WHITELIST_HOME_USER_DIR, S_IRWXU | S_IRWXG | S_IRWXO);
		if (rv == -1)
			errExit("mkdir");
		if (chown(WHITELIST_HOME_USER_DIR, getuid(), getgid()) < 0)
			errExit("chown");
		if (chmod(WHITELIST_HOME_USER_DIR, 0755) < 0)
			errExit("chmod");
	
		if (mount(cfg.homedir, WHITELIST_HOME_USER_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount bind");
	
		// mount a tmpfs and initialize /home/user
		 fs_private();
	}
	
	// /tmp mountpoint
	if (tmp_dir) {
		// keep a copy of real /tmp directory in WHITELIST_TMP_DIR
		int rv = mkdir(WHITELIST_TMP_DIR, S_IRWXU | S_IRWXG | S_IRWXO);
		if (rv == -1)
			errExit("mkdir");
		if (chown(WHITELIST_TMP_DIR, 0, 0) < 0)
			errExit("chown");
		if (chmod(WHITELIST_TMP_DIR, 0777) < 0)
			errExit("chmod");
	
		if (mount("/tmp", WHITELIST_TMP_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount bind");
	
		// mount tmpfs on /tmp
		if (arg_debug)
			printf("Mounting tmpfs on /tmp directory\n");
		if (mount("tmpfs", "/tmp", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=777,gid=0") < 0)
			errExit("mounting tmpfs on /tmp");
	}
	
	// /media mountpoint
	if (media_dir) {
		// keep a copy of real /media directory in WHITELIST_MEDIA_DIR
		int rv = mkdir(WHITELIST_MEDIA_DIR, S_IRWXU | S_IRWXG | S_IRWXO);
		if (rv == -1)
			errExit("mkdir");
		if (chown(WHITELIST_MEDIA_DIR, 0, 0) < 0)
			errExit("chown");
		if (chmod(WHITELIST_MEDIA_DIR, 0755) < 0)
			errExit("chmod");
	
		if (mount("/media", WHITELIST_MEDIA_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount bind");
	
		// mount tmpfs on /media
		if (arg_debug)
			printf("Mounting tmpfs on /media directory\n");
		if (mount("tmpfs", "/media", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting tmpfs on /media");
	}

	// /media mountpoint
	if (var_dir) {
		// keep a copy of real /var directory in WHITELIST_VAR_DIR
		int rv = mkdir(WHITELIST_VAR_DIR, S_IRWXU | S_IRWXG | S_IRWXO);
		if (rv == -1)
			errExit("mkdir");
		if (chown(WHITELIST_VAR_DIR, 0, 0) < 0)
			errExit("chown");
		if (chmod(WHITELIST_VAR_DIR, 0755) < 0)
			errExit("chmod");
	
		if (mount("/var", WHITELIST_VAR_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount bind");
	
		// mount tmpfs on /var
		if (arg_debug)
			printf("Mounting tmpfs on /var directory\n");
		if (mount("tmpfs", "/var", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting tmpfs on /var");
	}

	// /dev mountpoint
	if (dev_dir) {
		// keep a copy of real /dev directory in WHITELIST_DEV_DIR
		int rv = mkdir(WHITELIST_DEV_DIR, S_IRWXU | S_IRWXG | S_IRWXO);
		if (rv == -1)
			errExit("mkdir");
		if (chown(WHITELIST_DEV_DIR, 0, 0) < 0)
			errExit("chown");
		if (chmod(WHITELIST_DEV_DIR, 0755) < 0)
			errExit("chmod");
	
		if (mount("/dev", WHITELIST_DEV_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount bind");
	
		// mount tmpfs on /var
		if (arg_debug)
			printf("Mounting tmpfs on /dev directory\n");
		if (mount("tmpfs", "/dev", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting tmpfs on /dev");
	}

	// go through profile rules again, and interpret whitelist commands
	entry = cfg.profile;
	while (entry) {
		// handle only whitelist commands
		if (strncmp(entry->data, "whitelist ", 10)) {
			entry = entry->next;
			continue;
		}

//printf("here %d#%s#\n", __LINE__, entry->data);
		// whitelist the real file
		whitelist_path(entry);

		// create the link if any
		if (entry->link) {
			// if the link is already there, do not bother
			struct stat s;
			if (stat(entry->link, &s) != 0) {
				// create the path if necessary
				mkpath(entry->link, s.st_mode);

				int rv = symlink(entry->data + 10, entry->link);
				if (rv)
					fprintf(stderr, "Warning cannot create symbolic link %s\n", entry->link);
				else if (arg_debug)
					printf("Created symbolic link %s -> %s\n", entry->link, entry->data + 10);
			}
		}

		entry = entry->next;
	}

	// mask the real home directory, currently mounted on WHITELIST_HOME_DIR
	if (home_dir) {
		if (mount("tmpfs", WHITELIST_HOME_USER_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mount tmpfs");
	}
	
	// mask the real /tmp directory, currently mounted on WHITELIST_TMP_DIR
	if (tmp_dir) {
		if (mount("tmpfs", WHITELIST_TMP_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mount tmpfs");
	}

	return;

errexit:
	fprintf(stderr, "Error: invalid whitelist path %s\n", new_name);
	exit(1);
}
