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

#include "../include/common.h"
#include <ftw.h>
#include <errno.h>
#include <pwd.h>

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif

#if HAVE_SELINUX
#include <sys/stat.h>
#include <sys/types.h>

#include <selinux/context.h>
#include <selinux/label.h>
#include <selinux/selinux.h>
#endif

int arg_quiet = 0;
int arg_debug = 0;
static int arg_follow_link = 0;

static unsigned long copy_limit = 500 * 1024 * 1024; // 500 MB
static unsigned long size_cnt = 0;
static int size_limit_reached = 0;
static unsigned file_cnt = 0;

static char *outpath = NULL;
static char *inpath = NULL;

#if HAVE_SELINUX
static struct selabel_handle *label_hnd = NULL;
static int selinux_enabled = -1;
#endif

// copy from firejail/selinux.c
static void selinux_relabel_path(const char *path, const char *inside_path) {
	assert(path);
	assert(inside_path);
#if HAVE_SELINUX
	char procfs_path[64];
	char *fcon = NULL;
	int fd;
	struct stat st;

	if (selinux_enabled == -1)
		selinux_enabled = is_selinux_enabled();

	if (!selinux_enabled)
		return;

	if (!label_hnd)
		label_hnd = selabel_open(SELABEL_CTX_FILE, NULL, 0);

	if (!label_hnd)
		errExit("selabel_open");

	/* Open the file as O_PATH, to pin it while we determine and adjust the label */
	fd = open(path, O_NOFOLLOW|O_CLOEXEC|O_PATH);
	if (fd < 0)
		return;
	if (fstat(fd, &st) < 0)
		goto close;

	if (selabel_lookup_raw(label_hnd, &fcon, inside_path, st.st_mode)  == 0) {
		sprintf(procfs_path, "/proc/self/fd/%i", fd);
		if (arg_debug)
			printf("Relabeling %s as %s (%s)\n", path, inside_path, fcon);

		if (setfilecon_raw(procfs_path, fcon) != 0 && arg_debug)
			printf("Cannot relabel %s: %s\n", path, strerror(errno));
	}
	freecon(fcon);
close:
	close(fd);
#else
	(void) path;
	(void) inside_path;
#endif
}

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
	int dst = open(destname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR);
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
	if (len < 0)
		goto errexit;

	if (fchown(dst, uid, gid) == -1)
		goto errexit;
	if (fchmod(dst, mode) == -1)
		goto errexit;

	close(src);
	close(dst);

	selinux_relabel_path(destname, srcname);

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

static char *proc_pid_to_self(const char *target) {
	assert(target);
	char *use_target = 0;
	char *proc_pid = 0;

	if (!(use_target = realpath(target, NULL)))
		goto done;

	// target is under /proc/<PID>?
	static const char proc[] = "/proc/";
	if (strncmp(use_target, proc, sizeof(proc) - 1))
		goto done;

	int digit = use_target[sizeof(proc) - 1];
	if (digit < '1' || digit > '9')
		goto done;

	// check where /proc/self points to
	static const char proc_self[] = "/proc/self";
	proc_pid = realpath(proc_self, NULL);
	if (proc_pid == NULL)
		goto done;

	// redirect /proc/PID/xxx -> /proc/self/XXX
	size_t pfix = strlen(proc_pid);
	if (strncmp(use_target, proc_pid, pfix))
		goto done;

	if (use_target[pfix] != 0 && use_target[pfix] != '/')
		goto done;

	char *tmp;
	if (asprintf(&tmp, "%s%s", proc_self, use_target + pfix) != -1) {
		if (arg_debug)
			fprintf(stderr, "SYMLINK %s\n  -->   %s\n", use_target, tmp);
		free(use_target);
		use_target = tmp;
	}
	else
		errExit("asprintf");

done:
	if (proc_pid)
		free(proc_pid);
	return use_target;
}

void copy_link(const char *target, const char *linkpath, mode_t mode, uid_t uid, gid_t gid) {
	(void) mode;
	(void) uid;
	(void) gid;

	// if the link is already there, don't create it
	struct stat s;
	if (lstat(linkpath, &s) == 0)
		return;

	char *rp = proc_pid_to_self(target);
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
	if (lstat(outfname, &s) == 0) {
		if (first)
			first = 0;
		else if (!arg_quiet)
			fprintf(stderr, "Warning fcopy: skipping %s, file already present\n", infname);
		goto out;
	}

	// extract mode and ownership
	if (lstat(infname, &s) != 0)
		goto out;

	uid_t uid = s.st_uid;
	gid_t gid = s.st_gid;
	mode_t mode = s.st_mode;

	// recalculate size
	if ((s.st_size + size_cnt) > copy_limit) {
		fprintf(stderr, "Error fcopy: size limit of %lu MB reached\n", (copy_limit / 1024) / 1024);
		size_limit_reached = 1;
		goto out;
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
out:
	free(outfname);
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
	free(rsrc);
	fprintf(stderr, "Error fcopy: invalid ownership for file %s\n", src);
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

static const char *const usage_str =
	"Usage: fcopy [--follow-link] src dest\n"
	"\n"
	"Copy SRC to DEST/SRC. SRC may be a file, directory, or symbolic link.\n"
	"If SRC is a directory it is copied recursively.  If it is a symlink,\n"
	"the link itself is duplicated, unless --follow-link is given,\n"
	"in which case the destination of the link is copied.\n"
	"DEST must already exist and must be a directory.\n";

static void usage(void) {
	fputs(usage_str, stderr);
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
	char *debug = getenv("FIREJAIL_DEBUG");
	if (debug && strcmp(debug, "yes") == 0)
		arg_debug = 1;

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

	warn_dumpable();

	// check the two files; remove ending /
	size_t len = strlen(src);
	while (len > 1 && src[len - 1] == '/')
		src[--len] = '\0';
	reject_meta_chars(src, 0);

	len = strlen(dest);
	while (len > 1 && dest[len - 1] == '/')
		dest[--len] = '\0';
	reject_meta_chars(dest, 0);

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

	// extract copy limit size from env variable, if any
	char *cl = getenv("FIREJAIL_FILE_COPY_LIMIT");
	if (cl) {
		copy_limit = strtoul(cl, NULL, 10) * 1024 * 1024;
		if (arg_debug)
			printf("file copy limit %lu bytes\n", copy_limit);
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
