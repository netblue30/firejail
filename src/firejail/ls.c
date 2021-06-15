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
#include <sys/wait.h>
#include <unistd.h>
#include <dirent.h>
#include <pwd.h>
#include <grp.h>
#include <fcntl.h>
//#include <dirent.h>
//#include <stdio.h>
//#include <stdlib.h>

#ifdef HAVE_GCOV
#include "../include/gcov_wrapper.h"
#endif

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
			printf("Error: cannot access %s\n", name);
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

	// print grup name, 8 chars maximum
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

	char *sz;
	if (asprintf(&sz, "%d", (int) s.st_size) == -1)
		errExit("asprintf");
	printf("%11.10s %s\n", sz, fname);
	free(sz);

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
	if (arg_debug)
		printf("ls %s\n", rp);

	// list directory contents
	struct stat s;
	if (stat(rp, &s) == -1) {
		fprintf(stderr, "Error: cannot access %s\n", rp);
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
	bool tty = isatty(STDOUT_FILENO);

	int c;
	while ((c = fgetc(fp)) != EOF) {
		// file is untrusted
		// replace control characters when printing to a terminal
		if (tty && c != '\t' && c != '\n' && iscntrl((unsigned char) c))
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

	// in case the pid is that of a firejail process, use the pid of the first child process
	pid = switch_to_child(pid);

	// exit if no permission to join the sandbox
	check_join_permission(pid);

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
		int fd = open(dest_fname, O_WRONLY|O_CREAT|O_CLOEXEC, S_IRUSR | S_IWRITE);
		if (fd == -1) {
			fprintf(stderr, "Error: cannot open %s for writing\n", dest_fname);
			exit(1);
		}
		struct stat s;
		if (fstat(fd, &s) == -1)
			errExit("fstat");
		if (!S_ISREG(s.st_mode)) {
			fprintf(stderr, "Error: %s is no regular file\n", dest_fname);
			exit(1);
		}
		if (ftruncate(fd, 0) == -1)
			errExit("ftruncate");
		// go quiet - messages on stdout will corrupt the file
		arg_debug = 0;
		arg_quiet = 1;
		// redirection
		if (dup2(fd, STDOUT_FILENO) == -1)
			errExit("dup2");
		assert(fd != STDOUT_FILENO);
		close(fd);
		op = SANDBOX_FS_CAT;
	}

	// sandbox root directory
	char *rootdir;
	if (asprintf(&rootdir, "/proc/%d/root", pid) == -1)
		errExit("asprintf");

	if (op == SANDBOX_FS_LS || op == SANDBOX_FS_CAT) {
		EUID_ROOT();
		// chroot
		if (chroot(rootdir) < 0)
			errExit("chroot");
		if (chdir("/") < 0)
			errExit("chdir");

		// drop privileges
		drop_privs(0);

		if (op == SANDBOX_FS_LS)
			ls(fname1);
		else
			cat(fname1);
#ifdef HAVE_GCOV
		__gcov_flush();
#endif
	}
	// get file from host and store it in the sandbox
	else if (op == SANDBOX_FS_PUT && path2) {
		char *src_fname =fname1;
		char *dest_fname = fname2;

		EUID_ROOT();
		if (arg_debug)
			printf("copy %s to %s\n", src_fname, dest_fname);

		// create a user-owned temporary file in /run/firejail directory
		char tmp_fname[] = "/run/firejail/tmpget-XXXXXX";
		int fd = mkstemp(tmp_fname);
		if (fd == -1) {
			fprintf(stderr, "Error: cannot create temporary file %s\n", tmp_fname);
			exit(1);
		}
		SET_PERMS_FD(fd, getuid(), getgid(), 0600);
		close(fd);

		// copy the source file into the temporary file - we need to chroot
		pid_t child = fork();
		if (child < 0)
			errExit("fork");
		if (child == 0) {
			// drop privileges
			drop_privs(0);

			// copy the file
			if (copy_file(src_fname, tmp_fname, getuid(), getgid(), 0600)) // already a regular user
				_exit(1);
#ifdef HAVE_GCOV
			__gcov_flush();
#endif
			_exit(0);
		}

		// wait for the child to finish
		int status = 0;
		waitpid(child, &status, 0);
		if (WIFEXITED(status) && WEXITSTATUS(status) == 0);
		else {
			unlink(tmp_fname);
			exit(1);
		}

		// copy the temporary file into the destination file
		child = fork();
		if (child < 0)
			errExit("fork");
		if (child == 0) {
			// chroot
			if (chroot(rootdir) < 0)
				errExit("chroot");
			if (chdir("/") < 0)
				errExit("chdir");

			// drop privileges
			drop_privs(0);

			// copy the file
			if (copy_file(tmp_fname, dest_fname, getuid(), getgid(), 0600)) // already a regular user
				_exit(1);
#ifdef HAVE_GCOV
			__gcov_flush();
#endif
			_exit(0);
		}

		// wait for the child to finish
		status = 0;
		waitpid(child, &status, 0);
		if (WIFEXITED(status) && WEXITSTATUS(status) == 0);
		else {
			unlink(tmp_fname);
			exit(1);
		}

		// remove the temporary file
		unlink(tmp_fname);
		EUID_USER();
	}

	if (fname2)
		free(fname2);
	free(fname1);
	free(rootdir);

	exit(0);
}
