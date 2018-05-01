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

static char *dentry[] = {
	"Downloads",
	"Загрузки",
	"Téléchargement",
	NULL
};

#define EMPTY_STRING ("")
#define MAXBUF 4098
static char *resolve_downloads(int nowhitelist_flag) {
	EUID_ASSERT();
	char *fname;
	struct stat s;

	// try a well known download directory name
	int i = 0;
	while (dentry[i] != NULL) {
		if (asprintf(&fname, "%s/%s", cfg.homedir, dentry[i]) == -1)
			errExit("asprintf");

		if (stat(fname, &s) == 0) {
			if (arg_debug || arg_debug_whitelists)
				printf("Downloads directory resolved as \"%s\"\n", fname);

			char *rv;
			if (nowhitelist_flag) {
				if (asprintf(&rv, "nowhitelist ~/%s", dentry[i]) == -1)
					errExit("asprintf");
			}
			else {
				if (asprintf(&rv, "whitelist ~/%s", dentry[i]) == -1)
					errExit("asprintf");
			}
			free(fname);
			return rv;
		}
		free(fname);
		i++;
	}

	// try a name form ~/.config/user-dirs.dirs
	if (asprintf(&fname, "%s/.config/user-dirs.dirs", cfg.homedir) == -1)
		errExit("asprintf");
	FILE *fp = fopen(fname, "r");
	if (!fp) {
		free(fname);
		return NULL;
	}
	free(fname);

	// extract downloads directory
	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp)) {
		char *ptr = buf;

		// skip blanks
		while (*ptr == ' ' || *ptr == '\t')
			ptr++;
		if (*ptr == '\0' || *ptr == '\n' || *ptr == '#')
			continue;

		if (strncmp(ptr, "XDG_DOWNLOAD_DIR=\"$HOME/", 24) == 0) {
			char *ptr1 = ptr + 24;
			char *ptr2 = strchr(ptr1, '"');
			if (ptr2) {
				fclose(fp);
				*ptr2 = '\0';
				if (arg_debug || arg_debug_whitelists)
					printf("extracted %s from ~/.config/user-dirs.dirs\n", ptr1);
				if (strlen(ptr1) != 0) {
					if (arg_debug || arg_debug_whitelists)
						printf("Downloads directory resolved as \"%s\"\n", ptr1);

					if (asprintf(&fname, "%s/%s", cfg.homedir, ptr1) == -1)
						errExit("asprintf");

					if (stat(fname, &s) == -1) {
						free(fname);
						goto errout;
					}

					char *rv;
					if (nowhitelist_flag) {
						if (asprintf(&rv, "nowhitelist ~/%s", ptr + 24) == -1)
							errExit("asprintf");
					}
					else {
						if (asprintf(&rv, "whitelist ~/%s", ptr + 24) == -1)
							errExit("asprintf");
					}
					return rv;
				}
				else
					goto errout;
			}
		}
	}

	fclose(fp);
	return NULL;

errout:
	if (!arg_private) {
		fprintf(stderr, "***\n");
		fprintf(stderr, "*** Error: Downloads directory was not found in user home.\n");
		fprintf(stderr, "*** \tAny files saved by the program, will be lost when the sandbox is closed.\n");
		fprintf(stderr, "***\n");
	}

	return NULL;
}

static int mkpath(const char* path, mode_t mode) {
	assert(path && *path);

	mode |= 0111;

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
	int done = 0;
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
			if (set_perms(file_path, uid, gid, mode))
				errExit("set_perms");
			done = 1;
		}

		*p='/';
	}
	if (done)
		fs_logger2("mkpath", path);

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
		if (strncmp(path, cfg.homedir, strlen(cfg.homedir)) == 0) {
			fname = path + strlen(cfg.homedir);
			if (*fname == '\0')
				goto errexit;
		}
		else
			fname = path;

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_HOME_USER_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->tmp_dir) {
		fname = path + 5; // strlen("/tmp/")
		if (*fname == '\0')
			goto errexit;

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_TMP_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->media_dir) {
		fname = path + 7; // strlen("/media/")
		if (*fname == '\0')
			goto errexit;

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_MEDIA_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->mnt_dir) {
		fname = path + 5; // strlen("/mnt/")
		if (*fname == '\0')
			goto errexit;

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_MNT_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->var_dir) {
		fname = path + 5; // strlen("/var/")
		if (*fname == '\0')
			goto errexit;

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_VAR_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->dev_dir) {
		fname = path + 5; // strlen("/dev/")
		if (*fname == '\0')
			goto errexit;

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_DEV_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->opt_dir) {
		fname = path + 5; // strlen("/opt/")
		if (*fname == '\0')
			goto errexit;

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_OPT_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->srv_dir) {
		fname = path + 5; // strlen("/srv/")
		if (*fname == '\0')
			goto errexit;

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_SRV_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->etc_dir) {
		fname = path + 5; // strlen("/etc/")
		if (*fname == '\0')
			goto errexit;

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_ETC_DIR, fname) == -1)
			errExit("asprintf");
	}
	else if (entry->share_dir) {
		fname = path + 11; // strlen("/usr/share/")
		if (*fname == '\0')
			goto errexit;

		if (asprintf(&wfile, "%s/%s", RUN_WHITELIST_SHARE_DIR, fname) == -1)
			errExit("asprintf");
	}

	// check if the file exists
	assert(wfile);
	struct stat s;
	if (stat(wfile, &s) == 0) {
		if (arg_debug || arg_debug_whitelists)
			printf("Whitelisting %s\n", path);
	}
	else
		return;

	// create the path if necessary
	mkpath(path, s.st_mode);
	fs_logger2("whitelist", path);

	// process directory
	if (S_ISDIR(s.st_mode)) {
		// create directory
		int rv = mkdir(path, 0755);
		(void) rv;
	}

	// process regular file
	else {
		if (access(path, R_OK)) {
			// create an empty file
			FILE *fp = fopen(path, "w");
			if (!fp) {
				fprintf(stderr, "Error: cannot create empty file in home directory\n");
				exit(1);
			}
			// set file properties
			SET_PERMS_STREAM(fp, s.st_uid, s.st_gid, s.st_mode);
			fclose(fp);
		}
		else
			return; // the file is already present
	}

	// mount
	if (mount(wfile, path, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");

	free(wfile);
	return;

errexit:
	fprintf(stderr, "Error: file %s is not in the whitelisted directory\n", path);
	exit(1);
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
	int mnt_dir = 0;	// /mnt directory flag
	int var_dir = 0;		// /var directory flag
	int dev_dir = 0;		// /dev directory flag
	int opt_dir = 0;		// /opt directory flag
	int srv_dir = 0;                // /srv directory flag
	int etc_dir = 0;                // /etc directory flag
	int share_dir = 0;                // /usr/share directory flag

	size_t nowhitelist_c = 0;
	size_t nowhitelist_m = 32;
	char **nowhitelist = calloc(nowhitelist_m, sizeof(*nowhitelist));
	if (nowhitelist == NULL)
		errExit("failed allocating memory for nowhitelist entries");

	// verify whitelist files, extract symbolic links, etc.
	EUID_USER();
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

		// resolve ${DOWNLOADS}
		if (strcmp(dataptr, "${DOWNLOADS}") == 0) {
			char *tmp = resolve_downloads(nowhitelist_flag);
			if (tmp) {
				entry->data = tmp;
				dataptr = (nowhitelist_flag)? entry->data + 12: entry->data + 10;
			}
			else {
				if (!nowhitelist_flag && !arg_quiet && !arg_private) {
					fprintf(stderr, "***\n");
					fprintf(stderr, "*** Warning: cannot whitelist Downloads directory\n");
					fprintf(stderr, "*** \tAny file saved will be lost when the sandbox is closed.\n");
					fprintf(stderr, "*** \tPlease create a proper Downloads directory for your application.\n");
					fprintf(stderr, "***\n");
				}
				entry->data = EMPTY_STRING;
				continue;
			}
		}

		// replace ~/ or ${HOME} into /home/username
		new_name = expand_home(dataptr, cfg.homedir);
		assert(new_name);
		if (arg_debug || arg_debug_whitelists)
			fprintf(stderr, "Debug %d: new_name #%s#, %s\n", __LINE__, new_name, (nowhitelist_flag)? "nowhitelist": "whitelist");

		// valid path referenced to filesystem root
		if (*new_name != '/') {
			if (arg_debug || arg_debug_whitelists)
				fprintf(stderr, "Debug %d: \n", __LINE__);
			goto errexit;
		}


		// extract the absolute path of the file
		// realpath function will fail with ENOENT if the file is not found
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
				if (strncmp(new_name, cfg.homedir, strlen(cfg.homedir)) == 0) {
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
			}

			entry->data = EMPTY_STRING;
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
			continue;
		}


		// check for supported directories
		if (strncmp(new_name, cfg.homedir, strlen(cfg.homedir)) == 0) {
			// whitelisting home directory is disabled if --private option is present
			if (arg_private) {
				if (arg_debug || arg_debug_whitelists)
					printf("\"%s\" disabled by --private\n", entry->data);

				entry->data = EMPTY_STRING;
				continue;
			}

			entry->home_dir = 1;
			home_dir = 1;
			if (arg_debug || arg_debug_whitelists)
				fprintf(stderr, "Debug %d: fname #%s#, cfg.homedir #%s#\n",
					__LINE__, fname, cfg.homedir);

			// both path and absolute path are under /home
			if (strncmp(fname, cfg.homedir, strlen(cfg.homedir)) != 0) {
				if (checkcfg(CFG_FOLLOW_SYMLINK_AS_USER)) {
					// check if the file is owned by the user
					struct stat s;
					if (stat(fname, &s) == 0 && s.st_uid != getuid())
						goto errexit;
				}
			}
		}
		else if (strncmp(new_name, "/tmp/", 5) == 0) {
			entry->tmp_dir = 1;
			tmp_dir = 1;
			// both path and absolute path are under /tmp
			if (strncmp(fname, "/tmp/", 5) != 0) {
				goto errexit;
			}
		}
		else if (strncmp(new_name, "/media/", 7) == 0) {
			entry->media_dir = 1;
			media_dir = 1;
			// both path and absolute path are under /media
			if (strncmp(fname, "/media/", 7) != 0) {
				goto errexit;
			}
		}
		else if (strncmp(new_name, "/mnt/", 5) == 0) {
			entry->mnt_dir = 1;
			mnt_dir = 1;
			// both path and absolute path are under /mnt
			if (strncmp(fname, "/mnt/", 5) != 0) {
				goto errexit;
			}
		}
		else if (strncmp(new_name, "/var/", 5) == 0) {
			entry->var_dir = 1;
			var_dir = 1;
			// both path and absolute path are under /var
			// exceptions: /var/run and /var/lock
			if (strcmp(new_name, "/var/run")== 0)
				;
			else if (strcmp(new_name, "/var/lock")== 0)
				;
			else if (strncmp(fname, "/var/", 5) != 0) {
				goto errexit;
			}
		}
		else if (strncmp(new_name, "/dev/", 5) == 0) {
			entry->dev_dir = 1;
			dev_dir = 1;

			// special handling for /dev/shm
			// on some platforms (Debian wheezy, Ubuntu 14.04), it is a symlink to /run/shm
			if (strcmp(new_name, "/dev/shm") == 0 && strcmp(fname, "/run/shm") == 0);
			// special processing for /proc/self/fd files
			else if (strcmp(new_name, "/dev/fd") == 0 && strcmp(fname, "/proc/self/fd") == 0);
			else if (strcmp(new_name, "/dev/stdin") == 0 && strcmp(fname, "/proc/self/fd/0") == 0);
			else if (strcmp(new_name, "/dev/stdout") == 0 && strcmp(fname, "/proc/self/fd/1") == 0);
			else if (strcmp(new_name, "/dev/stderr") == 0 && strcmp(fname, "/proc/self/fd/2") == 0);
			else {
				// both path and absolute path are under /dev
				if (strncmp(fname, "/dev/", 5) != 0) {
					goto errexit;
				}
			}
		}
		else if (strncmp(new_name, "/opt/", 5) == 0) {
			entry->opt_dir = 1;
			opt_dir = 1;
			// both path and absolute path are under /dev
			if (strncmp(fname, "/opt/", 5) != 0) {
				goto errexit;
			}
		}
		else if (strncmp(new_name, "/srv/", 5) == 0) {
			entry->srv_dir = 1;
			srv_dir = 1;
			// both path and absolute path are under /srv
			if (strncmp(fname, "/srv/", 5) != 0) {
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
				if (strncmp(fname, "/etc/", 5) != 0)
					goto errexit;
			}
		}
		else if (strncmp(new_name, "/usr/share/", 11) == 0) {
			entry->share_dir = 1;
			share_dir = 1;
			// both path and absolute path are under /etc
			if (strncmp(fname, "/usr/share/", 11) != 0)
				goto errexit;
		}
		else {
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
				free(fname);
				continue;
			}
		}

		// mark symbolic links
		if (is_link(new_name))
			entry->link = new_name;
		else {
			free(new_name);
			new_name = NULL;
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
	// /home/user
	if (home_dir) {
		// keep a copy of real home dir in RUN_WHITELIST_HOME_USER_DIR
		mkdir_attr(RUN_WHITELIST_HOME_USER_DIR, 0755, getuid(), getgid());
		if (mount(cfg.homedir, RUN_WHITELIST_HOME_USER_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount bind");

		// mount a tmpfs and initialize /home/user
		 fs_private();
	}

	// /tmp mountpoint
	if (tmp_dir) {
		// keep a copy of real /tmp directory in
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
		struct stat s;
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
		struct stat s;
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

	// /srv mountpoint
	if (srv_dir) {
		// check if /srv directory exists
		struct stat s;
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
		struct stat s;
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
		struct stat s;
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
		if (strcmp(entry->data, "whitelist /run") == 0 &&
		    (strcmp(entry->link, "/var/run") == 0 || strcmp(entry->link, "/var/lock") == 0)) {
			int rv = symlink(entry->data + 10, entry->link);
			if (rv)
				fprintf(stderr, "Warning cannot create symbolic link %s\n", entry->link);
			else if (arg_debug || arg_debug_whitelists)
				printf("Created symbolic link %s -> %s\n", entry->link, entry->data + 10);
		}
		else {
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
					else if (arg_debug || arg_debug_whitelists)
						printf("Created symbolic link %s -> %s\n", entry->link, entry->data + 10);
				}
			}
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

	if (new_name)
		free(new_name);

	return;

errexit:
	fprintf(stderr, "Error: invalid whitelist path %s\n", new_name);
	exit(1);
}
