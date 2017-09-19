/*
 * Copyright (C) 2014-2017 Firejail Authors
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
#include <dirent.h>

// break recursivity on fopen call
typedef FILE *(*orig_fopen_t)(const char *pathname, const char *mode);
static orig_fopen_t orig_fopen = NULL;
typedef FILE *(*orig_fopen64_t)(const char *pathname, const char *mode);
static orig_fopen64_t orig_fopen64 = NULL;

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
// network
//
typedef struct {
	int val;
	char *name;
} XTable;

static XTable socket_type[] = {
#ifdef SOCK_STREAM
	{ SOCK_STREAM, "SOCK_STREAM" },
#endif
#ifdef SOCK_DGRAM
	{ SOCK_DGRAM, "SOCK_DGRAM" },
#endif
#ifdef SOCK_RAW
	{ SOCK_RAW, "SOCK_RAW" },
#endif
#ifdef SOCK_RDM
	{ SOCK_RDM, "SOCK_RDM" },
#endif
#ifdef SOCK_SEQPACKET
	{ SOCK_SEQPACKET, "SOCK_SEQPACKET" },
#endif
#ifdef SOCK_DCCP
	{ SOCK_DCCP, "SOCK_DCCP" },
#endif
	{ 0, NULL} // NULL terminated
};

static XTable socket_domain[] = {
#ifdef AF_INET
	{ AF_INET, "AF_INET" },
#endif
#ifdef AF_INET6
	{ AF_INET6, "AF_INET6" },
#endif
#ifdef AF_LOCAL
	{ AF_LOCAL, "AF_LOCAL" },
#endif
#ifdef AF_PACKET
	{ AF_PACKET, "AF_PACKET" },
#endif
#ifdef AF_IPX
	{ AF_IPX, "AF_IPX" },
#endif
#ifdef AF_NETLINK
	{ AF_NETLINK, "AF_NETLINK" },
#endif
#ifdef AF_X25
	{ AF_X25, "AF_X25" },
#endif
#ifdef AF_AX25
	{ AF_AX25, "AF_AX25" },
#endif
#ifdef AF_ATMPVC
	{ AF_ATMPVC, "AF_ATMPVC" },
#endif
#ifdef AF_APPLETALK
	{ AF_APPLETALK, "AF_APPLETALK" },
#endif
	{ 0, NULL} // NULL terminated
};

static XTable socket_protocol[] = {
#ifdef IPPROTO_IP
	{ IPPROTO_IP, "IPPROTO_IP" },
#endif
#ifdef IPPROTO_ICMP
	{ IPPROTO_ICMP, "IPPROTO_ICMP" },
#endif
#ifdef IPPROTO_IGMP
	{ IPPROTO_IGMP, "IPPROTO_IGMP" },
#endif
#ifdef IPPROTO_IPIP
	{ IPPROTO_IPIP, "IPPROTO_IPIP" },
#endif
#ifdef IPPROTO_TCP
	{ IPPROTO_TCP, "IPPROTO_TCP" },
#endif
#ifdef IPPROTO_EGP
	{ IPPROTO_EGP, "IPPROTO_EGP" },
#endif
#ifdef IPPROTO_PUP
	{ IPPROTO_PUP, "IPPROTO_PUP" },
#endif
#ifdef IPPROTO_UDP
	{ IPPROTO_UDP, "IPPROTO_UDP" },
#endif
#ifdef IPPROTO_IDP
	{ IPPROTO_IDP, "IPPROTO_IDP" },
#endif
#ifdef IPPROTO_DCCP
	{ IPPROTO_DCCP, "IPPROTO_DCCP" },
#endif
#ifdef IPPROTO_RSVP
	{ IPPROTO_RSVP, "IPPROTO_RSVP" },
#endif
#ifdef IPPROTO_GRE
	{ IPPROTO_GRE, "IPPROTO_GRE" },
#endif
#ifdef IPPROTO_IPV6
	{ IPPROTO_IPV6, "IPPROTO_IPV6" },
#endif
#ifdef IPPROTO_ESP
	{ IPPROTO_ESP, "IPPROTO_ESP" },
#endif
#ifdef IPPROTO_AH
	{ IPPROTO_AH, "IPPROTO_AH" },
#endif
#ifdef IPPROTO_BEETPH
	{ IPPROTO_BEETPH, "IPPROTO_BEETPH" },
#endif
#ifdef IPPROTO_PIM
	{ IPPROTO_PIM, "IPPROTO_PIM" },
#endif
#ifdef IPPROTO_COMP
	{ IPPROTO_COMP, "IPPROTO_COMP" },
#endif
#ifdef IPPROTO_SCTP
	{ IPPROTO_SCTP, "IPPROTO_SCTP" },
#endif
#ifdef IPPROTO_UDPLITE
	{ IPPROTO_UDPLITE, "IPPROTO_UDPLITE" },
#endif
#ifdef IPPROTO_RAW
	{ IPPROTO_RAW, "IPPROTO_RAW" },
#endif
	{ 0, NULL} // NULL terminated
};

static char *translate(XTable *table, int val) {
	while (table->name != NULL) {
		if (val == table->val)
			return table->name;
		table++;
	}

	return NULL;
}

static void print_sockaddr(int sockfd, const char *call, const struct sockaddr *addr, int rv) {
	if (addr->sa_family == AF_INET) {
		struct sockaddr_in *a = (struct sockaddr_in *) addr;
		printf("%u:%s:%s %d %s port %u:%d\n", pid(), name(), call, sockfd, inet_ntoa(a->sin_addr), ntohs(a->sin_port), rv);
	}
	else if (addr->sa_family == AF_INET6) {
		struct sockaddr_in6 *a = (struct sockaddr_in6 *) addr;
		char str[INET6_ADDRSTRLEN];
		inet_ntop(AF_INET6, &(a->sin6_addr), str, INET6_ADDRSTRLEN);
		printf("%u:%s:%s %d %s:%d\n", pid(), name(), call, sockfd, str, rv);
	}
	else if (addr->sa_family == AF_UNIX) {
		struct sockaddr_un *a = (struct sockaddr_un *) addr;
		if (a->sun_path[0])
			printf("%u:%s:%s %d %s:%d\n", pid(), name(), call, sockfd, a->sun_path, rv);
		else
			printf("%u:%s:%s %d @%s:%d\n", pid(), name(), call, sockfd, a->sun_path + 1, rv);
	}
	else {
		printf("%u:%s:%s %d family %d:%d\n", pid(), name(), call, sockfd, addr->sa_family, rv);
	}
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

	int rv = orig_open(pathname, flags, mode);
	printf("%u:%s:open %s:%d\n", pid(), name(), pathname, rv);
	return rv;
}

typedef int (*orig_open64_t)(const char *pathname, int flags, mode_t mode);
static orig_open64_t orig_open64 = NULL;
int open64(const char *pathname, int flags, mode_t mode) {
	if (!orig_open64)
		orig_open64 = (orig_open64_t)dlsym(RTLD_NEXT, "open64");

	int rv = orig_open64(pathname, flags, mode);
	printf("%u:%s:open64 %s:%d\n", pid(), name(), pathname, rv);
	return rv;
}

// openat
typedef int (*orig_openat_t)(int dirfd, const char *pathname, int flags, mode_t mode);
static orig_openat_t orig_openat = NULL;
int openat(int dirfd, const char *pathname, int flags, mode_t mode) {
	if (!orig_openat)
		orig_openat = (orig_openat_t)dlsym(RTLD_NEXT, "openat");

	int rv = orig_openat(dirfd, pathname, flags, mode);
	printf("%u:%s:openat %s:%d\n", pid(), name(), pathname, rv);
	return rv;
}

typedef int (*orig_openat64_t)(int dirfd, const char *pathname, int flags, mode_t mode);
static orig_openat64_t orig_openat64 = NULL;
int openat64(int dirfd, const char *pathname, int flags, mode_t mode) {
	if (!orig_openat64)
		orig_openat64 = (orig_openat64_t)dlsym(RTLD_NEXT, "openat64");

	int rv = orig_openat64(dirfd, pathname, flags, mode);
	printf("%u:%s:openat64 %s:%d\n", pid(), name(), pathname, rv);
	return rv;
}


// fopen
FILE *fopen(const char *pathname, const char *mode) {
	if (!orig_fopen)
		orig_fopen = (orig_fopen_t)dlsym(RTLD_NEXT, "fopen");

	FILE *rv = orig_fopen(pathname, mode);
	printf("%u:%s:fopen %s:%p\n", pid(), name(), pathname, rv);
	return rv;
}

#ifdef __GLIBC__
FILE *fopen64(const char *pathname, const char *mode) {
	if (!orig_fopen64)
		orig_fopen64 = (orig_fopen_t)dlsym(RTLD_NEXT, "fopen64");

	FILE *rv = orig_fopen64(pathname, mode);
	printf("%u:%s:fopen64 %s:%p\n", pid(), name(), pathname, rv);
	return rv;
}
#endif /* __GLIBC__ */


// freopen
typedef FILE *(*orig_freopen_t)(const char *pathname, const char *mode, FILE *stream);
static orig_freopen_t orig_freopen = NULL;
FILE *freopen(const char *pathname, const char *mode, FILE *stream) {
	if (!orig_freopen)
		orig_freopen = (orig_freopen_t)dlsym(RTLD_NEXT, "freopen");

	FILE *rv = orig_freopen(pathname, mode, stream);
	printf("%u:%s:freopen %s:%p\n", pid(), name(), pathname, rv);
	return rv;
}

#ifdef __GLIBC__
typedef FILE *(*orig_freopen64_t)(const char *pathname, const char *mode, FILE *stream);
static orig_freopen64_t orig_freopen64 = NULL;
FILE *freopen64(const char *pathname, const char *mode, FILE *stream) {
	if (!orig_freopen64)
		orig_freopen64 = (orig_freopen64_t)dlsym(RTLD_NEXT, "freopen64");

	FILE *rv = orig_freopen64(pathname, mode, stream);
	printf("%u:%s:freopen64 %s:%p\n", pid(), name(), pathname, rv);
	return rv;
}
#endif /* __GLIBC__ */

// unlink
typedef int (*orig_unlink_t)(const char *pathname);
static orig_unlink_t orig_unlink = NULL;
int unlink(const char *pathname) {
	if (!orig_unlink)
		orig_unlink = (orig_unlink_t)dlsym(RTLD_NEXT, "unlink");

	int rv = orig_unlink(pathname);
	printf("%u:%s:unlink %s:%d\n", pid(), name(), pathname, rv);
	return rv;
}

typedef int (*orig_unlinkat_t)(int dirfd, const char *pathname, int flags);
static orig_unlinkat_t orig_unlinkat = NULL;
int unlinkat(int dirfd, const char *pathname, int flags) {
	if (!orig_unlinkat)
		orig_unlinkat = (orig_unlinkat_t)dlsym(RTLD_NEXT, "unlinkat");

	int rv = orig_unlinkat(dirfd, pathname, flags);
	printf("%u:%s:unlinkat %s:%d\n", pid(), name(), pathname, rv);
	return rv;
}

// mkdir/mkdirat/rmdir
typedef int (*orig_mkdir_t)(const char *pathname, mode_t mode);
static orig_mkdir_t orig_mkdir = NULL;
int mkdir(const char *pathname, mode_t mode) {
	if (!orig_mkdir)
		orig_mkdir = (orig_mkdir_t)dlsym(RTLD_NEXT, "mkdir");

	int rv = orig_mkdir(pathname, mode);
	printf("%u:%s:mkdir %s:%d\n", pid(), name(), pathname, rv);
	return rv;
}

typedef int (*orig_mkdirat_t)(int dirfd, const char *pathname, mode_t mode);
static orig_mkdirat_t orig_mkdirat = NULL;
int mkdirat(int dirfd, const char *pathname, mode_t mode) {
	if (!orig_mkdirat)
		orig_mkdirat = (orig_mkdirat_t)dlsym(RTLD_NEXT, "mkdirat");

	int rv = orig_mkdirat(dirfd, pathname, mode);
	printf("%u:%s:mkdirat %s:%d\n", pid(), name(), pathname, rv);
	return rv;
}

typedef int (*orig_rmdir_t)(const char *pathname);
static orig_rmdir_t orig_rmdir = NULL;
int rmdir(const char *pathname) {
	if (!orig_rmdir)
		orig_rmdir = (orig_rmdir_t)dlsym(RTLD_NEXT, "rmdir");

	int rv = orig_rmdir(pathname);
	printf("%u:%s:rmdir %s:%d\n", pid(), name(), pathname, rv);
	return rv;
}

// stat
typedef int (*orig_stat_t)(const char *pathname, struct stat *buf);
static orig_stat_t orig_stat = NULL;
int stat(const char *pathname, struct stat *buf) {
	if (!orig_stat)
		orig_stat = (orig_stat_t)dlsym(RTLD_NEXT, "stat");

	int rv = orig_stat(pathname, buf);
	printf("%u:%s:stat %s:%d\n", pid(), name(), pathname, rv);
	return rv;
}

#ifdef __GLIBC__
typedef int (*orig_stat64_t)(const char *pathname, struct stat64 *buf);
static orig_stat64_t orig_stat64 = NULL;
int stat64(const char *pathname, struct stat64 *buf) {
	if (!orig_stat64)
		orig_stat64 = (orig_stat64_t)dlsym(RTLD_NEXT, "stat64");

	int rv = orig_stat64(pathname, buf);
	printf("%u:%s:stat64 %s:%d\n", pid(), name(), pathname, rv);
	return rv;
}
#endif /* __GLIBC__ */

// lstat
typedef int (*orig_lstat_t)(const char *pathname, struct stat *buf);
static orig_lstat_t orig_lstat = NULL;
int lstat(const char *pathname, struct stat *buf) {
	if (!orig_lstat)
		orig_lstat = (orig_lstat_t)dlsym(RTLD_NEXT, "lstat");

	int rv = orig_lstat(pathname, buf);
	printf("%u:%s:lstat %s:%d\n", pid(), name(), pathname, rv);
	return rv;
}

#ifdef __GLIBC__
typedef int (*orig_lstat64_t)(const char *pathname, struct stat64 *buf);
static orig_lstat64_t orig_lstat64 = NULL;
int lstat64(const char *pathname, struct stat64 *buf) {
	if (!orig_lstat64)
		orig_lstat64 = (orig_lstat64_t)dlsym(RTLD_NEXT, "lstat64");

	int rv = orig_lstat64(pathname, buf);
	printf("%u:%s:lstat64 %s:%d\n", pid(), name(), pathname, rv);
	return rv;
}
#endif /* __GLIBC__ */

// opendir
typedef DIR *(*orig_opendir_t)(const char *pathname);
static orig_opendir_t orig_opendir = NULL;
DIR *opendir(const char *pathname) {
	if (!orig_opendir)
		orig_opendir = (orig_opendir_t)dlsym(RTLD_NEXT, "opendir");

	DIR *rv = orig_opendir(pathname);
	printf("%u:%s:opendir %s:%p\n", pid(), name(), pathname, rv);
	return rv;
}

// access
typedef int (*orig_access_t)(const char *pathname, int mode);
static orig_access_t orig_access = NULL;
int access(const char *pathname, int mode) {
	if (!orig_access)
		orig_access = (orig_access_t)dlsym(RTLD_NEXT, "access");

	int rv = orig_access(pathname, mode);
	printf("%u:%s:access %s:%d\n", pid(), name(), pathname, rv);
	return rv;
}


// connect
typedef int (*orig_connect_t)(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
static orig_connect_t orig_connect = NULL;
int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen) {
	if (!orig_connect)
		orig_connect = (orig_connect_t)dlsym(RTLD_NEXT, "connect");

 	int rv = orig_connect(sockfd, addr, addrlen);
	print_sockaddr(sockfd, "connect", addr, rv);

	return rv;
}

// socket
typedef int (*orig_socket_t)(int domain, int type, int protocol);
static orig_socket_t orig_socket = NULL;
static char buf[1024];
int socket(int domain, int type, int protocol) {
	if (!orig_socket)
		orig_socket = (orig_socket_t)dlsym(RTLD_NEXT, "socket");

	int rv = orig_socket(domain, type, protocol);
	char *ptr = buf;
	ptr += sprintf(ptr, "%u:%s:socket ", pid(), name());
	char *str = translate(socket_domain, domain);
	if (str == NULL)
		ptr += sprintf(ptr, "%d ", domain);
	else
		ptr += sprintf(ptr, "%s ", str);

	int t = type;	// glibc uses higher bits for various other purposes
#ifdef SOCK_CLOEXEC
	t &= ~SOCK_CLOEXEC;
#endif
#ifdef SOCK_NONBLOCK
	t &= ~SOCK_NONBLOCK;
#endif
	str = translate(socket_type, t);
	if (str == NULL)
		ptr += sprintf(ptr, "%d ", type);
	else
		ptr += sprintf(ptr, "%s ", str);

	if (domain == AF_LOCAL)
		sprintf(ptr, "0");
	else {
		str = translate(socket_protocol, protocol);
		if (str == NULL)
			sprintf(ptr, "%d", protocol);
		else
			sprintf(ptr, "%s", str);
	}

	printf("%s:%d\n", buf, rv);
	return rv;
}

// bind
typedef int (*orig_bind_t)(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
static orig_bind_t orig_bind = NULL;
int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen) {
	if (!orig_bind)
		orig_bind = (orig_bind_t)dlsym(RTLD_NEXT, "bind");

	int rv = orig_bind(sockfd, addr, addrlen);
	print_sockaddr(sockfd, "bind", addr, rv);

	return rv;
}

#if 0
typedef int (*orig_accept_t)(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
static orig_accept_t orig_accept = NULL;
int accept(int sockfd, struct sockaddr *addr, socklen_t addrlen) {
	if (!orig_accept)
		orig_accept = (orig_accept_t)dlsym(RTLD_NEXT, "accept");

	int rv = orig_accept(sockfd, addr,  addrlen);
	print_sockaddr(sockfd, "accept", addr, rv);

	return rv;
}
#endif

typedef int (*orig_system_t)(const char *command);
static orig_system_t orig_system = NULL;
int system(const char *command) {
	if (!orig_system)
		orig_system = (orig_system_t)dlsym(RTLD_NEXT, "system");

	int rv = orig_system(command);
	printf("%u:%s:system %s:%d\n", pid(), name(), command, rv);

	return rv;
}

typedef int (*orig_setuid_t)(uid_t uid);
static orig_setuid_t orig_setuid = NULL;
int setuid(uid_t uid) {
	if (!orig_setuid)
		orig_setuid = (orig_setuid_t)dlsym(RTLD_NEXT, "setuid");

	int rv = orig_setuid(uid);
	printf("%u:%s:setuid %d:%d\n", pid(), name(), uid, rv);

	return rv;
}

typedef int (*orig_setgid_t)(gid_t gid);
static orig_setgid_t orig_setgid = NULL;
int setgid(gid_t gid) {
	if (!orig_setgid)
		orig_setgid = (orig_setgid_t)dlsym(RTLD_NEXT, "setgid");

	int rv = orig_setgid(gid);
	printf("%u:%s:setgid %d:%d\n", pid(), name(), gid, rv);

	return rv;
}

typedef int (*orig_setfsuid_t)(uid_t uid);
static orig_setfsuid_t orig_setfsuid = NULL;
int setfsuid(uid_t uid) {
	if (!orig_setfsuid)
		orig_setfsuid = (orig_setfsuid_t)dlsym(RTLD_NEXT, "setfsuid");

	int rv = orig_setfsuid(uid);
	printf("%u:%s:setfsuid %d:%d\n", pid(), name(), uid, rv);

	return rv;
}

typedef int (*orig_setfsgid_t)(gid_t gid);
static orig_setfsgid_t orig_setfsgid = NULL;
int setfsgid(gid_t gid) {
	if (!orig_setfsgid)
		orig_setfsgid = (orig_setfsgid_t)dlsym(RTLD_NEXT, "setfsgid");

	int rv = orig_setfsgid(gid);
	printf("%u:%s:setfsgid %d:%d\n", pid(), name(), gid, rv);

	return rv;
}

typedef int (*orig_setreuid_t)(uid_t ruid, uid_t euid);
static orig_setreuid_t orig_setreuid = NULL;
int setreuid(uid_t ruid, uid_t euid) {
	if (!orig_setreuid)
		orig_setreuid = (orig_setreuid_t)dlsym(RTLD_NEXT, "setreuid");

	int rv = orig_setreuid(ruid, euid);
	printf("%u:%s:setreuid %d %d:%d\n", pid(), name(), ruid, euid, rv);

	return rv;
}

typedef int (*orig_setregid_t)(gid_t rgid, gid_t egid);
static orig_setregid_t orig_setregid = NULL;
int setregid(gid_t rgid, gid_t egid) {
	if (!orig_setregid)
		orig_setregid = (orig_setregid_t)dlsym(RTLD_NEXT, "setregid");

	int rv = orig_setregid(rgid, egid);
	printf("%u:%s:setregid %d %d:%d\n", pid(), name(), rgid, egid, rv);

	return rv;
}

typedef int (*orig_setresuid_t)(uid_t ruid, uid_t euid, uid_t suid);
static orig_setresuid_t orig_setresuid = NULL;
int setresuid(uid_t ruid, uid_t euid, uid_t suid) {
	if (!orig_setresuid)
		orig_setresuid = (orig_setresuid_t)dlsym(RTLD_NEXT, "setresuid");

	int rv = orig_setresuid(ruid, euid, suid);
	printf("%u:%s:setresuid %d %d %d:%d\n", pid(), name(), ruid, euid, suid, rv);

	return rv;
}

typedef int (*orig_setresgid_t)(gid_t rgid, gid_t egid, gid_t sgid);
static orig_setresgid_t orig_setresgid = NULL;
int setresgid(gid_t rgid, gid_t egid, gid_t sgid) {
	if (!orig_setresgid)
		orig_setresgid = (orig_setresgid_t)dlsym(RTLD_NEXT, "setresgid");

	int rv = orig_setresgid(rgid, egid, sgid);
	printf("%u:%s:setresgid %d %d %d:%d\n", pid(), name(), rgid, egid, sgid, rv);

	return rv;
}

// every time a new process is started, this gets called
// it can be used to build things like private-bin
__attribute__((constructor))
static void log_exec(int argc, char** argv) {
	static char buf[PATH_MAX + 1];
	int rv = readlink("/proc/self/exe", buf, PATH_MAX);
	if (rv != -1) {
		buf[rv] = '\0';	// readlink does not add a '\0' at the end
		printf("%u:%s:exec %s:0\n", pid(), name(), buf);
	}
}
