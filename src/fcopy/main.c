/*
 * Copyright (C) 2014-2016 Firejail Authors
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
	
	// open source
	int src = open(srcname, O_RDONLY);
	if (src < 0) {
		fprintf(stderr, "Warning fcopy: cannot open %s, file not copied\n", srcname);
		return;
	}

	// open destination
	int dst = open(destname, O_CREAT|O_WRONLY|O_TRUNC, 0755);
	if (dst < 0) {
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
	if (chown(fname, uid, gid))
	    	fprintf(stderr, "Warning fcopy: failed to change ownership of %s\n", fname);
}

void copy_link(const char *target, const char *linkpath, mode_t mode, uid_t uid, gid_t gid) {
	(void) mode;
	(void) uid;
	(void) gid;
	char *rp = realpath(target, NULL);
	if (rp) {
		if (symlink(rp, linkpath) == -1)
			goto errout;
		free(rp);
	}
	else
		goto errout;

	return;
errout:
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

//printf("outpaht %s\n", outpath);
//printf("inpath %s\n", inpath);
//printf("infname %s\n", infname);
//printf("outfname %s\n\n", outfname);

	// don't copy it if we already have the file
	struct stat s;
	if (stat(outfname, &s) == 0) {
		if (first)
			first = 0;
		else	
		    	fprintf(stderr, "Warning fcopy: skipping %s, file already present\n", infname);
		free(outfname);
		return 0;
	}
	
	// extract mode and ownership
	if (stat(infname, &s) != 0) {
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

	// check uid
	if (s.st_uid != getuid() || s.st_gid != getgid())
		goto errexit;

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
	char *ptr = strrchr(rsrc, '/');
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
	char *rsrc = check(src); // we drop the result and use the original name
	char *rdest = check(dest);
	uid_t uid = s->st_uid;
	gid_t gid = s->st_gid;
	mode_t mode = s->st_mode;
	
	// build destination file name
	char *name;
//	char *ptr = strrchr(rsrc, '/');
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
	printf("Usage: fcopy src dest\n");
	printf("Copy src file in dest directory. If src is a directory, copy all the files in\n");
	printf("src recoursively. If the destination directory does not exist, it will be created.\n");
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
	if (argc != 3) {
		fprintf(stderr, "Error fcopy: files missing\n");
		usage();
		exit(1);
	}
	
	// check the two files; remove ending /
	char *src = argv[1];
	int len = strlen(src);
	if (src[len - 1] == '/')
		src[len - 1] = '\0';
	if (strcspn(src, "\\*&!?\"'<>%^(){}[];,") != (size_t)len) {
		fprintf(stderr, "Error fcopy: invalid file name %s\n", src);
		exit(1);
	}
	
	char *dest = argv[2];
	len = strlen(dest);
	if (dest[len - 1] == '/')
		dest[len - 1] = '\0';
	if (strcspn(dest, "\\*&!?\"'<>%^(){}[];,~") != (size_t)len) {
		fprintf(stderr, "Error fcopy: invalid file name %s\n", dest);
		exit(1);
	}
	

	// the destination should be a directory; 
	struct stat s;
	if (stat(dest, &s) == -1 ||
	    !S_ISDIR(s.st_mode)) {
		fprintf(stderr, "Error fcopy: invalid destination directory\n");
		exit(1);
	}
	
	// copy files
	if (lstat(src, &s) == -1) {
		fprintf(stderr, "Error fcopy: cannot find source file\n");
		exit(1);
	}

	if (S_ISDIR(s.st_mode))
		duplicate_dir(src, dest, &s);
	else if (S_ISREG(s.st_mode))
		duplicate_file(src, dest, &s);
	else if (S_ISLNK(s.st_mode))
		duplicate_link(src, dest, &s);
	else {
		fprintf(stderr, "Error fcopy: source file unsupported\n");
		exit(1);
	}
		
	return 0;
}
