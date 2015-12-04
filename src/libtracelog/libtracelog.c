/*
 * Copyright (C) 2014, 2015 Firejail Authors
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
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/un.h>
#include <sys/stat.h>
#include <syslog.h>
#include <dirent.h>

//#define DEBUG

// break recursivity on fopen call
typedef FILE *(*orig_fopen_t)(const char *pathname, const char *mode);
static orig_fopen_t orig_fopen = NULL;
typedef FILE *(*orig_fopen64_t)(const char *pathname, const char *mode);
static orig_fopen64_t orig_fopen64 = NULL;

//
// blacklist storage
//
typedef struct list_elem_t {
	struct list_elem_t *next;
	char *path;
} ListElem;

#define HMASK 0x0ff
ListElem *storage[HMASK + 1];

// djb2 
static inline uint32_t hash(const char *str) {
	uint32_t hash = 5381;
	int c;

	while ((c = *str++) != '\0')
		hash = ((hash << 5) + hash) + c; // hash * 33 + c; another variant would be hash * 33 ^ c

	return hash & HMASK;
}

static storage_add(const char *str) {
	ListElem *ptr = malloc(sizeof(ListElem));
	if (!ptr) {
		fprintf(stderr, "Error: cannot allocate memory\n");
		return;
	}
	ptr->path = strdup(str);
	if (!ptr->path) {
		fprintf(stderr, "Error: cannot allocate memory\n");
		return;
	}
	
	// insert it into the hash table
	uint32_t h = hash(ptr->path);
	ptr->next = storage[h];
	storage[h] = ptr;
}

static char *storage_find(const char *str) {
	const char *tofind = str;
	int allocated = 0;

	if (strstr(str, "..") || strstr(str, "/./")) {
		tofind = realpath(str, NULL);
		allocated = 1;
	}

	uint32_t h = hash(tofind);
	ListElem *ptr = storage[h];
	while (ptr) {
		if (strcmp(tofind, ptr->path) == 0) {
			if (allocated)
				free((char *) tofind);
			return ptr->path;
		}
		ptr = ptr->next;
	}
	
	if (allocated)
		free((char *) tofind);
	return NULL;
}


//
// load blacklistst form /run/firejail/mnt/fslogger
//
#define RUN_FSLOGGER_FILE		"/run/firejail/mnt/fslogger"
#define MAXBUF 4096
static int blacklist_loaded = 0;
static char *sandbox_pid_str = 0;
static char *sandbox_name_str = NULL;
void load_blacklist(void) {
	if (blacklist_loaded)
		return;
	
	// open filesystem log
	if (!orig_fopen)
		orig_fopen = (orig_fopen_t)dlsym(RTLD_NEXT, "fopen");
	FILE *fp = orig_fopen(RUN_FSLOGGER_FILE, "r");
	if (!fp)
		return;

	// extract blacklists
	char buf[MAXBUF];
	int cnt = 0;
	while (fgets(buf, MAXBUF, fp)) {
		if (strncmp(buf, "sandbox pid: ", 13) == 0) {
			char *ptr = strchr(buf, '\n');
			if (ptr)
				*ptr = '\0';
			sandbox_pid_str = strdup(buf + 13);
		}
		else if (strncmp(buf, "sandbox name: ", 14) == 0) {
			char *ptr = strchr(buf, '\n');
			if (ptr)
				*ptr = '\0';
			sandbox_name_str = strdup(buf + 14);
		}
		else if (strncmp(buf, "blacklist ", 10) == 0) {
			char *ptr = strchr(buf, '\n');
			if (ptr)
				*ptr = '\0';
			storage_add(buf + 10);
			cnt++;
		}
	}
	fclose(fp);
	blacklist_loaded = 1;
#ifdef DEBUG	
	printf("Monitoring %d blacklists\n", cnt);
	{
		int i;
		for (i = 0; i <= HMASK; i++) {
			int cnt = 0;
			ListElem *ptr = storage[i];
			while (ptr) {
				cnt++;
				ptr = ptr->next;
			}
			
			if ((i % 16) == 0)
				printf("\n");
			printf("%02d ", cnt);
		}
		printf("\n");
	}
#endif
}


static void sendlog(const char *name, const char *call, const char *path) {
	openlog ("firejail", LOG_CONS | LOG_PID | LOG_NDELAY, LOG_LOCAL1);
	if (sandbox_pid_str && sandbox_name_str)
		syslog (LOG_INFO, "blacklist violation - sandbox %s, name %s, exe %s, syscall %s, path %s",
			sandbox_pid_str, sandbox_name_str, name, call, path);
	else if (sandbox_pid_str)
		syslog (LOG_INFO, "blacklist violation - sandbox %s, exe %s, syscall %s, path %s",
			sandbox_pid_str, name, call, path);
	else
		syslog (LOG_INFO, "blacklist violation - exe %s, syscall %s, path %s",
			name, call, path);
	closelog ();
}


//
// pid
//
static pid_t mypid = 0;
static inline pid_t pid(void) {
	if (!mypid)
		mypid = getpid();
	return mypid;
}

//
// process name
//
#define MAXNAME 16
static char myname[MAXNAME];
static int nameinit = 0;
static char *name(void) {
	if (!nameinit) {
		
		// initialize the name of the process based on /proc/PID/comm
		memset(myname, 0, MAXNAME);
		
		pid_t p = pid();
		char *fname;
		if (asprintf(&fname, "/proc/%u/comm", p) == -1)
			return "unknown";

		// read file
		if (!orig_fopen)
			orig_fopen = (orig_fopen_t)dlsym(RTLD_NEXT, "fopen");
		FILE *fp  = orig_fopen(fname, "r");
		if (!fp)
			return "unknown";
		if (fgets(myname, MAXNAME, fp) == NULL) {
			fclose(fp);
			free(fname);
			return "unknown";
		}
		
		// clean '\n'
		char *ptr = strchr(myname, '\n');
		if (ptr)
			*ptr = '\0';
			
		fclose(fp);
		free(fname);
		nameinit = 1;
	}
	
	return myname;
}

//
// syscalls
//

// open
typedef int (*orig_open_t)(const char *pathname, int flags, mode_t mode);
static orig_open_t orig_open = NULL;
int open(const char *pathname, int flags, mode_t mode) {
	if (!orig_open)
		orig_open = (orig_open_t)dlsym(RTLD_NEXT, "open");
	
	if (!blacklist_loaded)
		load_blacklist();
		
	int rv = orig_open(pathname, flags, mode);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}

typedef int (*orig_open64_t)(const char *pathname, int flags, mode_t mode);
static orig_open64_t orig_open64 = NULL;
int open64(const char *pathname, int flags, mode_t mode) {
	if (!orig_open64)
		orig_open64 = (orig_open64_t)dlsym(RTLD_NEXT, "open64");
	if (!blacklist_loaded)
		load_blacklist();
		
	int rv = orig_open64(pathname, flags, mode);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}

// openat
typedef int (*orig_openat_t)(int dirfd, const char *pathname, int flags, mode_t mode);
static orig_openat_t orig_openat = NULL;
int openat(int dirfd, const char *pathname, int flags, mode_t mode) {
	if (!orig_openat)
		orig_openat = (orig_openat_t)dlsym(RTLD_NEXT, "openat");
	if (!blacklist_loaded)
		load_blacklist();
		
	int rv = orig_openat(dirfd, pathname, flags, mode);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}

typedef int (*orig_openat64_t)(int dirfd, const char *pathname, int flags, mode_t mode);
static orig_openat64_t orig_openat64 = NULL;
int openat64(int dirfd, const char *pathname, int flags, mode_t mode) {
	if (!orig_openat64)
		orig_openat64 = (orig_openat64_t)dlsym(RTLD_NEXT, "openat64");
	if (!blacklist_loaded)
		load_blacklist();
		
	int rv = orig_openat64(dirfd, pathname, flags, mode);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}


// fopen
FILE *fopen(const char *pathname, const char *mode) {
	if (!orig_fopen)
		orig_fopen = (orig_fopen_t)dlsym(RTLD_NEXT, "fopen");
	if (!blacklist_loaded)
		load_blacklist();
		
	FILE *rv = orig_fopen(pathname, mode);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}

#ifdef __GLIBC__
FILE *fopen64(const char *pathname, const char *mode) {
	if (!orig_fopen64)
		orig_fopen64 = (orig_fopen_t)dlsym(RTLD_NEXT, "fopen64");
	if (!blacklist_loaded)
		load_blacklist();
		
	FILE *rv = orig_fopen64(pathname, mode);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}
#endif /* __GLIBC__ */


// freopen
typedef FILE *(*orig_freopen_t)(const char *pathname, const char *mode, FILE *stream);
static orig_freopen_t orig_freopen = NULL;
FILE *freopen(const char *pathname, const char *mode, FILE *stream) {
	if (!orig_freopen)
		orig_freopen = (orig_freopen_t)dlsym(RTLD_NEXT, "freopen");
	if (!blacklist_loaded)
		load_blacklist();
		
	FILE *rv = orig_freopen(pathname, mode, stream);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}

#ifdef __GLIBC__
typedef FILE *(*orig_freopen64_t)(const char *pathname, const char *mode, FILE *stream);
static orig_freopen64_t orig_freopen64 = NULL;
FILE *freopen64(const char *pathname, const char *mode, FILE *stream) {
	if (!orig_freopen64)
		orig_freopen64 = (orig_freopen64_t)dlsym(RTLD_NEXT, "freopen64");
	if (!blacklist_loaded)
		load_blacklist();
		
	FILE *rv = orig_freopen64(pathname, mode, stream);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}
#endif /* __GLIBC__ */

// unlink
typedef int (*orig_unlink_t)(const char *pathname);
static orig_unlink_t orig_unlink = NULL;
int unlink(const char *pathname) {
	if (!orig_unlink)
		orig_unlink = (orig_unlink_t)dlsym(RTLD_NEXT, "unlink");
	if (!blacklist_loaded)
		load_blacklist();
		
	int rv = orig_unlink(pathname);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}

typedef int (*orig_unlinkat_t)(int dirfd, const char *pathname, int flags);
static orig_unlinkat_t orig_unlinkat = NULL;
int unlinkat(int dirfd, const char *pathname, int flags) {
	if (!orig_unlinkat)
		orig_unlinkat = (orig_unlinkat_t)dlsym(RTLD_NEXT, "unlinkat");
	if (!blacklist_loaded)
		load_blacklist();
		
	int rv = orig_unlinkat(dirfd, pathname, flags);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}

// mkdir/mkdirat/rmdir
typedef int (*orig_mkdir_t)(const char *pathname, mode_t mode);
static orig_mkdir_t orig_mkdir = NULL;
int mkdir(const char *pathname, mode_t mode) {
	if (!orig_mkdir)
		orig_mkdir = (orig_mkdir_t)dlsym(RTLD_NEXT, "mkdir");
	if (!blacklist_loaded)
		load_blacklist();
		
	int rv = orig_mkdir(pathname, mode);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}

typedef int (*orig_mkdirat_t)(int dirfd, const char *pathname, mode_t mode);
static orig_mkdirat_t orig_mkdirat = NULL;
int mkdirat(int dirfd, const char *pathname, mode_t mode) {
	if (!orig_mkdirat)
		orig_mkdirat = (orig_mkdirat_t)dlsym(RTLD_NEXT, "mkdirat");
	if (!blacklist_loaded)
		load_blacklist();
		
	int rv = orig_mkdirat(dirfd, pathname, mode);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}

typedef int (*orig_rmdir_t)(const char *pathname);
static orig_rmdir_t orig_rmdir = NULL;
int rmdir(const char *pathname) {
	if (!orig_rmdir)
		orig_rmdir = (orig_rmdir_t)dlsym(RTLD_NEXT, "rmdir");
	if (!blacklist_loaded)
		load_blacklist();
		
	int rv = orig_rmdir(pathname);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}

// stat
typedef int (*orig_stat_t)(const char *pathname, struct stat *buf);
static orig_stat_t orig_stat = NULL;
int stat(const char *pathname, struct stat *buf) {
	if (!orig_stat)
		orig_stat = (orig_stat_t)dlsym(RTLD_NEXT, "stat");
	if (!blacklist_loaded)
		load_blacklist();
			
	int rv = orig_stat(pathname, buf);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}

#ifdef __GLIBC__
typedef int (*orig_stat64_t)(const char *pathname, struct stat64 *buf);
static orig_stat64_t orig_stat64 = NULL;
int stat64(const char *pathname, struct stat64 *buf) {
	if (!orig_stat)
		orig_stat64 = (orig_stat64_t)dlsym(RTLD_NEXT, "stat64");
	if (!blacklist_loaded)
		load_blacklist();
			
	int rv = orig_stat64(pathname, buf);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}
#endif /* __GLIBC__ */

typedef int (*orig_lstat_t)(const char *pathname, struct stat *buf);
static orig_lstat_t orig_lstat = NULL;
int lstat(const char *pathname, struct stat *buf) {
	if (!orig_lstat)
		orig_lstat = (orig_lstat_t)dlsym(RTLD_NEXT, "lstat");
	if (!blacklist_loaded)
		load_blacklist();
			
	int rv = orig_lstat(pathname, buf);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}

#ifdef __GLIBC__
typedef int (*orig_lstat64_t)(const char *pathname, struct stat64 *buf);
static orig_lstat64_t orig_lstat64 = NULL;
int lstat64(const char *pathname, struct stat64 *buf) {
	if (!orig_lstat)
		orig_lstat64 = (orig_lstat64_t)dlsym(RTLD_NEXT, "lstat64");
	if (!blacklist_loaded)
		load_blacklist();
			
	int rv = orig_lstat64(pathname, buf);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}
#endif /* __GLIBC__ */

// access
typedef int (*orig_access_t)(const char *pathname, int mode);
static orig_access_t orig_access = NULL;
int access(const char *pathname, int mode) {
	if (!orig_access)
		orig_access = (orig_access_t)dlsym(RTLD_NEXT, "access");
	if (!blacklist_loaded)
		load_blacklist();
			
	int rv = orig_access(pathname, mode);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}

// opendir
typedef DIR *(*orig_opendir_t)(const char *pathname);
static orig_opendir_t orig_opendir = NULL;
DIR *opendir(const char *pathname) {
	if (!orig_opendir)
		orig_opendir = (orig_opendir_t)dlsym(RTLD_NEXT, "opendir");
	if (!blacklist_loaded)
		load_blacklist();
			
	DIR *rv = orig_opendir(pathname);
	if (storage_find(pathname))
		sendlog(name(), __FUNCTION__, pathname);
	return rv;
}


