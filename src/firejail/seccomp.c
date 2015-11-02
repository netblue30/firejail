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

#ifdef HAVE_SECCOMP
#include "firejail.h"
#include "seccomp.h"

#define SECSIZE 128 // initial filter size
static struct sock_filter *sfilter = NULL;
static int sfilter_alloc_size = 0;
static int sfilter_index = 0;

// debug filter
void filter_debug(void) {
	// start filter
	struct sock_filter filter[] = {
		VALIDATE_ARCHITECTURE,
		EXAMINE_SYSCALL
	};

	// print sizes
	printf("SECCOMP Filter:\n");
	if (sfilter == NULL) {
		printf("SECCOMP filter not allocated\n");
		return;
	}
	if (sfilter_index < 4)
		return;
	
	// test the start of the filter
	if (memcmp(sfilter, filter, sizeof(filter)) == 0) {
		printf("  VALIDATE_ARCHITECTURE\n");
		printf("  EXAMINE_SYSCAL\n");
	}
	
	// loop trough blacklists
	int i = 4;
	while (i < sfilter_index) {
		// minimal parsing!
		unsigned char *ptr = (unsigned char *) &sfilter[i];
		int *nr = (int *) (ptr + 4);
		if (*ptr	== 0x15 && *(ptr +14) == 0xff && *(ptr + 15) == 0x7f ) {
			printf("  WHITELIST %d %s\n", *nr, syscall_find_nr(*nr));
			i += 2;
		}
		else if (*ptr	== 0x15 && *(ptr +14) == 0 && *(ptr + 15) == 0) {
			printf("  BLACKLIST %d %s\n", *nr, syscall_find_nr(*nr));
			i += 2;
		}
		else if (*ptr	== 0x15 && *(ptr +14) == 0x5 && *(ptr + 15) == 0) {
			int err = *(ptr + 13) << 8 | *(ptr + 12);
			printf("  ERRNO %d %s %d %s\n", *nr, syscall_find_nr(*nr), err, errno_find_nr(err));
			i += 2;
		}
		else if (*ptr == 0x06 && *(ptr +6) == 0 && *(ptr + 7) == 0 ) {
			printf("  KILL_PROCESS\n");
			i++;
		}
		else if (*ptr == 0x06 && *(ptr +6) == 0xff && *(ptr + 7) == 0x7f ) {
			printf("  RETURN_ALLOW\n");
			i++;
		}
		else {
			printf("  UNKNOWN ENTRY!!!\n");
			i++;
		}
	}
}

// initialize filter
static void filter_init(void) {
	if (sfilter) {
		assert(0);
		return;
	}

//	if (arg_debug)
//		printf("Initialize seccomp filter\n");	
	// allocate a filter of SECSIZE
	sfilter = malloc(sizeof(struct sock_filter) * SECSIZE);
	if (!sfilter)
		errExit("malloc");
	memset(sfilter, 0, sizeof(struct sock_filter) * SECSIZE);
	sfilter_alloc_size = SECSIZE;
	
	// copy the start entries
	struct sock_filter filter[] = {
		VALIDATE_ARCHITECTURE,
		EXAMINE_SYSCALL
	};
	sfilter_index = sizeof(filter) / sizeof(struct sock_filter);	
	memcpy(sfilter, filter, sizeof(filter));
}

static void filter_realloc(void) {
	assert(sfilter);
	assert(sfilter_alloc_size);
	assert(sfilter_index);
	if (arg_debug)
		printf("Allocating more seccomp filter entries\n");
	
	// allocate the new memory
	struct sock_filter *old = sfilter;
	sfilter = malloc(sizeof(struct sock_filter) * (sfilter_alloc_size + SECSIZE));
	if (!sfilter)
		errExit("malloc");
	memset(sfilter, 0, sizeof(struct sock_filter) *  (sfilter_alloc_size + SECSIZE));
	
	// copy old filter
	memcpy(sfilter, old, sizeof(struct sock_filter) *  sfilter_alloc_size);
	sfilter_alloc_size += SECSIZE;
}

static void filter_add_whitelist(int syscall, int arg) {
	(void) arg;
	assert(sfilter);
	assert(sfilter_alloc_size);
	assert(sfilter_index);
//	if (arg_debug)
//		printf("Whitelisting syscall %d %s\n", syscall, syscall_find_nr(syscall));
	
	if ((sfilter_index + 2) > sfilter_alloc_size)
		filter_realloc();
	
	struct sock_filter filter[] = {
		WHITELIST(syscall)
	};
#if 0
{
	int i;
	unsigned char *ptr = (unsigned char *) &filter[0];
	for (i = 0; i < sizeof(filter); i++, ptr++)
		printf("%x, ", (*ptr) & 0xff);
	printf("\n");
}
#endif
	memcpy(&sfilter[sfilter_index], filter, sizeof(filter));
	sfilter_index += sizeof(filter) / sizeof(struct sock_filter);	
}

static void filter_add_blacklist(int syscall, int arg) {
	(void) arg;
	assert(sfilter);
	assert(sfilter_alloc_size);
	assert(sfilter_index);
//	if (arg_debug)
//		printf("Blacklisting syscall %d %s\n", syscall, syscall_find_nr(syscall));
	
	if ((sfilter_index + 2) > sfilter_alloc_size)
		filter_realloc();
	
	struct sock_filter filter[] = {
		BLACKLIST(syscall)
	};
#if 0
{
	int i;
	unsigned char *ptr = (unsigned char *) &filter[0];
	for (i = 0; i < sizeof(filter); i++, ptr++)
		printf("%x, ", (*ptr) & 0xff);
	printf("\n");
}
#endif
	memcpy(&sfilter[sfilter_index], filter, sizeof(filter));
	sfilter_index += sizeof(filter) / sizeof(struct sock_filter);	
}

static void filter_add_errno(int syscall, int arg) {
	assert(sfilter);
	assert(sfilter_alloc_size);
	assert(sfilter_index);
//	if (arg_debug)
//		printf("Errno syscall %d %d %s\n", syscall, arg, syscall_find_nr(syscall));

	if ((sfilter_index + 2) > sfilter_alloc_size)
		filter_realloc();

	struct sock_filter filter[] = {
		BLACKLIST_ERRNO(syscall, arg)
	};
#if 0
{
	int i;
	unsigned char *ptr = (unsigned char *) &filter[0];
	for (i = 0; i < sizeof(filter); i++, ptr++)
		printf("%x, ", (*ptr) & 0xff);
	printf("\n");
}
#endif
	memcpy(&sfilter[sfilter_index], filter, sizeof(filter));
	sfilter_index += sizeof(filter) / sizeof(struct sock_filter);
}

static void filter_end_blacklist(void) {
	assert(sfilter);
	assert(sfilter_alloc_size);
	assert(sfilter_index);
//	if (arg_debug)
//		printf("Ending syscall filter\n");

	if ((sfilter_index + 2) > sfilter_alloc_size)
		filter_realloc();
	
	struct sock_filter filter[] = {
		RETURN_ALLOW
	};
#if 0	
{
	int i;
	unsigned char *ptr = (unsigned char *) &filter[0];
	for (i = 0; i < sizeof(filter); i++, ptr++)
		printf("%x, ", (*ptr) & 0xff);
	printf("\n");
}
#endif
	memcpy(&sfilter[sfilter_index], filter, sizeof(filter));
	sfilter_index += sizeof(filter) / sizeof(struct sock_filter);	
}

static void filter_end_whitelist(void) {
	assert(sfilter);
	assert(sfilter_alloc_size);
	assert(sfilter_index);
	if (arg_debug)
		printf("Ending syscall filter\n");

	if ((sfilter_index + 2) > sfilter_alloc_size)
		filter_realloc();
	
	struct sock_filter filter[] = {
		KILL_PROCESS
	};
#if 0	
{
	int i;
	unsigned char *ptr = (unsigned char *) &filter[0];
	for (i = 0; i < sizeof(filter); i++, ptr++)
		printf("%x, ", (*ptr) & 0xff);
	printf("\n");
}
#endif
	memcpy(&sfilter[sfilter_index], filter, sizeof(filter));
	sfilter_index += sizeof(filter) / sizeof(struct sock_filter);	
}


// save seccomp filter in  /tmp/firejail/mnt/seccomp
static void write_seccomp_file(void) {
	fs_build_mnt_dir();
	assert(sfilter);

	int fd = open(SECCOMP_CFG, O_CREAT | O_WRONLY, S_IRUSR | S_IWUSR);
	if (fd == -1)
		errExit("open");

	if (arg_debug)
		printf("Save seccomp filter, size %u bytes\n", (unsigned) (sfilter_index * sizeof(struct sock_filter)));
	errno = 0;
	ssize_t sz = write(fd, sfilter, sfilter_index * sizeof(struct sock_filter));
	if (sz != (ssize_t)(sfilter_index * sizeof(struct sock_filter))) {
		fprintf(stderr, "Error: cannot save seccomp filter\n");
		exit(1);
	}
	close(fd);
	if (chown(SECCOMP_CFG, 0, 0) < 0)
		errExit("chown");
}

// read seccomp filter from /tmp/firejail/mnt/seccomp
static void read_seccomp_file(const char *fname) {
	assert(sfilter == NULL && sfilter_index == 0);

	// check file
	struct stat s;
	if (stat(fname, &s) == -1) {
		fprintf(stderr, "Error: seccomp file not found\n");
		exit(1);
	}
	ssize_t sz = s.st_size;
	if (sz == 0 || (sz % sizeof(struct sock_filter)) != 0) {
		fprintf(stderr, "Error: invalid seccomp file\n");
		exit(1);
	}
	sfilter = malloc(sz);
	if (!sfilter)
		errExit("malloc");
		
	// read file
	/* coverity[toctou] */
	int fd = open(fname,O_RDONLY);
	if (fd == -1)
		errExit("open");
	errno = 0;		
	ssize_t size = read(fd, sfilter, sz);
	if (size != sz) {
		fprintf(stderr, "Error: invalid seccomp file\n");
		exit(1);
	}
	sfilter_index = sz / sizeof(struct sock_filter);

	if (arg_debug)
		printf("Read seccomp filter, size %u bytes\n", (unsigned) (sfilter_index * sizeof(struct sock_filter)));

	close(fd);
	
	if (arg_debug)
		filter_debug();
}

// i386t filter installed on amd64 architectures
void seccomp_filter_32(void) {
	// hardcoded syscall values
	struct sock_filter filter[] = {
		VALIDATE_ARCHITECTURE_32,
		EXAMINE_SYSCALL,
		BLACKLIST(21), // mount
		BLACKLIST(52), // umount2
		BLACKLIST(26), // ptrace
		BLACKLIST(283), // kexec_load
		BLACKLIST(342), // open_by_handle_at
		BLACKLIST(128), // init_module
		BLACKLIST(350), // finit_module
		BLACKLIST(129), // delete_module
		BLACKLIST(110), // iopl
		BLACKLIST(101), // ioperm
		BLACKLIST(87), // swapon
		BLACKLIST(115), // swapoff
		BLACKLIST(103), // syslog
		BLACKLIST(347), // process_vm_readv
		BLACKLIST(348), // process_vm_writev
		BLACKLIST(135), // sysfs
		BLACKLIST(149), // _sysctl
		BLACKLIST(124), // adjtimex
		BLACKLIST(343), // clock_adjtime
		BLACKLIST(253), // lookup_dcookie
		BLACKLIST(336), // perf_event_open
		BLACKLIST(338), // fanotify_init
		BLACKLIST(349), // kcmp
		BLACKLIST(286), // add_key
		BLACKLIST(287), // request_key
		BLACKLIST(288), // keyctl
		BLACKLIST(86), // uselib
		BLACKLIST(51), // acct
		BLACKLIST(123), // modify_ldt
		BLACKLIST(217), // pivot_root
		BLACKLIST(245), // io_setup
		BLACKLIST(246), // io_destroy
		BLACKLIST(247), // io_getevents
		BLACKLIST(248), // io_submit
		BLACKLIST(249), // io_cancel
		BLACKLIST(257), // remap_file_pages
		BLACKLIST(274), // mbind
		BLACKLIST(275), // get_mempolicy
		BLACKLIST(276), // set_mempolicy
		BLACKLIST(294), // migrate_pages
		BLACKLIST(317), // move_pages
		BLACKLIST(316), // vmsplice
		BLACKLIST(61),  // chroot
		RETURN_ALLOW
	};

	struct sock_fprog prog = {
		.len = (unsigned short)(sizeof(filter) / sizeof(filter[0])),
		.filter = filter,
	};

	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog) || prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
		;
	}
	else if (arg_debug) {
		printf("dual i386/amd64 seccomp filter\n");
	}
}

// drop filter for seccomp option
int seccomp_filter_drop(void) {
	filter_init();
	
	// default seccomp
	if (cfg.seccomp_list_drop == NULL) {
#if defined(__x86_64__)
		seccomp_filter_32();
#endif

#ifdef SYS_mount		
		filter_add_blacklist(SYS_mount, 0);
#endif
#ifdef SYS_umount2		
		filter_add_blacklist(SYS_umount2, 0);
#endif
#ifdef SYS_ptrace 		
		filter_add_blacklist(SYS_ptrace, 0);
#endif
#ifdef SYS_kexec_load		
		filter_add_blacklist(SYS_kexec_load, 0);
#endif
#ifdef SYS_kexec_file_load		
		filter_add_blacklist(SYS_kexec_file_load, 0);
#endif
#ifdef SYS_open_by_handle_at		
		filter_add_blacklist(SYS_open_by_handle_at, 0);
#endif
#ifdef SYS_init_module		
		filter_add_blacklist(SYS_init_module, 0);
#endif
#ifdef SYS_finit_module // introduced in 2013
		filter_add_blacklist(SYS_finit_module, 0);
#endif
#ifdef SYS_delete_module		
		filter_add_blacklist(SYS_delete_module, 0);
#endif
#ifdef SYS_iopl		
		filter_add_blacklist(SYS_iopl, 0);
#endif
#ifdef 	SYS_ioperm	
		filter_add_blacklist(SYS_ioperm, 0);
#endif
#ifdef SYS_ni_syscall // new io permisions call on arm devices
		filter_add_blacklist(SYS_ni_syscall, 0);
#endif
#ifdef SYS_swapon		
		filter_add_blacklist(SYS_swapon, 0);
#endif
#ifdef SYS_swapoff		
		filter_add_blacklist(SYS_swapoff, 0);
#endif
#ifdef SYS_syslog		
		filter_add_blacklist(SYS_syslog, 0);
#endif
#ifdef SYS_process_vm_readv		
		filter_add_blacklist(SYS_process_vm_readv, 0);
#endif
#ifdef SYS_process_vm_writev		
		filter_add_blacklist(SYS_process_vm_writev, 0);
#endif

// mknod removed in 0.9.29 - it brakes Zotero extension
//#ifdef SYS_mknod		
//		filter_add_blacklist(SYS_mknod, 0);
//#endif
		
		// new syscalls in 0.9,23		
#ifdef SYS_sysfs		
		filter_add_blacklist(SYS_sysfs, 0);
#endif
#ifdef SYS__sysctl	
		filter_add_blacklist(SYS__sysctl, 0);
#endif
#ifdef SYS_adjtimex		
		filter_add_blacklist(SYS_adjtimex, 0);
#endif
#ifdef 	SYS_clock_adjtime	
		filter_add_blacklist(SYS_clock_adjtime, 0);
#endif
#ifdef SYS_lookup_dcookie		
		filter_add_blacklist(SYS_lookup_dcookie, 0);
#endif
#ifdef 	SYS_perf_event_open	
		filter_add_blacklist(SYS_perf_event_open, 0);
#endif
#ifdef	SYS_fanotify_init 	
		filter_add_blacklist(SYS_fanotify_init, 0);
#endif
#ifdef SYS_kcmp
		filter_add_blacklist(SYS_kcmp, 0);
#endif

// 0.9.32
#ifdef SYS_add_key
		filter_add_blacklist(SYS_add_key, 0);
#endif
#ifdef SYS_request_key
		filter_add_blacklist(SYS_request_key, 0);
#endif
#ifdef SYS_keyctl
		filter_add_blacklist(SYS_keyctl, 0);
#endif
#ifdef SYS_uselib
		filter_add_blacklist(SYS_uselib, 0);
#endif
#ifdef SYS_acct
		filter_add_blacklist(SYS_acct, 0);
#endif
#ifdef SYS_modify_ldt
		filter_add_blacklist(SYS_modify_ldt, 0);
#endif
	//#ifdef SYS_unshare
	//		filter_add_blacklist(SYS_unshare, 0);
	//#endif
#ifdef SYS_pivot_root
		filter_add_blacklist(SYS_pivot_root, 0);
#endif
	//#ifdef SYS_quotactl
	//		filter_add_blacklist(SYS_quotactl, 0);
	//#endif
#ifdef SYS_io_setup
		filter_add_blacklist(SYS_io_setup, 0);
#endif
#ifdef SYS_io_destroy
		filter_add_blacklist(SYS_io_destroy, 0);
#endif
#ifdef SYS_io_getevents
		filter_add_blacklist(SYS_io_getevents, 0);
#endif
#ifdef SYS_io_submit
		filter_add_blacklist(SYS_io_submit, 0);
#endif
#ifdef SYS_io_cancel
		filter_add_blacklist(SYS_io_cancel, 0);
#endif
#ifdef SYS_remap_file_pages
		filter_add_blacklist(SYS_remap_file_pages, 0);
#endif
#ifdef SYS_mbind
		filter_add_blacklist(SYS_mbind, 0);
#endif
#ifdef SYS_get_mempolicy
		filter_add_blacklist(SYS_get_mempolicy, 0);
#endif
#ifdef SYS_set_mempolicy
		filter_add_blacklist(SYS_set_mempolicy, 0);
#endif
#ifdef SYS_migrate_pages
		filter_add_blacklist(SYS_migrate_pages, 0);
#endif
#ifdef SYS_move_pages
		filter_add_blacklist(SYS_move_pages, 0);
#endif
#ifdef SYS_vmsplice
		filter_add_blacklist(SYS_vmsplice, 0);
#endif
#ifdef SYS_chroot
		filter_add_blacklist(SYS_chroot, 0);
#endif
	//#ifdef SYS_set_robust_list
	//		filter_add_blacklist(SYS_set_robust_list, 0);
	//#endif
	//#ifdef SYS_get_robust_list
	//		filter_add_blacklist(SYS_get_robust_list, 0);
	//#endif

 // CHECK_SECCOMP(seccomp_rule_add(ctx, SCMP_ACT_ERRNO(EPERM), SCMP_SYS(clone), 1,
 //     SCMP_A0(SCMP_CMP_MASKED_EQ, CLONE_NEWUSER, CLONE_NEWUSER)));

// 32bit
//		filter_add_blacklist(SYS_personality, 0); // test wine
//		filter_add_blacklist(SYS_set_thread_area, 0); // test wine
	}

	// default seccomp filter with additional drop list
	if (cfg.seccomp_list && cfg.seccomp_list_drop == NULL) {
		if (syscall_check_list(cfg.seccomp_list, filter_add_blacklist, 0)) {
			fprintf(stderr, "Error: cannot load seccomp filter\n");
			exit(1);
		}
	}
	// drop list
	else if (cfg.seccomp_list == NULL && cfg.seccomp_list_drop) {
		if (syscall_check_list(cfg.seccomp_list_drop, filter_add_blacklist, 0)) {
			fprintf(stderr, "Error: cannot load seccomp filter\n");
			exit(1);
		}
	}
	
	
	filter_end_blacklist();
	if (arg_debug)
		filter_debug();

	// save seccomp filter in  /tmp/firejail/mnt/seccomp
	// in order to use it in --join operations
	write_seccomp_file();


	struct sock_fprog prog = {
		.len = sfilter_index,
		.filter = sfilter,
	};

	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog) || prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
		fprintf(stderr, "Warning: seccomp disabled, it requires a Linux kernel version 3.5 or newer.\n");
		return 1;
	}
	else if (arg_debug) {
		printf("seccomp enabled\n");
	}
	
	return 0;
}

// keep filter for seccomp option
int seccomp_filter_keep(void) {
	filter_init();

	// these 4 syscalls are used by firejail after the seccomp filter is initialized
	filter_add_whitelist(SYS_setuid, 0);
	filter_add_whitelist(SYS_setgid, 0);
	filter_add_whitelist(SYS_setgroups, 0);
	filter_add_whitelist(SYS_dup, 0);
	
	// apply keep list
	if (cfg.seccomp_list_keep) {
		if (syscall_check_list(cfg.seccomp_list_keep, filter_add_whitelist, 0)) {
			fprintf(stderr, "Error: cannot load seccomp filter\n");
			exit(1);
		}
	}
	
	filter_end_whitelist();
	if (arg_debug)
		filter_debug();

	// save seccomp filter in  /tmp/firejail/mnt/seccomp
	// in order to use it in --join operations
	write_seccomp_file();


	struct sock_fprog prog = {
		.len = sfilter_index,
		.filter = sfilter,
	};

	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog) || prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
		fprintf(stderr, "Warning: seccomp disabled, it requires a Linux kernel version 3.5 or newer.\n");
		return 1;
	}
	else if (arg_debug) {
		printf("seccomp enabled\n");
	}
	
	return 0;
}

// errno filter for seccomp option
int seccomp_filter_errno(void) {
	int i;
	int higest_errno = errno_highest_nr();
	filter_init();

	// apply errno list

	for (i = 0; i < higest_errno; i++) {
		if (cfg.seccomp_list_errno[i]) {
			if (syscall_check_list(cfg.seccomp_list_errno[i], filter_add_errno, i)) {
				fprintf(stderr, "Error: cannot load seccomp filter\n");
				exit(1);
			}
		}
	}

	filter_end_blacklist();
	if (arg_debug)
		filter_debug();

	// save seccomp filter in  /tmp/firejail/mnt/seccomp
	// in order to use it in --join operations
	write_seccomp_file();

	struct sock_fprog prog = {
		.len = sfilter_index,
		.filter = sfilter,
	};

	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog) || prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
		fprintf(stderr, "Warning: seccomp disabled, it requires a Linux kernel version 3.5 or newer.\n");
		return 1;
	}
	else if (arg_debug) {
		printf("seccomp enabled\n");
	}

	return 0;
}



void seccomp_set(void) {
	// read seccomp filter from  /tmp/firejail/mnt/seccomp
	read_seccomp_file(SECCOMP_CFG);
	
	// apply filter
	struct sock_fprog prog = {
		.len = sfilter_index,
		.filter = sfilter,
	};
	
	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog) || prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
		fprintf(stderr, "Warning: seccomp disabled, it requires a Linux kernel version 3.5 or newer.\n");
		return;
	}
	else if (arg_debug) {
		printf("seccomp enabled\n");
	}
}

void seccomp_print_filter_name(const char *name) {
	if (!name || strlen(name) == 0) {
		fprintf(stderr, "Error: invalid sandbox name\n");
		exit(1);
	}
	pid_t pid;
	if (name2pid(name, &pid)) {
		fprintf(stderr, "Error: cannot find sandbox %s\n", name);
		exit(1);
	}

	seccomp_print_filter(pid);
}

void seccomp_print_filter(pid_t pid) {
	// if the pid is that of a firejail  process, use the pid of the first child process
	char *comm = pid_proc_comm(pid);
	if (comm) {
		// remove \n
		char *ptr = strchr(comm, '\n');
		if (ptr)
			*ptr = '\0';
		if (strcmp(comm, "firejail") == 0) {
			pid_t child;
			if (find_child(pid, &child) == 0) {
				pid = child;
			}
		}
		free(comm);
	}

	// check privileges for non-root users
	uid_t uid = getuid();
	if (uid != 0) {
		uid_t sandbox_uid = pid_get_uid(pid);
		if (uid != sandbox_uid) {
			fprintf(stderr, "Error: permission denied.\n");
			exit(1);
		}
	}


	// find the seccomp filter
	char *fname;
	if (asprintf(&fname, "/proc/%d/root%s", pid, SECCOMP_CFG) == -1)
		errExit("asprintf");

	struct stat s;
	if (stat(fname, &s) == -1) {
		printf("Cannot access seccomp filter.\n");
		exit(1);
	}

	// read and print the filter
	read_seccomp_file(fname);
	drop_privs(1);
	filter_debug();
	free(fname);

	exit(0);
}

#endif // HAVE_SECCOMP

