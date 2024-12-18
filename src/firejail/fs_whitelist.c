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
#include <sys/stat.h>
#include <fnmatch.h>
#include <glob.h>
#include <errno.h>

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif

#define TOP_MAX 64 // maximum number of top level directories

// mountinfo functionality test;
// 1. enable TEST_MOUNTINFO definition
// 2. run firejail --whitelist=/any/directory
//#define TEST_MOUNTINFO

static size_t homedir_len = 0; // cache length of homedir string
static size_t runuser_len = 0; // cache length of runuser string
static char *runuser = NULL;



static void whitelist_error(const char *path) {
	assert(path);

	fprintf(stderr, "Error: invalid whitelist path %s\n", path);
	exit(1);
}

static int whitelist_mkpath(const char *parentdir, const char *relpath, mode_t mode) {
	// starting from top level directory
	int parentfd = safer_openat(-1, parentdir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (parentfd < 0)
		errExit("open");

	// top level directory mount id
	int mountid = get_mount_id(parentfd);
	if (mountid < 0) {
		close(parentfd);
		return -1;
	}

	// work on a copy of the path
	char *dup = strdup(relpath);
	if (!dup)
		errExit("strdup");

	// only create leading directories, don't create the file
	char *p = strrchr(dup, '/');
	if (!p) { // nothing to do
		free(dup);
		return parentfd;
	}
	*p = '\0';

	// traverse the path, return -1 if a symlink is encountered
	int fd = -1;
	int done = 0;
	char *tok = strtok(dup, "/");
	assert(tok);
	while (tok) {
		// create the directory if necessary
		if (mkdirat(parentfd, tok, mode) == -1) {
			if (errno != EEXIST) {
				if (arg_debug || arg_debug_whitelists)
					perror("mkdir");
				close(parentfd);
				free(dup);
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
			return -1;
		}
		// different mount id indicates earlier whitelist mount
		if (get_mount_id(fd) != mountid) {
			if (arg_debug || arg_debug_whitelists)
				printf("Debug %d: whitelisted already\n", __LINE__);
			close(parentfd);
			close(fd);
			free(dup);
			return -1;
		}
		// move on to next path segment
		close(parentfd);
		parentfd = fd;
		tok = strtok(NULL, "/");
	}

	if (done) {
		char *abspath;
		if (asprintf(&abspath, "%s/%s", parentdir, relpath) < 0)
			errExit("asprintf");
		fs_logger2("mkpath", abspath);
		free(abspath);
	}

	free(dup);
	return fd;
}

static void whitelist_file(const TopDir * const top, const char *path) {
	EUID_ASSERT();
	assert(top && path);

	// check if path is inside top level directory
	size_t top_pathlen = strlen(top->path);
	if (strncmp(top->path, path, top_pathlen) != 0 || path[top_pathlen] != '/')
		return;
	const char *relpath = path + top_pathlen + 1;

	// open mount source, using a file descriptor that refers to the
	// top level directory
	// as the top level directory was opened before mounting the tmpfs
	// we still have full access to all directory contents
	// take care to not follow symbolic links (top->fd was obtained without
	// following a link, too)
	int fd = safer_openat(top->fd, relpath, O_PATH|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1) {
		if (arg_debug || arg_debug_whitelists)
			printf("Debug %d: skip whitelist %s\n", __LINE__, path);
		return;
	}
	struct stat s;
	if (fstat(fd, &s) == -1)
		errExit("fstat");
	if (S_ISLNK(s.st_mode)) {
		if (arg_debug || arg_debug_whitelists)
			printf("Debug %d: skip whitelist %s\n", __LINE__, path);
		close(fd);
		return;
	}

	// now modify the tmpfs:
	// create mount target as root, except if inside home or run/user/$UID directory
	if (strcmp(top->path, cfg.homedir) != 0 &&
	    strcmp(top->path, runuser) != 0)
		EUID_ROOT();

	// create path of the mount target
	int fd2 = whitelist_mkpath(top->path, relpath, 0755);
	if (fd2 == -1) {
		if (arg_debug || arg_debug_whitelists)
			printf("Debug %d: skip whitelist %s\n", __LINE__, path);
		close(fd);
		EUID_USER();
		return;
	}

	// get file name of the mount target
	const char *file = gnu_basename(relpath);

	// create mount target itself if necessary
	// and open it, a symlink is not allowed
	int fd3 = -1;
	if (S_ISDIR(s.st_mode)) {
		// directory bar can exist already:
		// firejail --whitelist=/foo/bar/baz --whitelist=/foo/bar
		if (mkdirat(fd2, file, 0755) == -1 && errno != EEXIST) {
			if (arg_debug || arg_debug_whitelists) {
				perror("mkdir");
				printf("Debug %d: skip whitelist %s\n", __LINE__, path);
			}
			close(fd);
			close(fd2);
			EUID_USER();
			return;
		}
		fd3 = openat(fd2, file, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	}
	else
		// create an empty file
		// fails with EEXIST if it is whitelisted already
		fd3 = openat(fd2, file, O_RDONLY|O_CREAT|O_EXCL|O_CLOEXEC, S_IRUSR|S_IWUSR);

	if (fd3 == -1) {
		if (errno != EEXIST && (arg_debug || arg_debug_whitelists)) {
			perror("open");
			printf("Debug %d: skip whitelist %s\n", __LINE__, path);
		}
		close(fd);
		close(fd2);
		EUID_USER();
		return;
	}
	close(fd2);

	if (arg_debug || arg_debug_whitelists)
		printf("Whitelisting %s\n", path);
	EUID_ROOT();
	if (bind_mount_by_fd(fd, fd3))
		errExit("mount bind");
	EUID_USER();
	// check the last mount operation
	MountData *mptr = get_last_mount(); // will do exit(1) if the mount cannot be found
#ifdef TEST_MOUNTINFO
	printf("TEST_MOUNTINFO\n");
	mptr->dir = "foo";
#endif
	// confirm the file was mounted on the right target
	// strcmp does not work here, because mptr->dir can be a child mount
	size_t path_len = strlen(path);
	if (strncmp(mptr->dir, path, path_len) != 0 ||
	   (*(mptr->dir + path_len) != '\0' && *(mptr->dir + path_len) != '/'))
		errLogExit("invalid whitelist mount");
	// No mounts are allowed on top level directories. A destination such as "/etc" is very bad!
	//  - there should be more than one '/' char in dest string
	if (mptr->dir == strrchr(mptr->dir, '/'))
		errLogExit("invalid whitelist mount");
	close(fd);
	close(fd3);
	fs_logger2("whitelist", path);
}

static void whitelist_symlink(const TopDir * const top, const char *link, const char *target) {
	EUID_ASSERT();
	assert(top && link && target);

	// confirm link is inside top level directory
	// this should never fail
	size_t top_pathlen = strlen(top->path);
	assert(strncmp(top->path, link, top_pathlen) == 0 && link[top_pathlen] == '/');

	const char *relpath = link + top_pathlen + 1;

	// create link as root, except if inside home or run/user/$UID directory
	if (strcmp(top->path, cfg.homedir) != 0 &&
	    strcmp(top->path, runuser) != 0)
		EUID_ROOT();

	int fd = whitelist_mkpath(top->path, relpath, 0755);
	if (fd == -1) {
		if (arg_debug || arg_debug_whitelists)
			printf("Debug %d: cannot create symbolic link %s\n", __LINE__, link);
		EUID_USER();
		return;
	}

	// get file name of symlink
	const char *file = gnu_basename(relpath);

	// create the link
	if (symlinkat(target, fd, file) == -1) {
		if (arg_debug || arg_debug_whitelists) {
			perror("symlink");
			printf("Debug %d: cannot create symbolic link %s\n", __LINE__, link);
		}
	}
	else if (arg_debug || arg_debug_whitelists)
		printf("Created symbolic link %s -> %s\n", link, target);

	close(fd);
	EUID_USER();
}

static void globbing(const char *pattern) {
	EUID_ASSERT();
	assert(pattern);

	// globbing
	glob_t globbuf;
	int globerr = glob(pattern, GLOB_NOCHECK | GLOB_NOSORT | GLOB_PERIOD, NULL, &globbuf);
	if (globerr) {
		fprintf(stderr, "Error: failed to glob private-bin pattern %s\n", pattern);
		exit(1);
	}

	size_t i;
	for (i = 0; i < globbuf.gl_pathc; i++) {
		assert(globbuf.gl_pathv[i]);
		// testing for GLOB_NOCHECK - no pattern matched returns the original pattern
		if (strcmp(globbuf.gl_pathv[i], pattern) == 0)
			continue;
		// foo/* expands to foo/. and foo/..
		const char *base = gnu_basename(globbuf.gl_pathv[i]);
		if (strcmp(base, ".") == 0 ||
		    strcmp(base, "..") == 0)
			continue;

		// build the new profile command
		char *newcmd;
		if (asprintf(&newcmd, "whitelist %s", globbuf.gl_pathv[i]) == -1)
			errExit("asprintf");

		// add the new profile command at the end of the list
		if (arg_debug || arg_debug_whitelists)
			printf("Adding new profile command: %s\n", newcmd);
		profile_add(newcmd);
	}

	globfree(&globbuf);
}

// mount tmpfs on all top level directories
static void tmpfs_topdirs(const TopDir * const topdirs) {
	int tmpfs_home = 0;
	int tmpfs_runuser = 0;

	int i;
	for (i = 0; i < TOP_MAX && topdirs[i].path; i++) {
		// do nested top level directories last
		// this way '--whitelist=nested_top_level_dir'
		// yields the full, unmodified directory
		// instead of the tmpfs
		if (strcmp(topdirs[i].path, cfg.homedir) == 0) {
			tmpfs_home = 1;
			continue;
		}
		if (strcmp(topdirs[i].path, runuser) == 0) {
			tmpfs_runuser = 1;
			continue;
		}

		// special case /run
		// open /run/firejail, so it can be restored right after mounting the tmpfs
		int fd = -1;
		if (strcmp(topdirs[i].path, "/run") == 0) {
			fd = open(RUN_FIREJAIL_DIR, O_PATH|O_CLOEXEC);
			if (fd == -1)
				errExit("open");
		}

		// mount tmpfs
		fs_tmpfs(topdirs[i].path, 0);
		selinux_relabel_path(topdirs[i].path, topdirs[i].path);

		// init tmpfs
		if (strcmp(topdirs[i].path, "/run") == 0) {
			// restore /run/firejail directory
			EUID_ROOT();
			mkdir_attr(RUN_FIREJAIL_DIR, 0755, 0, 0);
			if (bind_mount_fd_to_path(fd, RUN_FIREJAIL_DIR))
				errExit("mount bind");
			EUID_USER();
			close(fd);
			fs_logger2("whitelist", RUN_FIREJAIL_DIR);

			// restore /run/user/$UID directory
			whitelist_file(&topdirs[i], runuser);
		}
		else if (strcmp(topdirs[i].path, "/tmp") == 0) {
			// fix pam-tmpdir (#2685)
			const char *env = env_get("TMP");
			if (env) {
				// we allow TMP env set as /tmp/user/$UID and /tmp/$UID - see #4151
				char *pamtmpdir1;
				if (asprintf(&pamtmpdir1, "/tmp/user/%u", getuid()) == -1)
					errExit("asprintf");
				char *pamtmpdir2;
				if (asprintf(&pamtmpdir2, "/tmp/%u", getuid()) == -1)
					errExit("asprintf");
				if (strcmp(env, pamtmpdir1) == 0) {
					// create empty user-owned /tmp/user/$UID directory
					EUID_ROOT();
					mkdir_attr("/tmp/user", 0755, 0, 0);
					selinux_relabel_path("/tmp/user", "/tmp/user");
					fs_logger("mkdir /tmp/user");
					mkdir_attr(pamtmpdir1, 0700, getuid(), 0);
					selinux_relabel_path(pamtmpdir1, pamtmpdir1);
					fs_logger2("mkdir", pamtmpdir1);
					EUID_USER();
				}
				else if (strcmp(env, pamtmpdir2) == 0) {
					// create empty user-owned /tmp/$UID directory
					EUID_ROOT();
					mkdir_attr(pamtmpdir2, 0700, getuid(), 0);
					selinux_relabel_path(pamtmpdir2, pamtmpdir2);
					fs_logger2("mkdir", pamtmpdir2);
					EUID_USER();
				}
				free(pamtmpdir1);
				free(pamtmpdir2);
			}
		}

		// restore user home directory if it is masked by the tmpfs
		// creates path owned by root
		// does nothing if user home directory doesn't exist
		whitelist_file(&topdirs[i], cfg.homedir);
	}

	// user home directory
	if (tmpfs_home)
		fs_private(); // checks owner if outside /home

	// /run/user/$UID directory
	if (tmpfs_runuser) {
		fs_tmpfs(runuser, 0);
		selinux_relabel_path(runuser, runuser);
	}
}

static int reject_topdir(const char *dir) {
	if (!whitelist_reject_topdirs)
		return 0;

	size_t i;
	for (i = 0; whitelist_reject_topdirs[i]; i++) {
		if (strcmp(dir, whitelist_reject_topdirs[i]) == 0)
			return 1;
	}
	return 0;
}

// keep track of whitelist top level directories by adding them to an array
// open each directory
static TopDir *add_topdir(const char *dir, TopDir *topdirs, const char *path) {
	EUID_ASSERT();
	assert(dir && path);

	// /proc and /sys are not allowed
	if (strcmp(dir, "/") == 0 ||
	    strcmp(dir, "/proc") == 0 ||
	    strcmp(dir, "/sys") == 0)
		whitelist_error(path);

	// whitelisting home directory is disabled if --private option is present
	if (arg_private && strcmp(dir, cfg.homedir) == 0) {
		if (arg_debug || arg_debug_whitelists)
			printf("Debug %d: skip %s - a private home dir is configured!\n", __LINE__, path);
		return NULL;
	}

	// do nothing if directory doesn't exist
	struct stat s;
	if (lstat(dir, &s) != 0) {
		if (arg_debug || arg_debug_whitelists)
			printf("Cannot access whitelist top level directory %s: %s\n", dir, strerror(errno));
		return NULL;
	}
	// do nothing if directory is a link
	if (!S_ISDIR(s.st_mode)) {
		if (S_ISLNK(s.st_mode)) {
			fwarning("skipping whitelist %s because %s is a symbolic link\n", path, dir);
			return NULL;
		}
		whitelist_error(path);
	}
	// do nothing if directory is disabled by administrator
	if (reject_topdir(dir)) {
		fmessage("Whitelist top level directory %s is disabled in Firejail configuration file\n", dir);
		return NULL;
	}

	// add directory to array
	if (arg_debug || arg_debug_whitelists)
		printf("Adding whitelist top level directory %s\n", dir);
	static int cnt = 0;
	if (cnt >= TOP_MAX) {
		fprintf(stderr, "Error: too many whitelist top level directories\n");
		exit(1);
	}
	TopDir *rv = topdirs + cnt;
	cnt++;

	rv->path = strdup(dir);
	if (!rv->path)
		errExit("strdup");

	// open the directory, don't follow symbolic links
	rv->fd = safer_openat(-1, dir, O_PATH|O_NOFOLLOW|O_DIRECTORY|O_CLOEXEC);
	if (rv->fd == -1) {
		fprintf(stderr, "Error: cannot open %s\n", dir);
		exit(1);
	}

	return rv;
}

static TopDir *have_topdir(const char *dir, TopDir *topdirs) {
	assert(dir);

	int i;
	for (i = 0; i < TOP_MAX; i++) {
		TopDir *rv = topdirs + i;
		if (!rv->path)
			break;
		if (strcmp(dir, rv->path) == 0)
			return rv;
	}
	return NULL;
}

static char *extract_topdir(const char *path) {
	assert(path);

	char *dup = strdup(path);
	if (!dup)
		errExit("strdup");

	// user home directory can be anywhere; disconnect user home
	// whitelisting from top level directory whitelisting
	// by treating user home as separate whitelist top level directory
	if (strncmp(dup, cfg.homedir, homedir_len) == 0 && dup[homedir_len] == '/')
		dup[homedir_len] = '\0';
	// /run/user/$UID is treated as top level directory
	else if (strncmp(dup, runuser, runuser_len) == 0 && dup[runuser_len] == '/')
		dup[runuser_len] = '\0';
	// whitelisting in /sys is not allowed, but /sys/module is an exception
	// and is treated as top level directory here
	else if (strncmp(dup, "/sys/module", 11) == 0 && dup[11] == '/')
		dup[11] = '\0';
	// treat /usr subdirectories as top level directories
	else if (strncmp(dup, "/usr/", 5) == 0) {
		char *p = strchr(dup+5, '/');
		if (!p)
			whitelist_error(path);
		*p = '\0';
	}
	// all other top level directories
	else {
		assert(dup[0] == '/');
		char *p = strchr(dup+1, '/');
		if (!p)
			whitelist_error(path);
		*p = '\0';
	}

	return dup;
}

void fs_whitelist(void) {
	EUID_ASSERT();

	ProfileEntry *entry = cfg.profile;
	if (!entry)
		return;

	if (asprintf(&runuser, "/run/user/%u", getuid()) == -1)
		errExit("asprintf");
	runuser_len = strlen(runuser);
	homedir_len = strlen(cfg.homedir);

	size_t nowhitelist_c = 0;
	size_t nowhitelist_m = 32;
	char **nowhitelist = calloc(nowhitelist_m, sizeof(*nowhitelist));
	if (nowhitelist == NULL)
		errExit("calloc");

	TopDir *topdirs = calloc(TOP_MAX, sizeof(*topdirs));
	if (topdirs == NULL)
		errExit("calloc");

	// verify whitelist files, extract symbolic links, etc.
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
		if (arg_debug || arg_debug_whitelists)
			printf("Debug %d: %s\n", __LINE__, entry->data);

		const char *dataptr = (nowhitelist_flag)? entry->data + 12: entry->data + 10;

		// replace ~ into /home/username or resolve macro
		char *expanded = expand_macros(dataptr);

		// check if respolving the macro was successful
		if (is_macro(expanded) && macro_id(expanded) > -1) {
			if (!nowhitelist_flag && (have_topdir(cfg.homedir, topdirs) || add_topdir(cfg.homedir, topdirs, expanded)) && !arg_quiet) {
				fprintf(stderr, "***\n");
				fprintf(stderr, "*** Warning: cannot whitelist %s directory\n", expanded);
				fprintf(stderr, "*** Any file saved in this directory will be lost when the sandbox is closed.\n");
				fprintf(stderr, "***\n");
			}
			entry = entry->next;
			free(expanded);
			continue;
		}

		if (arg_debug || arg_debug_whitelists)
			printf("Debug %d: expanded: %s\n", __LINE__, expanded);

		// path should be absolute at this point
		if (expanded[0] != '/')
			whitelist_error(expanded);

		// sane pathname
		char *new_name = clean_pathname(expanded);
		free(expanded);

		if (arg_debug || arg_debug_whitelists)
			printf("Debug %d: new_name: %s\n", __LINE__, new_name);

		if (strstr(new_name, ".."))
			whitelist_error(new_name);

		TopDir *current_top = NULL;
		if (!nowhitelist_flag) {
			// extract whitelist top level directory
			char *dir = extract_topdir(new_name);
			if (arg_debug || arg_debug_whitelists)
				printf("Debug %d: dir: %s\n", __LINE__, dir);

			// check if this top level directory has been processed already
			current_top = have_topdir(dir, topdirs);
			if (!current_top) { // got new top level directory
				current_top = add_topdir(dir, topdirs, new_name);
				if (!current_top) { // skip this command, top level directory not valid
					entry = entry->next;
					free(new_name);
					free(dir);
					continue;
				}
			}
			free(dir);
		}

		// /run/firejail directory is internal and not allowed
		if (strncmp(new_name, RUN_FIREJAIL_DIR, strlen(RUN_FIREJAIL_DIR)) == 0) {
			entry = entry->next;
			free(new_name);
			continue;
		}

		// extract resolved path of the file
		// realpath function will fail with ENOENT if the file is not found or with EACCES if user has no permission
		// special processing for /dev/fd, /dev/stdin, /dev/stdout and /dev/stderr
		char *fname = NULL;
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
			if (arg_debug || arg_debug_whitelists) {
				printf("Removed path: %s\n", entry->data);
				printf("\tnew_name: %s\n", new_name);
				printf("\trealpath: (null)\n");
				printf("\t%s\n", strerror(errno));
			}

			if (!nowhitelist_flag) {
				// if this is not a real path, let's try globbing
				// push the new paths at the end of profile entry list
				// the new profile entries will be processed in this loop
				// currently there is no globbing support for nowhitelist
				globbing(new_name);
			}

			entry = entry->next;
			free(new_name);
			continue;
		}

		// /run/firejail directory is internal and not allowed
		if (strncmp(fname, RUN_FIREJAIL_DIR, strlen(RUN_FIREJAIL_DIR)) == 0) {
			entry = entry->next;
			free(new_name);
			free(fname);
			continue;
		}

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
			entry = entry->next;
			free(new_name);
			continue;
		}
		else {
			// check if the path is in nowhitelist array
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
				entry = entry->next;
				free(new_name);
				free(fname);
				continue;
			}
		}

		// attach whitelist parameters to profile entry
		entry->wparam = calloc(1, sizeof(struct wparam_t));
		if (!entry->wparam)
			errExit("calloc");

		assert(current_top);
		entry->wparam->top = current_top;
		entry->wparam->file = fname;

		// mark link
		if (is_link(new_name))
			entry->wparam->link = new_name;
		else
			free(new_name);

		entry = entry->next;
	}

	// mount tmpfs on all top level directories
	tmpfs_topdirs(topdirs);

	// go through profile rules again, and interpret whitelist commands
	entry = cfg.profile;
	while (entry) {
		if (entry->wparam) {
			char *file = entry->wparam->file;
			char *link = entry->wparam->link;
			const TopDir * const current_top = entry->wparam->top;

			// top level directories of link and file can differ
			// will whitelist the file only if it is in same top level directory
			whitelist_file(current_top, file);

			// create the link if any
			if (link) {
				whitelist_symlink(current_top, link, file);
				free(link);
			}

			free(file);
			free(entry->wparam);
			entry->wparam = NULL;
		}

		entry = entry->next;
	}

	// release resources
	size_t i;
	for (i = 0; i < nowhitelist_c; i++)
		free(nowhitelist[i]);
	free(nowhitelist);

	for (i = 0; i < TOP_MAX && topdirs[i].path; i++) {
		free(topdirs[i].path);
		close(topdirs[i].fd);
	}
	free(topdirs);
	free(runuser);
}
