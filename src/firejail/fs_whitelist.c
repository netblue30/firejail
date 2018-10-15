/*
 * Copyright (C) 2014-2018 Firejail Authors
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

// mountinfo functionality test;
// 1. enable TEST_MOUNTINFO definition
// 2. run firejail --whitelist=/any/directory
//#define TEST_MOUNTINFO

#define EMPTY_STRING ("")
#define MAXBUF 4098


static int mkpath(const char* path, mode_t mode) {
	assert(path && *path);
	mode |= 0111;

	// create directories with uid/gid as root or as current user if inside home directory
	int userhome = 0;
	if (strncmp(path, cfg.homedir, strlen(cfg.homedir)) == 0) {
		EUID_USER();
		userhome = 1;
	}

	// work on a copy of the path
	char *dup = strdup(path);
	if (!dup)
		errExit("strdup");

	// don't create the last path element
	char *p = strrchr(dup, '/');
	assert(p);
	*p = '\0';

	int parentfd = open("/", O_PATH|O_DIRECTORY|O_CLOEXEC);
	if (parentfd == -1)
		errExit("open");

	// traverse the path, return -1 if a symlink is encountered
	int done = 0;
	int fd = -1;
	char *tok = strtok(dup, "/");
	assert(tok); // path is no top level directory
	while (tok) {
		// skip all instances of "/./"
		if (strcmp(tok, ".") == 0) {
			tok = strtok(NULL, "/");
			continue;
		}
		// create the directory if necessary
		if (mkdirat(parentfd, tok, mode) == -1) {
			if (errno != EEXIST) {
				if (arg_debug || arg_debug_whitelists)
					perror("mkdir");
				close(parentfd);
				free(dup);
				if (userhome) {
					EUID_ROOT();
				}
				return -1;
			}
		}
		else
			done = 1;
		// open the directory
		fd = openat(parentfd, tok, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
		if (fd == -1) {
			if (arg_debug || arg_debug_whitelists)
				perror("open");
			close(parentfd);
			free(dup);
			if (userhome) {
				EUID_ROOT();
			}
			return -1;
		}
		// move on to next path segment
		close(parentfd);
		parentfd = fd;
		tok = strtok(NULL, "/");
	}

	if (done)
		fs_logger2("mkpath", path);

	free(dup);
	if (userhome) {
		EUID_ROOT();
	}
	return fd;
}

static void whitelist_path(ProfileEntry *entry) {
	assert(entry);
	const char *path = entry->data + 10;
	assert(path);
	const char *fname;
	char *wfile = NULL;

	if (entry->home_dir) {
		if (strncmp(path, cfg.homedir, strlen(cfg.homedir)) != 0 || path[strlen(cfg.homedir)] != '/')
			// either symlink pointing outside home directory
			// or entire home directory, skip the mount
			return;

		fname = path + strlen(cfg.homedir) + 1; // strlen("/home/user/")

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_HOME_USER_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->tmp_dir) {
		fname = path + 5; // strlen("/tmp/")

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_TMP_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->media_dir) {
		fname = path + 7; // strlen("/media/")

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_MEDIA_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->mnt_dir) {
		fname = path + 5; // strlen("/mnt/")

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_MNT_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->var_dir) {
		if (strncmp(path, "/var/", 5) != 0)
			// symlink pointing outside /var, skip the mount
			return;

		fname = path + 5; // strlen("/var/")

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_VAR_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->dev_dir) {
		if (strncmp(path, "/dev/", 5) != 0)
			// symlink pointing outside /dev, skip the mount
			return;

		fname = path + 5; // strlen("/dev/")

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_DEV_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->opt_dir) {
		fname = path + 5; // strlen("/opt/")

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_OPT_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->srv_dir) {
		fname = path + 5; // strlen("/srv/")

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_SRV_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->etc_dir) {
		if (strncmp(path, "/etc/", 5) != 0)
			// symlink pointing outside /etc, skip the mount
			return;

		fname = path + 5; // strlen("/etc/")

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_ETC_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->share_dir) {
		fname = path + 11; // strlen("/usr/share/")

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_SHARE_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->module_dir) {
		fname = path + 12; // strlen("/sys/module/")

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_MODULE_DIR, fname) == -1)
			errExit("asprintf");
	}
	assert(wfile);

	if (arg_debug || arg_debug_whitelists)
		printf("Whitelisting %s\n", path);

	// confirm again the mount source exists and there is no symlink
	struct stat wfilestat;
	EUID_USER();
	int fd = safe_fd(wfile, O_PATH|O_NOFOLLOW|O_CLOEXEC);
	EUID_ROOT();
	if (fd == -1) {
		if (arg_debug || arg_debug_whitelists)
			printf("Debug %d: skip whitelisting of %s\n", __LINE__, path);
		free(wfile);
		return;
	}
	if (fstat(fd, &wfilestat) == -1)
		errExit("fstat");
	close(fd);
	if (S_ISLNK(wfilestat.st_mode)) {
		if (arg_debug || arg_debug_whitelists)
			printf("Debug %d: skip whitelisting of %s\n", __LINE__, path);
		free(wfile);
		return;
	}

#ifdef TEST_MOUNTINFO
	printf("TEST_MOUNTINFO\n");
	path = "/etc/.";
#endif

	// create path of the mount target if necessary
	int fd2 = mkpath(path, 0755);
	if (fd2 == -1) {
		// something went wrong during path creation or a symlink was found;
		// if there is a symlink somewhere in the path of the mount target,
		// assume the file is whitelisted already
		if (arg_debug || arg_debug_whitelists)
			printf("Debug %d: skip whitelisting of %s\n", __LINE__, path);
		free(wfile);
		return;
	}

	// get file name of the mount target
	const char *file = gnu_basename(path);

	// create the mount target if necessary and open it, a symlink is rejected
	int fd3 = -1;
	if (S_ISDIR(wfilestat.st_mode)) {
		// directory foo can exist already:
		// firejail --whitelist=/foo/bar --whitelist=/foo
		if (mkdirat(fd2, file, 0755) == -1 && errno != EEXIST) {
			if (arg_debug || arg_debug_whitelists) {
				perror("mkdir");
				printf("Debug %d: skip whitelisting of %s\n", __LINE__, path);
			}
			close(fd2);
			free(wfile);
			return;
		}
		fd3 = openat(fd2, file, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	}
	else {
		// create an empty file, fails with EEXIST if it is whitelisted already:
		// firejail --whitelist=/foo --whitelist=/foo/bar
		fd3 = openat(fd2, file, O_RDONLY|O_CREAT|O_EXCL|O_CLOEXEC, S_IRUSR|S_IWUSR);
	}

	if (fd3 == -1) {
		if (arg_debug || arg_debug_whitelists) {
			if (errno != EEXIST) {
				perror("open");
				printf("Debug %d: skip whitelisting of %s\n", __LINE__, path);
			}
		}
		close(fd2);
		free(wfile);
		return;
	}
	close(fd2);

	fs_logger2("whitelist", path);

	// mount via the link in /proc/self/fd
	char *proc;
	if (asprintf(&proc, "/proc/self/fd/%d", fd3) == -1)
		errExit("asprintf");
	if (mount(wfile, proc, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
	free(proc);
	close(fd3);

	// check the last mount operation
	MountData *mptr = get_last_mount(); // will do exit(1) if the mount cannot be found

	// confirm the file was mounted on the right target
	// strcmp does not work here, because mptr->dir can be a child mount
	if (strncmp(mptr->dir, path, strlen(path)) != 0)
		errLogExit("invalid whitelist mount");
	// No mounts are allowed on top level directories. A destination such as "/etc" is very bad!
	//  - there should be more than one '/' char in dest string
	if (mptr->dir == strrchr(mptr->dir, '/'))
		errLogExit("invalid whitelist mount");
	// confirm the right file was mounted
	int fd4 = safe_fd(path, O_PATH|O_NOFOLLOW|O_CLOEXEC);
	if (fd4 == -1)
		errExit("safe_fd");
	struct stat s;
	if (fstat(fd4, &s) == -1)
		errExit("fstat");
	if (s.st_dev != wfilestat.st_dev || s.st_ino != wfilestat.st_ino)
		errLogExit("invalid whitelist mount");
	close(fd4);

	free(wfile);
	return;
}


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
	int mnt_dir = 0;	// /mnt directory flag
	int var_dir = 0;		// /var directory flag
	int dev_dir = 0;		// /dev directory flag
	int opt_dir = 0;		// /opt directory flag
	int srv_dir = 0;                // /srv directory flag
	int etc_dir = 0;                // /etc directory flag
	int share_dir = 0;                // /usr/share directory flag
	int module_dir = 0;                // /sys/module directory flag

	size_t nowhitelist_c = 0;
	size_t nowhitelist_m = 32;
	char **nowhitelist = calloc(nowhitelist_m, sizeof(*nowhitelist));
	if (nowhitelist == NULL)
		errExit("failed allocating memory for nowhitelist entries");

	// verify whitelist files, extract symbolic links, etc.
	EUID_USER();
	struct stat s;
	while (entry) {
		int nowhitelist_flag = 0;

		// handle only whitelist and nowhitelist commands
		if (strncmp(entry->data, "whitelist ", 10) == 0)
			nowhitelist_flag = 0;
		else if (strncmp(entry->data, "nowhitelist ", 12) == 0)
			nowhitelist_flag = 1;
		else {
			entry = entry->next;
			continue;
		}
		char *dataptr = (nowhitelist_flag)? entry->data + 12: entry->data + 10;

		// replace ~/ or ${HOME} into /home/username or resolve macro
		new_name = expand_macros(dataptr);
		assert(new_name);

		// mount empty home directory if resolving the macro was not successful
		if (is_macro(new_name) && macro_id(new_name) > -1) {
			// no warning if home does not exist (e.g. in a chroot)
			if (stat(cfg.homedir, &s) == 0 && !nowhitelist_flag && !arg_private) {
				home_dir = 1;
				if (!arg_quiet) {
					fprintf(stderr, "***\n");
					fprintf(stderr, "*** Warning: cannot whitelist %s directory\n", new_name);
					fprintf(stderr, "*** Any file saved in this directory will be lost when the sandbox is closed.\n");
					fprintf(stderr, "***\n");
				}
			}
			entry->data = EMPTY_STRING;
			entry = entry->next;
			free(new_name);
			continue;
		}

		// remove trailing slashes and single dots
		if (!nowhitelist_flag)
			trim_trailing_slash_or_dot(new_name);

		if (arg_debug || arg_debug_whitelists)
			fprintf(stderr, "Debug %d: new_name #%s#, %s\n", __LINE__, new_name, (nowhitelist_flag)? "nowhitelist": "whitelist");

		// valid path referenced to filesystem root
		if (*new_name != '/') {
			if (arg_debug || arg_debug_whitelists)
				fprintf(stderr, "Debug %d: \n", __LINE__);
			goto errexit;
		}

		// extract the absolute path of the file
		// realpath function will fail with ENOENT if the file is not found or with EACCES if user has no permission
		// special processing for /dev/fd, /dev/stdin, /dev/stdout and /dev/stderr
		char *fname;
		if (strcmp(new_name, "/dev/fd") == 0)
			fname = strdup("/proc/self/fd");
		else if (strcmp(new_name, "/dev/stdin") == 0)
			fname = strdup("/proc/self/fd/0");
		else if (strcmp(new_name, "/dev/stdout") == 0)
			fname = strdup("/proc/self/fd/1");
		else if (strcmp(new_name, "/dev/stderr") == 0)
			fname = strdup("/proc/self/fd/2");
		else
			fname = realpath(new_name, NULL);

		if (!fname) {
			// file not found, blank the entry in the list and continue
			if (arg_debug || arg_debug_whitelists) {
				printf("Removed whitelist/nowhitelist path: %s\n", entry->data);
				printf("\texpanded: %s\n", new_name);
				printf("\treal path: (null)\n");
				printf("\t");fflush(0);
				perror("realpath");
			}

			// if 1 the file was not found; mount an empty directory
			if (!nowhitelist_flag) {
				if (strncmp(new_name, cfg.homedir, strlen(cfg.homedir)) == 0 && new_name[strlen(cfg.homedir)] == '/') {
					if(!arg_private)
						home_dir = 1;
				}
				else if (strncmp(new_name, "/tmp/", 5) == 0)
					tmp_dir = 1;
				else if (strncmp(new_name, "/media/", 7) == 0)
					media_dir = 1;
				else if (strncmp(new_name, "/mnt/", 5) == 0)
					mnt_dir = 1;
				else if (strncmp(new_name, "/var/", 5) == 0)
					var_dir = 1;
				else if (strncmp(new_name, "/dev/", 5) == 0)
					dev_dir = 1;
				else if (strncmp(new_name, "/opt/", 5) == 0)
					opt_dir = 1;
				else if (strncmp(new_name, "/srv/", 5) == 0)
					srv_dir = 1;
				else if (strncmp(new_name, "/etc/", 5) == 0)
					etc_dir = 1;
				else if (strncmp(new_name, "/usr/share/", 11) == 0)
					share_dir = 1;
				else if (strncmp(new_name, "/sys/module/", 12) == 0)
					module_dir = 1;
			}

			entry->data = EMPTY_STRING;
			entry = entry->next;
			free(new_name);
			continue;
		}
		else if (arg_debug_whitelists)
			printf("real path %s\n", fname);

		if (nowhitelist_flag) {
			// store the path in nowhitelist array
			if (arg_debug || arg_debug_whitelists)
				printf("Storing nowhitelist %s\n", fname);

			if (nowhitelist_c >= nowhitelist_m) {
				nowhitelist_m *= 2;
				nowhitelist = realloc(nowhitelist, sizeof(*nowhitelist) * nowhitelist_m);
				if (nowhitelist == NULL)
					errExit("failed increasing memory for nowhitelist entries");
			}
			nowhitelist[nowhitelist_c++] = fname;
			entry->data = EMPTY_STRING;
			entry = entry->next;
			free(new_name);
			continue;
		}

		// check for supported directories
		if (strncmp(new_name, cfg.homedir, strlen(cfg.homedir)) == 0 && new_name[strlen(cfg.homedir)] == '/') {
			// whitelisting home directory is disabled if --private option is present
			if (arg_private) {
				if (arg_debug || arg_debug_whitelists)
					printf("\"%s\" disabled by --private\n", entry->data);

				entry->data = EMPTY_STRING;
				entry = entry->next;
				free(fname);
				free(new_name);
				continue;
			}

			entry->home_dir = 1;
			home_dir = 1;
			if (arg_debug || arg_debug_whitelists)
				fprintf(stderr, "Debug %d: fname #%s#, cfg.homedir #%s#\n",
					__LINE__, fname, cfg.homedir);

			// both path and absolute path are in user home,
			// if not check if the symlink destination is owned by the user
			if (strncmp(fname, cfg.homedir, strlen(cfg.homedir)) != 0 || fname[strlen(cfg.homedir)] != '/') {
				if (checkcfg(CFG_FOLLOW_SYMLINK_AS_USER)) {
					if (stat(fname, &s) == 0 && s.st_uid != getuid()) {
						free(fname);
						goto errexit;
					}
				}
			}
		}
		else if (strncmp(new_name, "/tmp/", 5) == 0) {
			entry->tmp_dir = 1;
			tmp_dir = 1;

			// both path and absolute path are under /tmp
			if (strncmp(fname, "/tmp/", 5) != 0) {
				free(fname);
				goto errexit;
			}
		}
		else if (strncmp(new_name, "/media/", 7) == 0) {
			entry->media_dir = 1;
			media_dir = 1;
			// both path and absolute path are under /media
			if (strncmp(fname, "/media/", 7) != 0) {
				free(fname);
				goto errexit;
			}
		}
		else if (strncmp(new_name, "/mnt/", 5) == 0) {
			entry->mnt_dir = 1;
			mnt_dir = 1;
			// both path and absolute path are under /mnt
			if (strncmp(fname, "/mnt/", 5) != 0) {
				free(fname);
				goto errexit;
			}
		}
		else if (strncmp(new_name, "/var/", 5) == 0) {
			entry->var_dir = 1;
			var_dir = 1;
			// both path and absolute path are under /var
			// exceptions: /var/tmp, /var/run and /var/lock
			if (strcmp(new_name, "/var/run")== 0 && strcmp(fname, "/run") == 0);
			else if (strcmp(new_name, "/var/lock")== 0 && strcmp(fname, "/run/lock") == 0);
			else if (strcmp(new_name, "/var/tmp")== 0 && strcmp(fname, "/tmp") == 0);
			else {
				// both path and absolute path are under /var
				if (strncmp(fname, "/var/", 5) != 0) {
					free(fname);
					goto errexit;
				}
			}
		}
		else if (strncmp(new_name, "/dev/", 5) == 0) {
			entry->dev_dir = 1;
			dev_dir = 1;
			// special handling for /dev/shm
			// on some platforms (Debian wheezy, Ubuntu 14.04), it is a symlink to /run/shm
			if (strcmp(new_name, "/dev/shm") == 0 && strcmp(fname, "/run/shm") == 0);
			// special handling for /dev/log, which can be a symlink to /run/systemd/journal/dev-log
			else if (strcmp(new_name, "/dev/log") == 0 && strcmp(fname, "/run/systemd/journal/dev-log") == 0);
			// special processing for /proc/self/fd files
			else if (strcmp(new_name, "/dev/fd") == 0 && strcmp(fname, "/proc/self/fd") == 0);
			else if (strcmp(new_name, "/dev/stdin") == 0 && strcmp(fname, "/proc/self/fd/0") == 0);
			else if (strcmp(new_name, "/dev/stdout") == 0 && strcmp(fname, "/proc/self/fd/1") == 0);
			else if (strcmp(new_name, "/dev/stderr") == 0 && strcmp(fname, "/proc/self/fd/2") == 0);
			else {
				// both path and absolute path are under /dev
				if (strncmp(fname, "/dev/", 5) != 0) {
					free(fname);
					goto errexit;
				}
			}
		}
		else if (strncmp(new_name, "/opt/", 5) == 0) {
			entry->opt_dir = 1;
			opt_dir = 1;
			// both path and absolute path are under /dev
			if (strncmp(fname, "/opt/", 5) != 0) {
				free(fname);
				goto errexit;
			}
		}
		else if (strncmp(new_name, "/srv/", 5) == 0) {
			entry->srv_dir = 1;
			srv_dir = 1;
			// both path and absolute path are under /srv
			if (strncmp(fname, "/srv/", 5) != 0) {
				free(fname);
				goto errexit;
			}
		}
		else if (strncmp(new_name, "/etc/", 5) == 0) {
			entry->etc_dir = 1;
			etc_dir = 1;
			// special handling for some of the symlinks
			if (strcmp(new_name, "/etc/localtime") == 0);
			else if (strcmp(new_name, "/etc/mtab") == 0);
			else if (strcmp(new_name, "/etc/os-release") == 0);
			// both path and absolute path are under /etc
			else {
				if (strncmp(fname, "/etc/", 5) != 0) {
					free(fname);
					goto errexit;
				}
			}
		}
		else if (strncmp(new_name, "/usr/share/", 11) == 0) {
			entry->share_dir = 1;
			share_dir = 1;
			// both path and absolute path are under /etc
			if (strncmp(fname, "/usr/share/", 11) != 0) {
				free(fname);
				goto errexit;
			}
		}
		else if (strncmp(new_name, "/sys/module/", 12) == 0) {
			entry->module_dir = 1;
			module_dir = 1;
			// both path and absolute path are under /sys/module
			if (strncmp(fname, "/sys/module/", 12) != 0) {
				free(fname);
				goto errexit;
			}
		}
		else {
			free(fname);
			goto errexit;
		}

		// check if the path is in nowhitelist array
		if (nowhitelist_flag == 0) {
			size_t i;
			int found = 0;
			for (i = 0; i < nowhitelist_c; i++) {
				if (nowhitelist[i] == NULL)
					break;
				if (strcmp(nowhitelist[i], fname) == 0) {
					found = 1;
					break;
				}
			}
			if (found) {
				if (arg_debug || arg_debug_whitelists)
					printf("Skip nowhitelisted path %s\n", fname);
				entry->data = EMPTY_STRING;
				entry = entry->next;
				free(fname);
				free(new_name);
				continue;
			}
		}

		// mark symbolic links
		if (is_link(new_name))
			entry->link = new_name;
		else {
			free(new_name);
			entry->link = NULL;
		}

		// change file name in entry->data
		if (strcmp(fname, entry->data + 10) != 0) {
			char *newdata;
			if (asprintf(&newdata, "whitelist %s", fname) == -1)
				errExit("asprintf");
			entry->data = newdata;
			if (arg_debug || arg_debug_whitelists)
				printf("Replaced whitelist path: %s\n", entry->data);
		}
		free(fname);
		entry = entry->next;
	}

	// release nowhitelist memory
	assert(nowhitelist);
	free(nowhitelist);

	EUID_ROOT();
	// /home/user mountpoint
	if (home_dir) {
		// check if /home/user directory exists
		if (stat(cfg.homedir, &s) == 0) {
			// keep a copy of real home dir in RUN_WHITELIST_HOME_USER_DIR
			mkdir_attr(RUN_WHITELIST_HOME_USER_DIR, 0755, getuid(), getgid());
			if (mount(cfg.homedir, RUN_WHITELIST_HOME_USER_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mount bind");

			// mount a tmpfs and initialize /home/user, overrides --allusers
			fs_private();
		}
		else
			home_dir = 0;
	}

	// /tmp mountpoint
	if (tmp_dir) {
		// keep a copy of real /tmp directory in RUN_WHITELIST_TMP_DIR
		mkdir_attr(RUN_WHITELIST_TMP_DIR, 1777, 0, 0);
		if (mount("/tmp", RUN_WHITELIST_TMP_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount bind");

		// mount tmpfs on /tmp
		if (arg_debug || arg_debug_whitelists)
			printf("Mounting tmpfs on /tmp directory\n");
		if (mount("tmpfs", "/tmp", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=1777,gid=0") < 0)
			errExit("mounting tmpfs on /tmp");
		fs_logger("tmpfs /tmp");
	}

	// /media mountpoint
	if (media_dir) {
		// some distros don't have a /media directory
		if (stat("/media", &s) == 0) {
			// keep a copy of real /media directory in RUN_WHITELIST_MEDIA_DIR
			mkdir_attr(RUN_WHITELIST_MEDIA_DIR, 0755, 0, 0);
			if (mount("/media", RUN_WHITELIST_MEDIA_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mount bind");

			// mount tmpfs on /media
			if (arg_debug || arg_debug_whitelists)
				printf("Mounting tmpfs on /media directory\n");
			if (mount("tmpfs", "/media", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
				errExit("mounting tmpfs on /media");
			fs_logger("tmpfs /media");
		}
		else
			media_dir = 0;
	}

	// /mnt mountpoint
	if (mnt_dir) {
		// check if /mnt directory exists
		if (stat("/mnt", &s) == 0) {
			// keep a copy of real /mnt directory in RUN_WHITELIST_MNT_DIR
			mkdir_attr(RUN_WHITELIST_MNT_DIR, 0755, 0, 0);
			if (mount("/mnt", RUN_WHITELIST_MNT_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mount bind");

			// mount tmpfs on /mnt
			if (arg_debug || arg_debug_whitelists)
				printf("Mounting tmpfs on /mnt directory\n");
			if (mount("tmpfs", "/mnt", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
				errExit("mounting tmpfs on /mnt");
			fs_logger("tmpfs /mnt");
		}
		else
			mnt_dir = 0;
	}


	// /var mountpoint
	if (var_dir) {
		// keep a copy of real /var directory in RUN_WHITELIST_VAR_DIR
		mkdir_attr(RUN_WHITELIST_VAR_DIR, 0755, 0, 0);
		if (mount("/var", RUN_WHITELIST_VAR_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount bind");

		// mount tmpfs on /var
		if (arg_debug || arg_debug_whitelists)
			printf("Mounting tmpfs on /var directory\n");
		if (mount("tmpfs", "/var", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting tmpfs on /var");
		fs_logger("tmpfs /var");
	}

	// /dev mountpoint
	if (dev_dir) {
		// keep a copy of real /dev directory in RUN_WHITELIST_DEV_DIR
		mkdir_attr(RUN_WHITELIST_DEV_DIR, 0755, 0, 0);
		if (mount("/dev", RUN_WHITELIST_DEV_DIR, NULL, MS_BIND|MS_REC,  "mode=755,gid=0") < 0)
			errExit("mount bind");

		// mount tmpfs on /dev
		if (arg_debug || arg_debug_whitelists)
			printf("Mounting tmpfs on /dev directory\n");
		if (mount("tmpfs", "/dev", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting tmpfs on /dev");
		fs_logger("tmpfs /dev");
	}

	// /opt mountpoint
	if (opt_dir) {
		// check if /opt directory exists
		if (stat("/opt", &s) == 0) {
			// keep a copy of real /opt directory in RUN_WHITELIST_OPT_DIR
			mkdir_attr(RUN_WHITELIST_OPT_DIR, 0755, 0, 0);
			if (mount("/opt", RUN_WHITELIST_OPT_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mount bind");

			// mount tmpfs on /opt
			if (arg_debug || arg_debug_whitelists)
				printf("Mounting tmpfs on /opt directory\n");
			if (mount("tmpfs", "/opt", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
				errExit("mounting tmpfs on /opt");
			fs_logger("tmpfs /opt");
		}
		else
			opt_dir = 0;
	}

	// /srv mountpoint
	if (srv_dir) {
		// check if /srv directory exists
		if (stat("/srv", &s) == 0) {
			// keep a copy of real /srv directory in RUN_WHITELIST_SRV_DIR
			mkdir_attr(RUN_WHITELIST_SRV_DIR, 0755, 0, 0);
			if (mount("/srv", RUN_WHITELIST_SRV_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mount bind");

			// mount tmpfs on /srv
			if (arg_debug || arg_debug_whitelists)
				printf("Mounting tmpfs on /srv directory\n");
			if (mount("tmpfs", "/srv", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
				errExit("mounting tmpfs on /srv");
			fs_logger("tmpfs /srv");
		}
		else
			srv_dir = 0;
	}

	// /etc mountpoint
	if (etc_dir) {
		// check if /etc directory exists
		if (stat("/etc", &s) == 0) {
			// keep a copy of real /etc directory in RUN_WHITELIST_ETC_DIR
			mkdir_attr(RUN_WHITELIST_ETC_DIR, 0755, 0, 0);
			if (mount("/etc", RUN_WHITELIST_ETC_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mount bind");

			// mount tmpfs on /srv
			if (arg_debug || arg_debug_whitelists)
				printf("Mounting tmpfs on /etc directory\n");
			if (mount("tmpfs", "/etc", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
				errExit("mounting tmpfs on /etc");
			fs_logger("tmpfs /etc");
		}
		else
			etc_dir = 0;
	}

	// /usr/share mountpoint
	if (share_dir) {
		// check if /usr/share directory exists
		if (stat("/usr/share", &s) == 0) {
			// keep a copy of real /usr/share directory in RUN_WHITELIST_ETC_DIR
			mkdir_attr(RUN_WHITELIST_SHARE_DIR, 0755, 0, 0);
			if (mount("/usr/share", RUN_WHITELIST_SHARE_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mount bind");

			// mount tmpfs on /srv
			if (arg_debug || arg_debug_whitelists)
				printf("Mounting tmpfs on /usr/share directory\n");
			if (mount("tmpfs", "/usr/share", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
				errExit("mounting tmpfs on /usr/share");
			fs_logger("tmpfs /usr/share");
		}
		else
			share_dir = 0;
	}

	// /sys/module mountpoint
	if (module_dir) {
		// check if /sys/module directory exists
		if (stat("/sys/module", &s) == 0) {
			// keep a copy of real /sys/module directory in RUN_WHITELIST_MODULE_DIR
			mkdir_attr(RUN_WHITELIST_MODULE_DIR, 0755, 0, 0);
			if (mount("/sys/module", RUN_WHITELIST_MODULE_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mount bind");

			// mount tmpfs on /sys/module
			if (arg_debug || arg_debug_whitelists)
				printf("Mounting tmpfs on /sys/module directory\n");
			if (mount("tmpfs", "/sys/module", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
				errExit("mounting tmpfs on /sys/module");
			fs_logger("tmpfs /sys/module");
		}
		else
			module_dir = 0;
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
			if (lstat(entry->link, &s) != 0) {
				// create the path if necessary
				int fd = mkpath(entry->link, 0755);
				if (fd == -1) {
					if (arg_debug || arg_debug_whitelists)
						printf("Debug %d: cannot create symbolic link %s\n", __LINE__, entry->link);
					free(entry->link);
					entry->link = NULL;
					entry = entry->next;
					continue;
				}
				// get file name of symlink
				const char *file = gnu_basename(entry->link);
				// create the link
				int rv = symlinkat(entry->data + 10, fd, file);
				if (rv) {
					if (arg_debug || arg_debug_whitelists) {
						perror("symlink");
						printf("Debug %d: cannot create symbolic link %s\n", __LINE__, entry->link);
					}
				}
				else if (arg_debug || arg_debug_whitelists)
					printf("Created symbolic link %s -> %s\n", entry->link, entry->data + 10);
				close(fd);
			}
			free(entry->link);
			entry->link = NULL;
		}

		entry = entry->next;
	}

	// mask the real home directory, currently mounted on RUN_WHITELIST_HOME_DIR
	if (home_dir) {
		if (mount("tmpfs", RUN_WHITELIST_HOME_USER_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mount tmpfs");
		fs_logger2("tmpfs", RUN_WHITELIST_HOME_USER_DIR);
	}

	// mask the real /tmp directory, currently mounted on RUN_WHITELIST_TMP_DIR
	if (tmp_dir) {
		if (mount("tmpfs", RUN_WHITELIST_TMP_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mount tmpfs");
		fs_logger2("tmpfs", RUN_WHITELIST_TMP_DIR);
	}

	// mask the real /var directory, currently mounted on RUN_WHITELIST_VAR_DIR
	if (var_dir) {
		if (mount("tmpfs", RUN_WHITELIST_VAR_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mount tmpfs");
		fs_logger2("tmpfs", RUN_WHITELIST_VAR_DIR);
	}

	// mask the real /opt directory, currently mounted on RUN_WHITELIST_OPT_DIR
	if (opt_dir) {
		if (mount("tmpfs", RUN_WHITELIST_OPT_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mount tmpfs");
		fs_logger2("tmpfs", RUN_WHITELIST_OPT_DIR);
	}

	// mask the real /dev directory, currently mounted on RUN_WHITELIST_DEV_DIR
	if (dev_dir) {
		if (mount("tmpfs", RUN_WHITELIST_DEV_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mount tmpfs");
		fs_logger2("tmpfs", RUN_WHITELIST_DEV_DIR);
	}

	// mask the real /media directory, currently mounted on RUN_WHITELIST_MEDIA_DIR
	if (media_dir) {
		if (mount("tmpfs", RUN_WHITELIST_MEDIA_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mount tmpfs");
		fs_logger2("tmpfs", RUN_WHITELIST_MEDIA_DIR);
	}

	// mask the real /mnt directory, currently mounted on RUN_WHITELIST_MNT_DIR
	if (mnt_dir) {
		if (mount("tmpfs", RUN_WHITELIST_MNT_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mount tmpfs");
		fs_logger2("tmpfs", RUN_WHITELIST_MNT_DIR);
	}

	// mask the real /srv directory, currently mounted on RUN_WHITELIST_SRV_DIR
	if (srv_dir) {
		if (mount("tmpfs", RUN_WHITELIST_SRV_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mount tmpfs");
		fs_logger2("tmpfs", RUN_WHITELIST_SRV_DIR);
	}

	// mask the real /etc directory, currently mounted on RUN_WHITELIST_ETC_DIR
	if (etc_dir) {
		if (mount("tmpfs", RUN_WHITELIST_ETC_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mount tmpfs");
		fs_logger2("tmpfs", RUN_WHITELIST_ETC_DIR);
	}

	// mask the real /usr/share directory, currently mounted on RUN_WHITELIST_SHARE_DIR
	if (share_dir) {
		if (mount("tmpfs", RUN_WHITELIST_SHARE_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mount tmpfs");
		fs_logger2("tmpfs", RUN_WHITELIST_SHARE_DIR);
	}

	// mask the real /sys/module directory, currently mounted on RUN_WHITELIST_MODULE_DIR
	if (module_dir) {
		if (mount("tmpfs", RUN_WHITELIST_MODULE_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mount tmpfs");
		fs_logger2("tmpfs", RUN_WHITELIST_MODULE_DIR);
	}

	return;

errexit:
	fprintf(stderr, "Error: invalid whitelist path %s\n", new_name);
	exit(1);
}
