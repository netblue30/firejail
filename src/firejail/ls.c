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
#include "../include/gcov_wrapper.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>
#include <dirent.h>
#include <pwd.h>
#include <grp.h>
#include <fcntl.h>
//#include <dirent.h>
//#include <stdio.h>
//#include <stdlib.h>

// uid/gid cache
static uid_t c_uid = 0;
static char *c_uid_name = NULL;

static void print_file_or_dir(const char *path, const char *fname) {
	assert(fname);

	char *name;
	if (asprintf(&name, "%s/%s", path, fname) == -1)
		errExit("asprintf");

	struct stat s;
	if (stat(name, &s) == -1) {
		if (lstat(name, &s) == -1) {
			printf("Error: cannot access %s\n", do_replace_cntrl_chars(name, '?'));
			free(name);
			return;
		}
	}
	free(name);

	// permissions
	if (S_ISLNK(s.st_mode))
		printf("l");
	else if (S_ISDIR(s.st_mode))
		printf("d");
	else if (S_ISCHR(s.st_mode))
		printf("c");
	else if (S_ISBLK(s.st_mode))
		printf("b");
	else if (S_ISSOCK(s.st_mode))
		printf("s");
	else
		printf("-");
	printf( (s.st_mode & S_IRUSR) ? "r" : "-");
	printf( (s.st_mode & S_IWUSR) ? "w" : "-");
	printf( (s.st_mode & S_IXUSR) ? "x" : "-");
	printf( (s.st_mode & S_IRGRP) ? "r" : "-");
	printf( (s.st_mode & S_IWGRP) ? "w" : "-");
	printf( (s.st_mode & S_IXGRP) ? "x" : "-");
	printf( (s.st_mode & S_IROTH) ? "r" : "-");
	printf( (s.st_mode & S_IWOTH) ? "w" : "-");
	printf( (s.st_mode & S_IXOTH) ? "x" : "-");
	printf(" ");

	// user name
	char *username;
	int allocated = 0;
	if (s.st_uid == 0)
		username = "root";
	else if (s.st_uid == c_uid) {
		assert(c_uid_name);
		username = c_uid_name;
	}
	else {
		struct passwd *pw = getpwuid(s.st_uid);
		allocated = 1;
		if (!pw) {
			if (asprintf(&username, "%d", s.st_uid) == -1)
				errExit("asprintf");
		}
		else {
			username = strdup(pw->pw_name);
			if (!username)
				errExit("asprintf");
		}

		if (c_uid == 0) {
			c_uid = s.st_uid;
			c_uid_name = strdup(username);
			if (!c_uid_name)
				errExit("asprintf");
		}
	}

	// print user name, 8 chars maximum
	int len = strlen(username);
	if (len > 8) {
		username[8] = '\0';
		len = 8;
	}
	printf("%s ", username);
	int i;
	for (i = len; i < 8; i++)
		printf(" ");
	if (allocated)
		free(username);


	// group name
	char *groupname;
	allocated = 0;
	if (s.st_uid == 0)
		groupname = "root";
	else {
		struct group *g = getgrgid(s.st_gid);
		allocated = 1;
		if (!g) {
			if (asprintf(&groupname, "%d", s.st_gid) == -1)
				errExit("asprintf");
		}
		else {
			groupname = strdup(g->gr_name);
			if (!groupname)
				errExit("asprintf");
		}
	}

	// print group name, 8 chars maximum
	len = strlen(groupname);
	if (len > 8) {
		groupname[8] = '\0';
		len = 8;
	}
	printf("%s ", groupname);
	for (i = len; i < 8; i++)
		printf(" ");
	if (allocated)
		free(groupname);

	// file size
	char *sz;
	if (asprintf(&sz, "%jd", (intmax_t) s.st_size) == -1)
		errExit("asprintf");

	// file name
	char *fname_print = replace_cntrl_chars(fname, '?');

	printf("%11.10s %s\n", sz, fname_print);
	free(sz);
	free(fname_print);
}

static void print_directory(const char *path) {
	assert(path);
	struct stat s;
	if (stat(path, &s) == -1)
		return;
	assert(S_ISDIR(s.st_mode));

	struct dirent **namelist;
	int i;
	int n;

	n = scandir(path, &namelist, 0, alphasort);
	if (n < 0)
		errExit("scandir");
	else {
		for (i = 0; i < n; i++)
			print_file_or_dir(path, namelist[i]->d_name);
		// get rid of false psitive reported by GCC -fanalyze
		for (i = 0; i < n; i++)
			free(namelist[i]);
	}
	free(namelist);
}

void ls(const char *path) {
	EUID_ASSERT();
	assert(path);

	char *rp = realpath(path, NULL);
	if (!rp || access(rp, R_OK) == -1) {
		fprintf(stderr, "Error: cannot access %s\n", path);
		exit(1);
	}

	// debug doesn't filter control characters currently
	if (arg_debug)
		printf("ls %s\n", rp);

	// list directory contents
	struct stat s;
	if (stat(rp, &s) == -1) {
		fprintf(stderr, "Error: cannot access %s\n", do_replace_cntrl_chars(rp, '?'));
		exit(1);
	}
	if (S_ISDIR(s.st_mode))
		print_directory(rp);
	else {
		char *split = strrchr(rp, '/');
		if (split) {
			*split = '\0';
			char *rp2 = split + 1;
			if (arg_debug)
				printf("path %s, file %s\n", rp, rp2);
			print_file_or_dir(rp, rp2);
		}
	}
	free(rp);
}

void cat(const char *path) {
	EUID_ASSERT();
	assert(path);

	if (arg_debug)
		printf("cat %s\n", path);
	FILE *fp = fopen(path, "re");
	if (!fp) {
		fprintf(stderr, "Error: cannot read %s\n", path);
		exit(1);
	}
	int fd = fileno(fp);
	if (fd == -1)
		errExit("fileno");
	struct stat s;
	if (fstat(fd, &s) == -1)
		errExit("fstat");
	if (!S_ISREG(s.st_mode)) {
		fprintf(stderr, "Error: %s is not a regular file\n", path);
		exit(1);
	}
	int tty = isatty(STDOUT_FILENO);

	int c;
	while ((c = fgetc(fp)) != EOF) {
		// file is untrusted
		// replace control characters when printing to a terminal
		if (tty && iscntrl((unsigned char) c) && c != '\t' && c != '\n')
			c = '?';
		fputc(c, stdout);
	}
	fflush(stdout);
	fclose(fp);
}

char *expand_path(const char *path) {
	char *fname = NULL;
	if (*path == '/') {
		fname = strdup(path);
		if (!fname)
			errExit("strdup");
	}
	else if (*path == '~') {
		if (asprintf(&fname, "%s%s", cfg.homedir, path + 1) == -1)
			errExit("asprintf");
	}
	else {
		// assume the file is in current working directory
		if (!cfg.cwd) {
			fprintf(stderr, "Error: current working directory has been deleted\n");
			exit(1);
		}
		if (asprintf(&fname, "%s/%s", cfg.cwd, path) == -1)
			errExit("asprintf");
	}
	return fname;
}

void sandboxfs(int op, pid_t pid, const char *path1, const char *path2) {
	EUID_ASSERT();
	assert(path1);

	ProcessHandle sandbox = pin_sandbox_process(pid);

	// expand paths
	char *fname1 = expand_path(path1);
	char *fname2 = NULL;
	if (path2 != NULL) {
		fname2 = expand_path(path2);
	}
	if (arg_debug) {
		printf("file1 %s\n", fname1);
		printf("file2 %s\n", fname2 ? fname2 : "(null)");
	}

	// get file from sandbox and store it in the current directory
	// implemented using --cat
	if (op == SANDBOX_FS_GET) {
		char *dest_fname = strrchr(fname1, '/');
		if (!dest_fname || *(++dest_fname) == '\0') {
			fprintf(stderr, "Error: invalid file name %s\n", fname1);
			exit(1);
		}
		// create destination file if necessary
		EUID_ASSERT();
		int dest = open(dest_fname, O_WRONLY|O_CREAT|O_CLOEXEC, S_IRUSR | S_IWUSR);
		if (dest == -1) {
			fprintf(stderr, "Error: cannot open %s for writing\n", dest_fname);
			exit(1);
		}
		struct stat s;
		if (fstat(dest, &s) == -1)
			errExit("fstat");
		if (!S_ISREG(s.st_mode)) {
			fprintf(stderr, "Error: %s is not a regular file\n", dest_fname);
			exit(1);
		}
		if (ftruncate(dest, 0) == -1)
			errExit("ftruncate");
		// go quiet - messages on stdout will corrupt the file
		arg_debug = 0;
		arg_quiet = 1;
		// redirection
		if (dup2(dest, STDOUT_FILENO) == -1)
			errExit("dup2");
		close(dest);
		op = SANDBOX_FS_CAT;
	}

	if (op == SANDBOX_FS_LS || op == SANDBOX_FS_CAT) {
		// chroot into the sandbox
		process_rootfs_chroot(sandbox);
		unpin_process(sandbox);

		// drop privileges
		drop_privs(0);

		if (op == SANDBOX_FS_LS)
			ls(fname1);
		else
			cat(fname1);
	}
	// get file from host and store it in the sandbox
	else if (op == SANDBOX_FS_PUT && path2) {
		char *src_fname = fname1;
		char *dest_fname = fname2;

		EUID_ASSERT();
		int src = open(src_fname, O_RDONLY|O_CLOEXEC);
		if (src == -1) {
			fprintf(stderr, "Error: cannot open %s for reading\n", src_fname);
			exit(1);
		}

		// chroot into the sandbox
		process_rootfs_chroot(sandbox);
		unpin_process(sandbox);

		// drop privileges
		drop_privs(0);

		int dest = open(dest_fname, O_WRONLY|O_CREAT|O_CLOEXEC, S_IRUSR | S_IWUSR);
		if (dest == -1) {
			fprintf(stderr, "Error: cannot open %s for writing\n", dest_fname);
			exit(1);
		}
		struct stat s;
		if (fstat(dest, &s) == -1)
			errExit("fstat");
		if (!S_ISREG(s.st_mode)) {
			fprintf(stderr, "Error: %s is not a regular file\n", dest_fname);
			exit(1);
		}
		if (ftruncate(dest, 0) == -1)
			errExit("ftruncate");

		if (copy_file_by_fd(src, dest) != 0)
			fwarning("an error occurred during copying\n");
		close(src);
		close(dest);
	}

	__gcov_flush();

	exit(0);
}
