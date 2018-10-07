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

#include "../include/common.h"
#include <fcntl.h>
#include <ftw.h>
#include <errno.h>
#include <pwd.h>

int arg_quiet = 0;
static int arg_follow_link = 0;

#define COPY_LIMIT (500 * 1024 *1024)
static int size_limit_reached = 0;
static unsigned file_cnt = 0;
static unsigned size_cnt = 0;

static char *outpath = NULL;
static char *inpath = NULL;

// modified version of the function from util.c
static void copy_file(const char *srcname, const char *destname, mode_t mode, uid_t uid, gid_t gid) {
	assert(srcname);
	assert(destname);
	mode &= 07777;

	// don't copy the file if it is already there
	struct stat s;
	if (stat(destname, &s) == 0)
		return;

	// open source
	int src = open(srcname, O_RDONLY);
	if (src < 0) {
		if (!arg_quiet)
			fprintf(stderr, "Warning fcopy: cannot open %s, file not copied\n", srcname);
		return;
	}

	// open destination
	int dst = open(destname, O_CREAT|O_WRONLY|O_TRUNC, 0755);
	if (dst < 0) {
		if (!arg_quiet)
			fprintf(stderr, "Warning fcopy: cannot open %s, file not copied\n", destname);
		close(src);
		return;
	}

	// copy
	ssize_t len;
	static const int BUFLEN = 1024;
	unsigned char buf[BUFLEN];
	while ((len = read(src, buf, BUFLEN)) > 0) {
		int done = 0;
		while (done != len) {
			int rv = write(dst, buf + done, len - done);
			if (rv == -1)
				goto errexit;
			done += rv;
		}
	}
	fflush(0);

	if (fchown(dst, uid, gid) == -1)
		goto errexit;
	if (fchmod(dst, mode) == -1)
		goto errexit;

	close(src);
	close(dst);

	return;

errexit:
	close(src);
	close(dst);
	unlink(destname);
	if (!arg_quiet)
		fprintf(stderr, "Warning fcopy: cannot copy %s\n", destname);
}


// modified version of the function in firejail/util.c
static void mkdir_attr(const char *fname, mode_t mode, uid_t uid, gid_t gid) {
	assert(fname);
	mode &= 07777;

	if (mkdir(fname, mode) == -1 ||
	chmod(fname, mode) == -1) {
		fprintf(stderr, "Error fcopy: failed to create %s directory\n", fname);
		errExit("mkdir/chmod");
	}
	if (chown(fname, uid, gid)) {
		if (!arg_quiet)
			fprintf(stderr, "Warning fcopy: failed to change ownership of %s\n", fname);
	}
}


void copy_link(const char *target, const char *linkpath, mode_t mode, uid_t uid, gid_t gid) {
	(void) mode;
	(void) uid;
	(void) gid;

	// if the link is already there, don't create it
	struct stat s;
	if (stat(linkpath, &s) == 0)
	       return;

	char *rp = realpath(target, NULL);
	if (rp) {
		if (symlink(rp, linkpath) == -1) {
			free(rp);
			goto errout;
		}
		free(rp);
	}
	else
		goto errout;

	return;
errout:
	if (!arg_quiet)
		fprintf(stderr, "Warning fcopy: cannot create symbolic link %s\n", target);
}



static int first = 1;
static int fs_copydir(const char *infname, const struct stat *st, int ftype, struct FTW *sftw) {
	(void) st;
	(void) sftw;
	assert(infname);
	assert(*infname != '\0');
	assert(outpath);
	assert(*outpath != '\0');
	assert(inpath);

	// check size limit
	if (size_limit_reached)
		return 0;

	char *outfname;
	if (asprintf(&outfname, "%s%s", outpath, infname + strlen(inpath)) == -1)
		errExit("asprintf");

	// don't copy it if we already have the file
	struct stat s;
	if (stat(outfname, &s) == 0) {
		if (first)
			first = 0;
		else if (!arg_quiet)
			fprintf(stderr, "Warning fcopy: skipping %s, file already present\n", infname);
		free(outfname);
		return 0;
	}

	// extract mode and ownership
	if (stat(infname, &s) != 0) {
		if (!arg_quiet)
			fprintf(stderr, "Warning fcopy: skipping %s, cannot find inode\n", infname);
		free(outfname);
		return 0;
	}
	uid_t uid = s.st_uid;
	gid_t gid = s.st_gid;
	mode_t mode = s.st_mode;

	// recalculate size
	if ((s.st_size + size_cnt) > COPY_LIMIT) {
		fprintf(stderr, "Error fcopy: size limit of %dMB reached\n", (COPY_LIMIT / 1024) / 1024);
		size_limit_reached = 1;
		free(outfname);
		return 0;
	}

	file_cnt++;
	size_cnt += s.st_size;

	if(ftype == FTW_F) {
		copy_file(infname, outfname, mode, uid, gid);
	}
	else if (ftype == FTW_D) {
		mkdir_attr(outfname, mode, uid, gid);
	}
	else if (ftype == FTW_SL) {
		copy_link(infname, outfname, mode, uid, gid);
	}

	return(0);
}


static char *check(const char *src) {
	struct stat s;
	char *rsrc = realpath(src, NULL);
	if (!rsrc || stat(rsrc, &s) == -1)
		goto errexit;

	// on systems with systemd-resolved installed /etc/resolve.conf is a symlink to
	//    /run/systemd/resolve/resolv.conf; this file is owned by systemd-resolve user
	// checking gid will fail for files with a larger group such as /usr/bin/mutt_dotlock
	uid_t user = getuid();
	if (user == 0 && strncmp(rsrc, "/run/systemd/resolve/", 21) == 0) {
		// check user systemd-resolve
		struct passwd *p = getpwnam("systemd-resolve");
		if (!p)
			goto errexit;
		if (s.st_uid != user && s.st_uid != p->pw_uid)
			goto errexit;
	}
	else {
		if (s.st_uid != user)
			goto errexit;
	}

	// dir, link, regular file
	if (S_ISDIR(s.st_mode) || S_ISREG(s.st_mode) || S_ISLNK(s.st_mode))
		return rsrc;			  // normal exit from the function

errexit:
	fprintf(stderr, "Error fcopy: invalid file %s\n", src);
	exit(1);
}


static void duplicate_dir(const char *src, const char *dest, struct stat *s) {
	(void) s;
	char *rsrc = check(src);
	char *rdest = check(dest);
	inpath = rsrc;
	outpath = rdest;

	// walk
	if(nftw(rsrc, fs_copydir, 1, FTW_PHYS) != 0) {
		fprintf(stderr, "Error: unable to copy file\n");
		exit(1);
	}

	free(rsrc);
	free(rdest);
}


static void duplicate_file(const char *src, const char *dest, struct stat *s) {
	char *rsrc = check(src);
	char *rdest = check(dest);
	uid_t uid = s->st_uid;
	gid_t gid = s->st_gid;
	mode_t mode = s->st_mode;

	// build destination file name
	char *name;
	char *ptr = (arg_follow_link)? strrchr(src, '/'): strrchr(rsrc, '/');
	ptr++;
	if (asprintf(&name, "%s/%s", rdest, ptr) == -1)
		errExit("asprintf");

	// copy
	copy_file(rsrc, name, mode, uid, gid);

	free(name);
	free(rsrc);
	free(rdest);
}


static void duplicate_link(const char *src, const char *dest, struct stat *s) {
	char *rsrc = check(src);		  // we drop the result and use the original name
	char *rdest = check(dest);
	uid_t uid = s->st_uid;
	gid_t gid = s->st_gid;
	mode_t mode = s->st_mode;

	// build destination file name
	char *name;
	//     char *ptr = strrchr(rsrc, '/');
	char *ptr = strrchr(src, '/');
	ptr++;
	if (asprintf(&name, "%s/%s", rdest, ptr) == -1)
		errExit("asprintf");

	// copy
	copy_link(rsrc, name, mode, uid, gid);

	free(name);
	free(rsrc);
	free(rdest);
}


static void usage(void) {
	fputs("Usage: fcopy [--follow-link] src dest\n"
		"\n"
		"Copy SRC to DEST/SRC. SRC may be a file, directory, or symbolic link.\n"
		"If SRC is a directory it is copied recursively.  If it is a symlink,\n"
		"the link itself is duplicated, unless --follow-link is given,\n"
		"in which case the destination of the link is copied.\n"
		"DEST must already exist and must be a directory.\n", stderr);
}


int main(int argc, char **argv) {
#if 0
	{
		//system("cat /proc/self/status");
		int i;
		for (i = 0; i < argc; i++)
			printf("*%s* ", argv[i]);
		printf("\n");
	}
#endif
	char *quiet = getenv("FIREJAIL_QUIET");
	if (quiet && strcmp(quiet, "yes") == 0)
		arg_quiet = 1;

	char *src;
	char *dest;

	if (argc == 3) {
		src = argv[1];
		dest = argv[2];
		arg_follow_link = 0;
	}
	else if (argc == 4 && !strcmp(argv[1], "--follow-link")) {
		src = argv[2];
		dest = argv[3];
		arg_follow_link = 1;
	}
	else {
		fprintf(stderr, "Error: arguments missing\n");
		usage();
		exit(1);
	}

	// trim trailing chars
	if (src[strlen(src) - 1] == '/')
		src[strlen(src) - 1] = '\0';
	if (dest[strlen(dest) - 1] == '/')
		dest[strlen(dest) - 1] = '\0';

	// check the two files; remove ending /
	int len = strlen(src);
	if (src[len - 1] == '/')
		src[len - 1] = '\0';
	if (strcspn(src, "\\*&!?\"'<>%^(){}[];,") != (size_t)len) {
		fprintf(stderr, "Error fcopy: invalid source file name %s\n", src);
		exit(1);
	}

	len = strlen(dest);
	if (dest[len - 1] == '/')
		dest[len - 1] = '\0';
	if (strcspn(dest, "\\*&!?\"'<>%^(){}[];,~") != (size_t)len) {
		fprintf(stderr, "Error fcopy: invalid dest file name %s\n", dest);
		exit(1);
	}

	// the destination should be a directory;
	struct stat s;
	if (stat(dest, &s) == -1) {
		fprintf(stderr, "Error fcopy: dest dir %s: %s\n", dest, strerror(errno));
		exit(1);
	}
	if (!S_ISDIR(s.st_mode)) {
		fprintf(stderr, "Error fcopy: dest %s is not a directory\n", dest);
		exit(1);
	}

	// copy files
	if ((arg_follow_link ? stat : lstat)(src, &s) == -1) {
		fprintf(stderr, "Error fcopy: src %s: %s\n", src, strerror(errno));
		exit(1);
	}

	if (S_ISDIR(s.st_mode))
		duplicate_dir(src, dest, &s);
	else if (S_ISREG(s.st_mode))
		duplicate_file(src, dest, &s);
	else if (S_ISLNK(s.st_mode))
		duplicate_link(src, dest, &s);
	else {
		fprintf(stderr, "Error fcopy: src %s is an unsupported type of file\n", src);
		exit(1);
	}

	return 0;
}
