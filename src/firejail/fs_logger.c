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
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#define MAXBUF 4098

typedef struct fs_msg_t {
	struct fs_msg_t *next;
	char *msg;
} FsMsg;

static FsMsg *head = NULL;

static inline FsMsg *newmsg(void) {
	FsMsg *ptr = malloc(sizeof(FsMsg));
	if (!ptr)
		errExit("malloc");
	memset(ptr, 0, sizeof(FsMsg));
	return ptr;
}

static inline void insertmsg(FsMsg *ptr) {
	static FsMsg *last = NULL;
	if (head == NULL) {
		head = ptr;
		last = ptr;
		return;
	}

	assert(last);
	last->next = ptr;
	last = ptr;
}

void fs_logger(const char *msg) {
	FsMsg *ptr = newmsg();
	ptr->msg = strdup(msg);
	if (!ptr->msg)
		errExit("strdup");
	insertmsg(ptr);
}

void fs_logger2(const char *msg1, const char *msg2) {
	FsMsg *ptr = newmsg();
	char *str;
	if (asprintf(&str, "%s %s", msg1, msg2) == -1)
		errExit("asprintf");
	ptr->msg = str;
	insertmsg(ptr);
}

void fs_logger2int(const char *msg1, int d) {
	FsMsg *ptr = newmsg();
	char *str;
	if (asprintf(&str, "%s %d", msg1, d) == -1)
		errExit("asprintf");
	ptr->msg = str;
	insertmsg(ptr);
}

void fs_logger3(const char *msg1, const char *msg2, const char *msg3) {
	FsMsg *ptr = newmsg();
	char *str;
	if (asprintf(&str, "%s %s %s", msg1, msg2, msg3) == -1)
		errExit("asprintf");
	ptr->msg = str;
	insertmsg(ptr);
}

void fs_logger_print(void) {
	if (!head)
		return;

	FILE *fp = fopen(RUN_FSLOGGER_FILE, "a");
	if (!fp) {
		perror("fopen");
		return;
	}
	SET_PERMS_STREAM_NOERR(fp, getuid(), getgid(), 0644);

	FsMsg *ptr = head;
	while (ptr) {
		fprintf(fp, "%s\n", ptr->msg);
		FsMsg *next = ptr->next;
		// remove message
		free(ptr->msg);
		free(ptr);
		ptr = next;
	}
	head = NULL;
	fclose(fp);
}

void fs_logger_change_owner(void) {
	if (chown(RUN_FSLOGGER_FILE, 0, 0) == -1)
		errExit("chown");
}

void fs_logger_print_log(pid_t pid) {
	EUID_ASSERT();

	// in case the pid is that of a firejail process, use the pid of the first child process
	pid = switch_to_child(pid);

	// check privileges for non-root users
	uid_t uid = getuid();
	if (uid != 0) {
		uid_t sandbox_uid = pid_get_uid(pid);
		if (uid != sandbox_uid) {
			fprintf(stderr, "Error: permission denied\n");
			exit(1);
		}
	}

	// print RUN_FSLOGGER_FILE
	char *fname;
	if (asprintf(&fname, "/proc/%d/root%s", pid, RUN_FSLOGGER_FILE) == -1)
		errExit("asprintf");

	EUID_ROOT();
	struct stat s;
	if (stat(fname, &s) == -1 || s.st_uid != 0) {
		fprintf(stderr, "Error: Cannot access filesystem log\n");
		exit(1);
	}

	/* coverity[toctou] */
	FILE *fp = fopen(fname, "r");
	if (!fp) {
		fprintf(stderr, "Error: Cannot open filesystem log\n");
		exit(1);
	}

	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp))
		printf("%s", buf);
	fclose(fp);
	free(fname);

	exit(0);
}
