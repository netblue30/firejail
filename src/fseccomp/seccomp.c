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
#include "fseccomp.h"
#include "../include/seccomp.h"
#include <sys/mman.h>
#include <sys/shm.h>
#include <sys/syscall.h>
#include <sys/types.h>

static void add_default_list(int fd, int allow_debuggers) {
#ifdef SYS_mount
	filter_add_blacklist(fd, SYS_mount, 0);
#endif
#ifdef SYS_umount2
	filter_add_blacklist(fd, SYS_umount2, 0);
#endif

	if (!allow_debuggers) {
#ifdef SYS_ptrace
		filter_add_blacklist(fd, SYS_ptrace, 0);
#endif
	}

#ifdef SYS_kexec_load
	filter_add_blacklist(fd, SYS_kexec_load, 0);
#endif
#ifdef SYS_kexec_file_load
	filter_add_blacklist(fd, SYS_kexec_file_load, 0);
#endif
#ifdef SYS_open_by_handle_at
	filter_add_blacklist(fd, SYS_open_by_handle_at, 0);
#endif
#ifdef SYS_name_to_handle_at
	filter_add_blacklist(fd, SYS_name_to_handle_at, 0);
#endif
#ifdef SYS_init_module
	filter_add_blacklist(fd, SYS_init_module, 0);
#endif
#ifdef SYS_finit_module
	filter_add_blacklist(fd, SYS_finit_module, 0);
#endif
#ifdef SYS_create_module
	filter_add_blacklist(fd, SYS_create_module, 0);
#endif
#ifdef SYS_delete_module
	filter_add_blacklist(fd, SYS_delete_module, 0);
#endif
#ifdef SYS_iopl
	filter_add_blacklist(fd, SYS_iopl, 0);
#endif
#ifdef  SYS_ioperm
	filter_add_blacklist(fd, SYS_ioperm, 0);
#endif
#ifdef  SYS_ioprio_set
	filter_add_blacklist(fd, SYS_ioprio_set, 0);
#endif
#ifdef SYS_ni_syscall
	filter_add_blacklist(fd, SYS_ni_syscall, 0);
#endif
#ifdef SYS_swapon
	filter_add_blacklist(fd, SYS_swapon, 0);
#endif
#ifdef SYS_swapoff
	filter_add_blacklist(fd, SYS_swapoff, 0);
#endif
#ifdef SYS_syslog
	filter_add_blacklist(fd, SYS_syslog, 0);
#endif

	if (!allow_debuggers) {
#ifdef SYS_process_vm_readv
		filter_add_blacklist(fd, SYS_process_vm_readv, 0);
#endif
	}

#ifdef SYS_process_vm_writev
	filter_add_blacklist(fd, SYS_process_vm_writev, 0);
#endif
//#ifdef SYS_mknod - emoved in 0.9.29 - it breaks Zotero extension
//		filter_add_blacklist(SYS_mknod, 0);
//#endif
#ifdef SYS_sysfs
	filter_add_blacklist(fd, SYS_sysfs, 0);
#endif
#ifdef SYS__sysctl
	filter_add_blacklist(fd, SYS__sysctl, 0);
#endif
#ifdef SYS_adjtimex
	filter_add_blacklist(fd, SYS_adjtimex, 0);
#endif
#ifdef  SYS_clock_adjtime
	filter_add_blacklist(fd, SYS_clock_adjtime, 0);
#endif
#ifdef SYS_lookup_dcookie
	filter_add_blacklist(fd, SYS_lookup_dcookie, 0);
#endif
#ifdef  SYS_perf_event_open
	filter_add_blacklist(fd, SYS_perf_event_open, 0);
#endif
#ifdef  SYS_fanotify_init
	filter_add_blacklist(fd, SYS_fanotify_init, 0);
#endif
#ifdef SYS_kcmp
	filter_add_blacklist(fd, SYS_kcmp, 0);
#endif
#ifdef SYS_add_key
	filter_add_blacklist(fd, SYS_add_key, 0);
#endif
#ifdef SYS_request_key
	filter_add_blacklist(fd, SYS_request_key, 0);
#endif
#ifdef SYS_keyctl
	filter_add_blacklist(fd, SYS_keyctl, 0);
#endif
#ifdef SYS_uselib
	filter_add_blacklist(fd, SYS_uselib, 0);
#endif
#ifdef SYS_acct
	filter_add_blacklist(fd, SYS_acct, 0);
#endif
#ifdef SYS_modify_ldt
	filter_add_blacklist(fd, SYS_modify_ldt, 0);
#endif
#ifdef SYS_pivot_root
	filter_add_blacklist(fd, SYS_pivot_root, 0);
#endif
#ifdef SYS_io_setup
	filter_add_blacklist(fd, SYS_io_setup, 0);
#endif
#ifdef SYS_io_destroy
	filter_add_blacklist(fd, SYS_io_destroy, 0);
#endif
#ifdef SYS_io_getevents
	filter_add_blacklist(fd, SYS_io_getevents, 0);
#endif
#ifdef SYS_io_submit
	filter_add_blacklist(fd, SYS_io_submit, 0);
#endif
#ifdef SYS_io_cancel
	filter_add_blacklist(fd, SYS_io_cancel, 0);
#endif
#ifdef SYS_remap_file_pages
	filter_add_blacklist(fd, SYS_remap_file_pages, 0);
#endif
#ifdef SYS_mbind
	filter_add_blacklist(fd, SYS_mbind, 0);
#endif

// breaking Firefox nightly when playing youtube videos
// TODO: test again when firefox sandbox is finally released
//#ifdef SYS_get_mempolicy
//	filter_add_blacklist(fd, SYS_get_mempolicy, 0);
//#endif

#ifdef SYS_set_mempolicy
	filter_add_blacklist(fd, SYS_set_mempolicy, 0);
#endif
#ifdef SYS_migrate_pages
	filter_add_blacklist(fd, SYS_migrate_pages, 0);
#endif
#ifdef SYS_move_pages
	filter_add_blacklist(fd, SYS_move_pages, 0);
#endif
#ifdef SYS_vmsplice
	filter_add_blacklist(fd, SYS_vmsplice, 0);
#endif
#ifdef SYS_chroot
	filter_add_blacklist(fd, SYS_chroot, 0);
#endif
#ifdef SYS_tuxcall
	filter_add_blacklist(fd, SYS_tuxcall, 0);
#endif
#ifdef SYS_reboot
	filter_add_blacklist(fd, SYS_reboot, 0);
#endif
#ifdef SYS_nfsservctl
	filter_add_blacklist(fd, SYS_nfsservctl, 0);
#endif
#ifdef SYS_get_kernel_syms
	filter_add_blacklist(fd, SYS_get_kernel_syms, 0);
#endif

// 0.9.45
#ifdef SYS_bpf
	filter_add_blacklist(fd, SYS_bpf, 0);
#endif
#ifdef SYS_clock_settime
	filter_add_blacklist(fd, SYS_clock_settime, 0);
#endif
//#ifdef SYS_clone - in use by Firejail
//	filter_add_blacklist(fd, SYS_clone, 0);
//#endif
#ifdef SYS_personality
	filter_add_blacklist(fd, SYS_personality, 0);
#endif
#ifdef SYS_process_vm_writev
	filter_add_blacklist(fd, SYS_process_vm_writev, 0);
#endif
#ifdef SYS_query_module
	filter_add_blacklist(fd, SYS_query_module, 0);
#endif
//#ifdef SYS_quotactl - in use by Firefox
//	filter_add_blacklist(fd, SYS_quotactl, 0);
//#endif
//#ifdef SYS_setns - in use by Firejail
//	filter_add_blacklist(fd, SYS_setns, 0);
//#endif
#ifdef SYS_settimeofday
	filter_add_blacklist(fd, SYS_settimeofday, 0);
#endif
#ifdef SYS_stime
	filter_add_blacklist(fd, SYS_stime, 0);
#endif
#ifdef SYS_umount
	filter_add_blacklist(fd, SYS_umount, 0);
#endif
//#ifdef SYS_unshare - in use by Firejail
//	filter_add_blacklist(fd, SYS_unshare, 0);
//#endif
#ifdef SYS_userfaultfd
	filter_add_blacklist(fd, SYS_userfaultfd, 0);
#endif
#ifdef SYS_ustat
	filter_add_blacklist(fd, SYS_ustat, 0);
#endif
#ifdef SYS_vm86
	filter_add_blacklist(fd, SYS_vm86, 0);
#endif
#ifdef SYS_vm86old
	filter_add_blacklist(fd, SYS_vm86old, 0);
#endif

#ifdef SYS_afs_syscall
	filter_add_blacklist(fd, SYS_afs_syscall, 0);
#endif
#ifdef SYS_bdflush
	filter_add_blacklist(fd, SYS_bdflush, 0);
#endif
#ifdef SYS_break
	filter_add_blacklist(fd, SYS_break, 0);
#endif
#ifdef SYS_ftime
	filter_add_blacklist(fd, SYS_ftime, 0);
#endif
#ifdef SYS_getpmsg
	filter_add_blacklist(fd, SYS_getpmsg, 0);
#endif
#ifdef SYS_gtty
	filter_add_blacklist(fd, SYS_gtty, 0);
#endif
#ifdef SYS_lock
	filter_add_blacklist(fd, SYS_lock, 0);
#endif
#ifdef SYS_mpx
	filter_add_blacklist(fd, SYS_mpx, 0);
#endif
#ifdef SYS_pciconfig_iobase
	filter_add_blacklist(fd, SYS_pciconfig_iobase, 0);
#endif
#ifdef SYS_pciconfig_read
	filter_add_blacklist(fd, SYS_pciconfig_read, 0);
#endif
#ifdef SYS_pciconfig_write
	filter_add_blacklist(fd, SYS_pciconfig_write, 0);
#endif
#ifdef SYS_prof
	filter_add_blacklist(fd, SYS_prof, 0);
#endif
#ifdef SYS_profil
	filter_add_blacklist(fd, SYS_profil, 0);
#endif
#ifdef SYS_putpmsg
	filter_add_blacklist(fd, SYS_putpmsg, 0);
#endif
#ifdef SYS_rtas
	filter_add_blacklist(fd, SYS_rtas, 0);
#endif
#ifdef SYS_s390_runtime_instr
	filter_add_blacklist(fd, SYS_s390_runtime_instr, 0);
#endif
#ifdef SYS_s390_mmio_read
	filter_add_blacklist(fd, SYS_s390_mmio_read, 0);
#endif
#ifdef SYS_s390_mmio_write
	filter_add_blacklist(fd, SYS_s390_mmio_write, 0);
#endif
#ifdef SYS_security
	filter_add_blacklist(fd, SYS_security, 0);
#endif
#ifdef SYS_setdomainname
	filter_add_blacklist(fd, SYS_setdomainname, 0);
#endif
#ifdef SYS_sethostname
	filter_add_blacklist(fd, SYS_sethostname, 0);
#endif
#ifdef SYS_sgetmask
	filter_add_blacklist(fd, SYS_sgetmask, 0);
#endif
#ifdef SYS_ssetmask
	filter_add_blacklist(fd, SYS_ssetmask, 0);
#endif
#ifdef SYS_stty
	filter_add_blacklist(fd, SYS_stty, 0);
#endif
#ifdef SYS_subpage_prot
	filter_add_blacklist(fd, SYS_subpage_prot, 0);
#endif
#ifdef SYS_switch_endian
	filter_add_blacklist(fd, SYS_switch_endian, 0);
#endif
#ifdef SYS_sys_debug_setcontext
	filter_add_blacklist(fd, SYS_sys_debug_setcontext, 0);
#endif
#ifdef SYS_ulimit
	filter_add_blacklist(fd, SYS_ulimit, 0);
#endif
#ifdef SYS_vhangup
	filter_add_blacklist(fd, SYS_vhangup, 0);
#endif
#ifdef SYS_vserver
	filter_add_blacklist(fd, SYS_vserver, 0);
#endif

}

// default list
void seccomp_default(const char *fname, int allow_debuggers) {
	assert(fname);

	// open file
	int fd = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}

	// build filter
	filter_init(fd);
	add_default_list(fd, allow_debuggers);
	filter_end_blacklist(fd);

	// close file
	close(fd);
}

// drop list
void seccomp_drop(const char *fname, char *list, int allow_debuggers) {
	assert(fname);
	(void) allow_debuggers; // todo: to implemnet it

	// open file
	int fd = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}

	// build filter
	filter_init(fd);
	if (syscall_check_list(list, filter_add_blacklist, fd, 0)) {
		fprintf(stderr, "Error fseccomp: cannot build seccomp filter\n");
		exit(1);
	}
	filter_end_blacklist(fd);

	// close file
	close(fd);
}

// default+drop
void seccomp_default_drop(const char *fname, char *list, int allow_debuggers) {
	assert(fname);

	// open file
	int fd = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}

	// build filter
	filter_init(fd);
	add_default_list(fd, allow_debuggers);
	if (syscall_check_list(list, filter_add_blacklist, fd, 0)) {
		fprintf(stderr, "Error fseccomp: cannot build seccomp filter\n");
		exit(1);
	}
	filter_end_blacklist(fd);

	// close file
	close(fd);
}

void seccomp_keep(const char *fname, char *list) {
	// open file
	int fd = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}

	// build filter
	filter_init(fd);
	// these 4 syscalls are used by firejail after the seccomp filter is initialized
	filter_add_whitelist(fd, SYS_setuid, 0);
	filter_add_whitelist(fd, SYS_setgid, 0);
	filter_add_whitelist(fd, SYS_setgroups, 0);
	filter_add_whitelist(fd, SYS_dup, 0);
	filter_add_whitelist(fd, SYS_prctl, 0);

	if (syscall_check_list(list, filter_add_whitelist, fd, 0)) {
		fprintf(stderr, "Error fseccomp: cannot build seccomp filter\n");
		exit(1);
	}

	filter_end_whitelist(fd);

	// close file
	close(fd);
}

void memory_deny_write_execute(const char *fname) {
	// open file
	int fd = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}

	filter_init(fd);

	// build filter
	static const struct sock_filter filter[] = {
#ifndef __x86_64__
		// block old multiplexing mmap syscall for i386
		BLACKLIST(SYS_mmap),
#endif
		// block mmap(,,x|PROT_WRITE|PROT_EXEC) so W&X memory can't be created
#ifndef __x86_64__
		// mmap2 is used for mmap on i386 these days
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SYS_mmap2, 0, 5),
#else
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SYS_mmap, 0, 5),
#endif
		EXAMINE_ARGUMENT(2),
		BPF_STMT(BPF_ALU+BPF_AND+BPF_K, PROT_WRITE|PROT_EXEC),
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, PROT_WRITE|PROT_EXEC, 0, 1),
		KILL_PROCESS,
		RETURN_ALLOW,
		// block mprotect(,,PROT_EXEC) so writable memory can't be turned into executable
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SYS_mprotect, 0, 5),
		EXAMINE_ARGUMENT(2),
		BPF_STMT(BPF_ALU+BPF_AND+BPF_K, PROT_EXEC),
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, PROT_EXEC, 0, 1),
		KILL_PROCESS,
		RETURN_ALLOW,
		// block shmat(,,x|SHM_EXEC) so W&X shared memory can't be created
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SYS_shmat, 0, 5),
		EXAMINE_ARGUMENT(2),
		BPF_STMT(BPF_ALU+BPF_AND+BPF_K, SHM_EXEC),
		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, SHM_EXEC, 0, 1),
		KILL_PROCESS,
		RETURN_ALLOW
	};
	write_to_file(fd, filter, sizeof(filter));

	filter_end_blacklist(fd);

	// close file
	close(fd);
}
