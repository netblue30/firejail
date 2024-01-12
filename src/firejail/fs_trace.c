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
#include <glob.h>
#include <dirent.h>
#include <fcntl.h>
#include <pwd.h>

// create an empty /etc/ld.so.preload
void fs_trace_touch_preload(void) {
	create_empty_file_as_root("/etc/ld.so.preload", S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
}

void fs_trace_touch_or_store_preload(void) {
	struct stat s;

	if (stat("/etc/ld.so.preload", &s) != 0) {
		fs_trace_touch_preload();
		return;
	}

	if (s.st_size == 0)
		return;

	// create a copy of /etc/ld.so.preload
	if (copy_file("/etc/ld.so.preload", RUN_LDPRELOAD_FILE, 0, 0, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)) {
		fprintf(stderr, "Error: cannot copy /etc/ld.so.preload file\n");
		exit(1);
	}
}

void fs_tracefile(void) {
	// create a bind mounted trace logfile that the sandbox can see
	if (arg_debug)
		printf("Creating an empty trace log file: %s\n", arg_tracefile);
	EUID_USER();
	int fd = open(arg_tracefile, O_CREAT|O_WRONLY|O_CLOEXEC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd == -1) {
		perror("open");
		fprintf(stderr, "Error: cannot open trace log file %s for writing\n", arg_tracefile);
		exit(1);
	}
	struct stat s;
	if (fstat(fd, &s) == -1)
		errExit("fstat");
	if (!S_ISREG(s.st_mode)) {
		fprintf(stderr, "Error: cannot write trace log: %s is no regular file\n", arg_tracefile);
		exit(1);
	}
	if (ftruncate(fd, 0) == -1)
		errExit("ftruncate");
	EUID_ROOT();
	FILE *fp = fopen(RUN_TRACE_FILE, "we");
	if (!fp)
		errExit("fopen " RUN_TRACE_FILE);
	fclose(fp);
	fs_logger2("touch", arg_tracefile);
	// mount using the symbolic link in /proc/self/fd
	if (arg_debug)
		printf("Bind mount %s to %s\n", arg_tracefile, RUN_TRACE_FILE);
	if (bind_mount_fd_to_path(fd, RUN_TRACE_FILE))
		errExit("mount bind " RUN_TRACE_FILE);
	close(fd);
	// now that RUN_TRACE_FILE is user-writable, mount it noexec
	fs_remount(RUN_TRACE_FILE, MOUNT_NOEXEC, 0);
}

void fs_trace(void) {
	// create the new ld.so.preload file and mount-bind it
	if (arg_debug)
		printf("Create the new ld.so.preload file\n");

	FILE *fp = fopen(RUN_LDPRELOAD_FILE, "ae");
	if (!fp)
		errExit("fopen");
	const char *prefix = RUN_FIREJAIL_LIB_DIR;

	if (arg_trace) {
		fprintf(fp, "%s/libtrace.so\n", prefix);
	}
	else if (arg_tracelog) {
		fprintf(fp, "%s/libtracelog.so\n", prefix);
		fmessage("Blacklist violations are logged to syslog\n");
	}
	if (arg_seccomp_postexec) {
		fprintf(fp, "%s/libpostexecseccomp.so\n", prefix);
		fmessage("Post-exec seccomp protector enabled\n");
	}

	SET_PERMS_STREAM(fp, 0, 0, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	fclose(fp);

	// mount the new preload file
	if (arg_debug)
		printf("Mount the new ld.so.preload file\n");
	if (mount(RUN_LDPRELOAD_FILE, "/etc/ld.so.preload", NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind ld.so.preload");
	fs_logger("create /etc/ld.so.preload");
}
