/*
 * Copyright (C) 2014-2019 Firejail Authors
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
#include "fseccomp.h"
#include <stdio.h>
#include <sys/syscall.h>

typedef struct {
	const char * const name;
	int nr;
} SyscallEntry;

typedef struct {
	const char * const name;
	const char * const list;
} SyscallGroupList;

typedef struct {
	const char *slist;
	char *prelist, *postlist;
	bool found;
	int syscall;
} SyscallCheckList;

static const SyscallEntry syslist[] = {
//
// code generated using tools/extract-syscall
//
#include "../include/syscall.h"
//
// end of generated code
//
}; // end of syslist

static const SyscallGroupList sysgroups[] = {
	{ .name = "@clock", .list =
#ifdef SYS_adjtimex
	  "adjtimex,"
#endif
#ifdef SYS_clock_adjtime
	  "clock_adjtime,"
#endif
#ifdef SYS_clock_settime
	  "clock_settime,"
#endif
#ifdef SYS_settimeofday
	  "settimeofday,"
#endif
#ifdef SYS_stime
	  "stime"
#endif
	},
	{ .name = "@cpu-emulation", .list =
#ifdef SYS_modify_ldt
	  "modify_ldt,"
#endif
#ifdef SYS_subpage_prot
	  "subpage_prot,"
#endif
#ifdef SYS_switch_endian
	  "switch_endian,"
#endif
#ifdef SYS_vm86
	  "vm86,"
#endif
#ifdef SYS_vm86old
	  "vm86old"
#endif
#if !defined(SYS_modify_ldt) && !defined(SYS_subpage_prot) && !defined(SYS_switch_endian) && !defined(SYS_vm86) && !defined(SYS_vm86old)
	  "__dummy_syscall__" // workaround for arm64, s390x and sparc64 which don't have any of above defined and empty syscall lists are not allowed
#endif
	},
	{ .name = "@debug", .list =
#ifdef SYS_lookup_dcookie
	  "lookup_dcookie,"
#endif
#ifdef SYS_perf_event_open
	  "perf_event_open,"
#endif
#ifdef SYS_process_vm_writev
	  "process_vm_writev,"
#endif
#ifdef SYS_rtas
	  "rtas,"
#endif
#ifdef SYS_s390_runtime_instr
	  "s390_runtime_instr,"
#endif
#ifdef SYS_sys_debug_setcontext
	  "sys_debug_setcontext,"
#endif
	},
	{ .name = "@default", .list =
	  "@cpu-emulation,"
	  "@debug,"
	  "@obsolete,"
	  "@privileged,"
	  "@resources,"
#ifdef SYS_open_by_handle_at
	  "open_by_handle_at,"
#endif
#ifdef SYS_name_to_handle_at
	  "name_to_handle_at,"
#endif
#ifdef SYS_ioprio_set
	  "ioprio_set,"
#endif
#ifdef SYS_ni_syscall
	  "ni_syscall,"
#endif
#ifdef SYS_syslog
	  "syslog,"
#endif
#ifdef SYS_fanotify_init
	  "fanotify_init,"
#endif
#ifdef SYS_kcmp
	  "kcmp,"
#endif
#ifdef SYS_add_key
	  "add_key,"
#endif
#ifdef SYS_request_key
	  "request_key,"
#endif
#ifdef SYS_keyctl
	  "keyctl,"
#endif
#ifdef SYS_io_setup
	  "io_setup,"
#endif
#ifdef SYS_io_destroy
	  "io_destroy,"
#endif
#ifdef SYS_io_getevents
	  "io_getevents,"
#endif
#ifdef SYS_io_submit
	  "io_submit,"
#endif
#ifdef SYS_io_cancel
	  "io_cancel,"
#endif
#ifdef SYS_remap_file_pages
	  "remap_file_pages,"
#endif
#ifdef SYS_vmsplice
	  "vmsplice,"
#endif
#ifdef SYS_umount
	  "umount,"
#endif
#ifdef SYS_userfaultfd
	  "userfaultfd,"
#endif
//#ifdef SYS_mincore	// 0.9.57 - problem fixed in Linux kernel 5.0; on 4.x it will break kodi, mpv, totem
//	  "mincore"
//#endif
	},
	{ .name = "@default-nodebuggers", .list =
	  "@default,"
#ifdef SYS_ptrace
	  "ptrace,"
#endif
#ifdef SYS_personality
	  "personality,"
#endif
#ifdef SYS_process_vm_readv
	  "process_vm_readv"
#endif
	},
	{ .name = "@default-keep", .list =
	  "execve,"
	  "prctl"
	},
	{ .name = "@module", .list =
#ifdef SYS_delete_module
	  "delete_module,"
#endif
#ifdef SYS_finit_module
	  "finit_module,"
#endif
#ifdef SYS_init_module
	  "init_module"
#endif
	},
	{ .name = "@obsolete", .list =
#ifdef SYS__sysctl
	  "_sysctl,"
#endif
#ifdef SYS_afs_syscall
	  "afs_syscall,"
#endif
#ifdef SYS_bdflush
	  "bdflush,"
#endif
#ifdef SYS_break
	  "break,"
#endif
#ifdef SYS_create_module
	  "create_module,"
#endif
#ifdef SYS_ftime
	  "ftime,"
#endif
#ifdef SYS_get_kernel_syms
	  "get_kernel_syms,"
#endif
#ifdef SYS_getpmsg
	  "getpmsg,"
#endif
#ifdef SYS_gtty
	  "gtty,"
#endif
#ifdef SYS_lock
	  "lock,"
#endif
#ifdef SYS_mpx
	  "mpx,"
#endif
#ifdef SYS_prof
	  "prof,"
#endif
#ifdef SYS_profil
	  "profil,"
#endif
#ifdef SYS_putpmsg
	  "putpmsg,"
#endif
#ifdef SYS_query_module
	  "query_module,"
#endif
#ifdef SYS_security
	  "security,"
#endif
#ifdef SYS_sgetmask
	  "sgetmask,"
#endif
#ifdef SYS_ssetmask
	  "ssetmask,"
#endif
#ifdef SYS_stty
	  "stty,"
#endif
#ifdef SYS_sysfs
	  "sysfs,"
#endif
#ifdef SYS_tuxcall
	  "tuxcall,"
#endif
#ifdef SYS_ulimit
	  "ulimit,"
#endif
#ifdef SYS_uselib
	  "uselib,"
#endif
#ifdef SYS_ustat
	  "ustat,"
#endif
#ifdef SYS_vserver
	  "vserver"
#endif
#if !defined(SYS__sysctl) && !defined(SYS_afs_syscall) && !defined(SYS_bdflush) && !defined(SYS_break) && !defined(SYS_create_module) && !defined(SYS_ftime) && !defined(SYS_get_kernel_syms) && !defined(SYS_getpmsg) && !defined(SYS_gtty) && !defined(SYS_lock) && !defined(SYS_mpx) && !defined(SYS_prof) && !defined(SYS_profil) && !defined(SYS_putpmsg) && !defined(SYS_query_module) && !defined(SYS_security) && !defined(SYS_sgetmask) && !defined(SYS_ssetmask) && !defined(SYS_stty) && !defined(SYS_sysfs) && !defined(SYS_tuxcall) && !defined(SYS_ulimit) && !defined(SYS_uselib) && !defined(SYS_ustat) && !defined(SYS_vserver)
	  "__dummy_syscall__" // workaround for arm64 which doesn't have any of above defined and empty syscall lists are not allowed
#endif
	},
	{ .name = "@privileged", .list =
	  "@clock,"
	  "@module,"
	  "@raw-io,"
	  "@reboot,"
	  "@swap,"
#ifdef SYS_acct
	  "acct,"
#endif
#ifdef SYS_bpf
	  "bpf,"
#endif
#ifdef SYS_chroot
	  "chroot,"
#endif
#ifdef SYS_mount
	  "mount,"
#endif
#ifdef SYS_nfsservctl
	  "nfsservctl,"
#endif
#ifdef SYS_pivot_root
	  "pivot_root,"
#endif
#ifdef SYS_setdomainname
	  "setdomainname,"
#endif
#ifdef SYS_sethostname
	  "sethostname,"
#endif
#ifdef SYS_umount2
	  "umount2,"
#endif
#ifdef SYS_vhangup
	  "vhangup"
#endif
	},
	{ .name = "@raw-io", .list =
#ifdef SYS_ioperm
	  "ioperm,"
#endif
#ifdef SYS_iopl
	  "iopl,"
#endif
#ifdef SYS_pciconfig_iobase
	  "pciconfig_iobase,"
#endif
#ifdef SYS_pciconfig_read
	  "pciconfig_read,"
#endif
#ifdef SYS_pciconfig_write
	  "pciconfig_write,"
#endif
#ifdef SYS_s390_mmio_read
	  "s390_mmio_read,"
#endif
#ifdef SYS_s390_mmio_write
	  "s390_mmio_write"
#endif
#if !defined(SYS_ioperm) && !defined(SYS_iopl) && !defined(SYS_pciconfig_iobase) && !defined(SYS_pciconfig_read) && !defined(SYS_pciconfig_write) && !defined(SYS_s390_mmio_read) && !defined(SYS_s390_mmio_write)
	  "__dummy_syscall__" // workaround for s390x which doesn't have any of above defined and empty syscall lists are not allowed
#endif
	},
	{ .name = "@reboot", .list =
#ifdef SYS_kexec_load
	  "kexec_load,"
#endif
#ifdef SYS_kexec_file_load
	  "kexec_file_load,"
#endif
#ifdef SYS_reboot
	  "reboot,"
#endif
	},
	{ .name = "@resources", .list =
#ifdef SYS_set_mempolicy
	  "set_mempolicy,"
#endif
#ifdef SYS_migrate_pages
	  "migrate_pages,"
#endif
#ifdef SYS_move_pages
	  "move_pages,"
#endif
#ifdef SYS_mbind
	  "mbind"
#endif
	},
	{ .name = "@swap", .list =
#ifdef SYS_swapon
	  "swapon,"
#endif
#ifdef SYS_swapoff
	  "swapoff"
#endif
	}
};

// return -1 if error, or syscall number
static int syscall_find_name(const char *name) {
	int i;
	int elems = sizeof(syslist) / sizeof(syslist[0]);
	for (i = 0; i < elems; i++) {
		if (strcmp(name, syslist[i].name) == 0)
			return syslist[i].nr;
	}

	return -1;
}

const char *syscall_find_nr(int nr) {
	int i;
	int elems = sizeof(syslist) / sizeof(syslist[0]);
	for (i = 0; i < elems; i++) {
		if (nr == syslist[i].nr)
			return syslist[i].name;
	}

	return "unknown";
}

void syscall_print(void) {
	int i;
	int elems = sizeof(syslist) / sizeof(syslist[0]);
	for (i = 0; i < elems; i++) {
		printf("%d\t- %s\n", syslist[i].nr, syslist[i].name);
	}
	printf("\n");
}

static const char *syscall_find_group(const char *name) {
	int i;
	int elems = sizeof(sysgroups) / sizeof(sysgroups[0]);
	for (i = 0; i < elems; i++) {
		if (strcmp(name, sysgroups[i].name) == 0)
			return sysgroups[i].list;
	}

	return NULL;
}

// allowed input:
// - syscall
// - syscall(error)
static void syscall_process_name(const char *name, int *syscall_nr, int *error_nr) {
	assert(name);
	if (strlen(name) == 0)
		goto error;
	*error_nr = -1;

	// syntax check
	char *str = strdup(name);
	if (!str)
		errExit("strdup");

	char *syscall_name = str;
	char *error_name = strchr(str, ':');
	if (error_name) {
		*error_name = '\0';
		error_name++;
	}
	if (strlen(syscall_name) == 0) {
		free(str);
		goto error;
	}

	if (*syscall_name == '$')
		*syscall_nr = strtol(syscall_name + 1, NULL, 0);
	else
		*syscall_nr = syscall_find_name(syscall_name);
	if (error_name) {
		*error_nr = errno_find_name(error_name);
		if (*error_nr == -1)
			*syscall_nr = -1;
	}

	free(str);
	return;

error:
	fprintf(stderr, "Error fseccomp: invalid syscall list entry %s\n", name);
	exit(1);
}

// return 1 if error, 0 if OK
int syscall_check_list(const char *slist, void (*callback)(int fd, int syscall, int arg, void *ptrarg), int fd, int arg, void *ptrarg) {
	// don't allow empty lists
	if (slist == NULL || *slist == '\0') {
		fprintf(stderr, "Error fseccomp: empty syscall lists are not allowed\n");
		exit(1);
	}

	// work on a copy of the string
	char *str = strdup(slist);
	if (!str)
		errExit("strdup");

	char *saveptr;
	char *ptr = strtok_r(str, ",", &saveptr);
	if (ptr == NULL) {
		fprintf(stderr, "Error fseccomp: empty syscall lists are not allowed\n");
		exit(1);
	}

	while (ptr) {
		int syscall_nr;
		int error_nr;
		if (*ptr == '@') {
			const char *new_list = syscall_find_group(ptr);
			if (!new_list) {
				fprintf(stderr, "Error fseccomp: unknown syscall group %s\n", ptr);
				exit(1);
			}
			syscall_check_list(new_list, callback, fd, arg, ptrarg);
		}
		else {
			syscall_process_name(ptr, &syscall_nr, &error_nr);
			if (syscall_nr == -1) {;}
			else if (callback != NULL) {
				if (error_nr != -1 && fd != 0) {
					filter_add_errno(fd, syscall_nr, error_nr, ptrarg);
				}
				else if (error_nr != -1 && fd == 0) {
					callback(fd, syscall_nr, error_nr, ptrarg);
				}
				else {
					callback(fd, syscall_nr, arg, ptrarg);
				}
			}
		}
		ptr = strtok_r(NULL, ",", &saveptr);
	}

	free(str);
	return 0;
}

static void find_syscall(int fd, int syscall, int arg, void *ptrarg) {
	(void)fd;
	(void) arg;
	SyscallCheckList *ptr = ptrarg;
	if (syscall == ptr->syscall)
		ptr->found = true;
}

// go through list2 and find matches for problem syscall
static void syscall_in_list(int fd, int syscall, int arg, void *ptrarg) {
	(void) fd;
	(void)arg;
	SyscallCheckList *ptr = ptrarg;
	SyscallCheckList sl;
	sl.found = false;
	sl.syscall = syscall;
	syscall_check_list(ptr->slist, find_syscall, fd, 0, &sl);
	// if found in the problem list, add to post-exec list
	if (sl.found) {
		if (ptr->postlist) {
			if (asprintf(&ptr->postlist, "%s,%s", ptr->postlist, syscall_find_nr(syscall)) == -1)
				errExit("asprintf");
		}
		else
			ptr->postlist = strdup(syscall_find_nr(syscall));
	}
	else { // no problem, add to pre-exec list
		// build syscall:error_no
		char *newcall = NULL;
		if (arg != 0) {
			if (asprintf(&newcall, "%s:%s", syscall_find_nr(syscall), errno_find_nr(arg)) == -1)
				errExit("asprintf");
		}
		else {
			newcall = strdup(syscall_find_nr(syscall));
			if (!newcall)
				errExit("strdup");
		}

		if (ptr->prelist) {
			if (asprintf(&ptr->prelist, "%s,%s", ptr->prelist, newcall) == -1)
				errExit("asprintf");
			free(newcall);
		}
		else
			ptr->prelist = newcall;
	}
}

// go through list and find matches for syscalls in list @default-keep
void syscalls_in_list(const char *list, const char *slist, int fd, char **prelist, char **postlist) {
	(void) fd;
	SyscallCheckList sl;
	// these syscalls are used by firejail after the seccomp filter is initialized
	sl.slist = slist;
	sl.prelist = NULL;
	sl.postlist = NULL;
	syscall_check_list(list, syscall_in_list, 0, 0, &sl);
	if (!arg_quiet) {
		printf("Seccomp list in: %s,", list);
		if (sl.slist)
			printf(" check list: %s,", sl.slist);
		if (sl.prelist)
			printf(" prelist: %s,", sl.prelist);
		if (sl.postlist)
			printf(" postlist: %s", sl.postlist);
		printf("\n");
	}
	*prelist = sl.prelist;
	*postlist = sl.postlist;
}
