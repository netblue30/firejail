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
#include "../include/firejail_user.h"
#include <sys/mount.h>
#include <sys/stat.h>
#include <fnmatch.h>
#include <glob.h>
#include <dirent.h>
#include <errno.h>

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif

#define MAXBUF 1024

// linked list of users
typedef struct user_list {
	struct user_list *next;
	const char *user;
} USER_LIST;
USER_LIST *ulist = NULL;

static void ulist_add(const char *user) {
	assert(user);

	USER_LIST *nlist = malloc(sizeof(USER_LIST));
	if (!nlist)
		errExit("malloc");
	memset(nlist, 0, sizeof(USER_LIST));
	nlist->user = user;
	nlist->next = ulist;
	ulist = nlist;
}

static USER_LIST *ulist_find(const char *user) {
	assert(user);

	USER_LIST *ptr = ulist;
	while (ptr) {
		if (strcmp(ptr->user, user) == 0)
			return ptr;
		ptr = ptr->next;
	}

	return NULL;
}

static void sanitize_home(void) {
	assert(getuid() != 0);	// this code works only for regular users
	struct stat s;

	if (arg_debug)
		printf("Cleaning /home directory\n");
	// open user home directory in order to keep it around
	int fd = safer_openat(-1, cfg.homedir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1)
		goto errout;
	if (fstat(fd, &s) == -1) { // FUSE
		if (errno != EACCES)
			errExit("fstat");
		close(fd);
		goto errout;
	}

	// mount tmpfs on /home
	if (mount("tmpfs", "/home", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
		errExit("mount tmpfs");
	selinux_relabel_path("/home", "/home");
	fs_logger("tmpfs /home");

	// create new user home directory
	if (mkdir(cfg.homedir, 0755) == -1) {
		if (mkpath_as_root(cfg.homedir) == -1)
			errExit("mkpath");
		if (mkdir(cfg.homedir, 0755) == -1)
			errExit("mkdir");
	}
	fs_logger2("mkdir", cfg.homedir);

	// set mode and ownership
	if (set_perms(cfg.homedir, s.st_uid, s.st_gid, s.st_mode))
		errExit("set_perms");
	selinux_relabel_path(cfg.homedir, cfg.homedir);

	// bring back real user home directory
	if (bind_mount_fd_to_path(fd, cfg.homedir))
		errExit("mount bind");
	close(fd);

	if (!arg_private)
		fs_logger2("whitelist", cfg.homedir);
	return;

errout:
	fwarning("cannot clean /home directory\n");
}

static void sanitize_run(void) {
	if (arg_debug)
		printf("Cleaning /run/user directory\n");

	char *runuser;
	if (asprintf(&runuser, "/run/user/%u", getuid()) == -1)
		errExit("asprintf");

	// open /run/user/$UID directory in order to keep it around
	int fd = open(runuser, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1) {
		if (arg_debug)
			printf("Cannot open %s directory\n", runuser);
		free(runuser);
		return;
	}

	// mount tmpfs on /run/user
	if (mount("tmpfs", "/run/user", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
		errExit("mount tmpfs");
	selinux_relabel_path("/run/user", "/run/user");
	fs_logger("tmpfs /run/user");

	// create new user directory
	if (mkdir(runuser, 0700) == -1)
		errExit("mkdir");
	fs_logger2("mkdir", runuser);

	// set mode and ownership
	if (set_perms(runuser, getuid(), getgid(), 0700))
		errExit("set_perms");
	selinux_relabel_path(runuser, runuser);

	// bring back real run/user/$UID directory
	if (bind_mount_fd_to_path(fd, runuser))
		errExit("mount bind");
	close(fd);

	fs_logger2("whitelist", runuser);
	free(runuser);
}

static void sanitize_passwd(void) {
	struct stat s;
	if (stat("/etc/passwd", &s) == -1)
		return;
	assert(uid_min);
	if (arg_debug)
		printf("Sanitizing /etc/passwd, UID_MIN %d\n", uid_min);
	if (is_link("/etc/passwd")) {
		fprintf(stderr, "Error: invalid /etc/passwd\n");
		exit(1);
	}

	FILE *fpin = NULL;
	FILE *fpout = NULL;

	// open files
	/* coverity[toctou] */
	fpin = fopen("/etc/passwd", "re");
	if (!fpin)
		goto errout;
	fpout = fopen(RUN_PASSWD_FILE, "we");
	if (!fpout)
		goto errout;

	// read the file line by line
	char buf[MAXBUF];
	uid_t myuid = getuid();
	while (fgets(buf, MAXBUF, fpin)) {
		// comments and empty lines
		if (*buf == '\0' || *buf == '#')
			continue;

		// sample line:
		// 	www-data:x:33:33:www-data:/var/www:/bin/sh
		// drop lines with uid > 1000 and not the current user
		char *ptr = buf;

		// advance to uid
		while (*ptr != ':' && *ptr != '\0')
			ptr++;
		if (*ptr == '\0')
			goto errout;
		char *ptr1 = ptr;
		ptr++;
		while (*ptr != ':' && *ptr != '\0')
			ptr++;
		if (*ptr == '\0')
			goto errout;
		ptr++;
		if (*ptr == '\0')
			goto errout;

		// process uid
		int uid = -1;
		int rv = sscanf(ptr, "%d:", &uid);
		if (rv != 1 || uid < 0)
			goto errout;
		assert(uid_min);
		if (uid < uid_min || uid == 65534) { // on Debian platforms user nobody is 65534
			fprintf(fpout, "%s", buf);
			continue;
		}
		if ((uid_t) uid != myuid) {
			// store user name - necessary to process /etc/group
			*ptr1 = '\0';
			char *user = strdup(buf);
			if (!user)
				errExit("malloc");
			ulist_add(user);
			continue; // skip line
		}
		fprintf(fpout, "%s", buf);
	}
	fclose(fpin);
	SET_PERMS_STREAM(fpout, 0, 0, 0644);
	fclose(fpout);

	// mount-bind the new password file
	if (mount(RUN_PASSWD_FILE, "/etc/passwd", "none", MS_BIND, "mode=400,gid=0") < 0)
		errExit("mount");

	// blacklist RUN_PASSWD_FILE
	if (mount(RUN_RO_FILE, RUN_PASSWD_FILE, "none", MS_BIND, "mode=400,gid=0") < 0)
		errExit("mount");

	fs_logger("create /etc/passwd");

	return;

errout:
	fwarning("failed to clean up /etc/passwd\n");
	if (fpin)
		fclose(fpin);
	if (fpout)
		fclose(fpout);
}

// returns 1 if fails, 0 if OK
static int copy_line(FILE *fpout, char *buf, char *ptr) {
	// fpout: GROUP_FILE
	// buf: pulse:x:115:netblue,bingo
	// ptr: 115:neblue,bingo

	while (*ptr != ':' && *ptr != '\0')
		ptr++;
	if (*ptr == '\0')
		return 1;

	ptr++;
	if (*ptr == '\n' || *ptr == '\0') {
		fprintf(fpout, "%s", buf);
		return 0;
	}

	// print what we have so far
	char tmp = *ptr;
	*ptr = '\0';
	fprintf(fpout, "%s", buf);
	*ptr = tmp;

	// tokenize
	char *token = strtok(ptr, ",\n");
	int first = 1;
	while (token) {
		char *newtoken = strtok(NULL, ",\n");
		if (ulist_find(token)) {
			//skip
			token = newtoken;
			continue;
		}
		if (!first)
			fprintf(fpout, ",");
		first = 0;
		fprintf(fpout, "%s", token);
		token = newtoken;
	}
	fprintf(fpout, "\n");
	return 0;
}

static void sanitize_group(void) {
	struct stat s;
	if (stat("/etc/group", &s) == -1)
		return;
	assert(gid_min);
	if (arg_debug)
		printf("Sanitizing /etc/group, GID_MIN %d\n", gid_min);
	if (is_link("/etc/group")) {
		fprintf(stderr, "Error: invalid /etc/group\n");
		exit(1);
	}

	FILE *fpin = NULL;
	FILE *fpout = NULL;

	// open files
	/* coverity[toctou] */
	fpin = fopen("/etc/group", "re");
	if (!fpin)
		goto errout;
	fpout = fopen(RUN_GROUP_FILE, "we");
	if (!fpout)
		goto errout;

	// read the file line by line
	char buf[MAXBUF];
	gid_t mygid = getgid();
	while (fgets(buf, MAXBUF, fpin)) {
		// comments and empty lines
		if (*buf == '\0' || *buf == '#')
			continue;

		// sample line:
		// 	pulse:x:115:netblue,bingo
		// drop lines with uid > 1000 and not the current user group
		char *ptr = buf;

		// advance to uid
		while (*ptr != ':' && *ptr != '\0')
			ptr++;
		if (*ptr == '\0')
			goto errout;
		ptr++;
		while (*ptr != ':' && *ptr != '\0')
			ptr++;
		if (*ptr == '\0')
			goto errout;
		ptr++;
		if (*ptr == '\0')
			goto errout;

		// process uid
		int gid = -1;
		int rv = sscanf(ptr, "%d:", &gid);
		if (rv != 1 || gid < 0)
			goto errout;
		assert(gid_min);
		if (gid < gid_min || gid == 65534) { // on Debian platforms 65534 is group nogroup
			if (copy_line(fpout, buf, ptr))
				goto errout;
			continue;
		}
		if ((gid_t) gid != mygid) {
			continue; // skip line
		}
		if (copy_line(fpout, buf, ptr))
			goto errout;
	}
	fclose(fpin);
	SET_PERMS_STREAM(fpout, 0, 0, 0644);
	fclose(fpout);

	// mount-bind the new group file
	if (mount(RUN_GROUP_FILE, "/etc/group", "none", MS_BIND, "mode=400,gid=0") < 0)
		errExit("mount");

	// blacklist RUN_GROUP_FILE
	if (mount(RUN_RO_FILE, RUN_GROUP_FILE, "none", MS_BIND, "mode=400,gid=0") < 0)
		errExit("mount");

	fs_logger("create /etc/group");

	return;

errout:
	fwarning("failed to clean up /etc/group\n");
	if (fpin)
		fclose(fpin);
	if (fpout)
		fclose(fpout);
}

void restrict_users(void) {
	if (arg_allusers)
		return;

	// only in user mode
	if (getuid()) {
		if (strncmp(cfg.homedir, "/home/", 6) == 0) {
			// user has the home directory under /home
			sanitize_home();
		}
		else {
			// user has the home directory outside /home
			// mount tmpfs on top of /home in order to hide it
			if (mount("tmpfs", "/home", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
				errExit("mount tmpfs");
			fs_logger("tmpfs /home");
		}
		sanitize_run();
		sanitize_passwd();
		sanitize_group();
	}
}
