/*
 * Copyright (C) 2014-2025 Firejail Authors
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
#include "../include/syscall.h"
#include <assert.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <sys/syscall.h>
#include "../include/common.h"
#include "../include/seccomp.h"

#define SYSCALL_ERROR INT_MAX
#define ERRNO_KILL -2

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

// Native syscalls (64-bit versions for 64-bit archs, etc)
static const SyscallEntry syslist[] = {
#if defined(__aarch64__)
	#include "../include/syscall_aarch64.h"
#elif defined(__alpha__)
	#include "../include/syscall_alpha.h"
#elif defined(__arc__)
	#include "../include/syscall_arc_32.h"
#elif defined(__arm__) && defined(__ARM_EABI__)
	#include "../include/syscall_armeabi.h" // Identical to syscall_aarch32.h
#elif defined(__arm__) && !defined(__ARM_EABI__)
	#include "../include/syscall_armoabi.h"
#elif defined(__csky__) || defined(__CSKY__)
	#include "../include/syscall_csky.h"
#elif defined(__hexagon__)
	#include "../include/syscall_hexagon_32.h"
#elif defined(__i386__)
	#include "../include/syscall_i386.h"
#elif defined(__loongarch64) || __loongarch_grlen == 64
	#include "../include/syscall_loongarch_64.h"
#elif defined(__m68k__)
	#include "../include/syscall_m68k.h"
#elif defined(__microblaze__) || defined(__MICROBLAZE__)
	#include "../include/syscall_microblaze.h"
#elif defined(__mips__) && _MIPS_SIM == _ABIN32
	#include "../include/syscall_mips_n32.h"
#elif defined(__mips__) && _MIPS_SIM == _ABI64
	#include "../include/syscall_mips_n64.h"
#elif defined(__mips__) && _MIPS_SIM == _ABIO32
	#include "../include/syscall_mips_o32.h"
#elif defined(__nios2__) // Support for Nios II is removed in GCC 15
	#include "../include/syscall_nios2.h"
#elif defined(__or1k__) || defined(__OR1K__)
	#include "../include/syscall_openrisc_32.h"
#elif (defined(__hppa__) || defined(__hppa)) && !defined(__LP64__)
	#include "../include/syscall_parisc_32.h"
#elif (defined(__hppa__) || defined(__hppa)) && defined(__LP64__)
	#include "../include/syscall_parisc_64.h"
#elif (defined(__powerpc__) || defined(__PPC__)) && (!defined(__powerpc64__) && !defined(__PPC64__))
	#include "../include/syscall_powerpc_32_nospu.h"
#elif defined(__powerpc64__) || defined(__PPC64__)
	#include "../include/syscall_powerpc_64_nospu.h"
#elif defined(__riscv) && __riscv_xlen == 32
	#include "../include/syscall_riscv_32.h"
#elif defined(__riscv) && __riscv_xlen == 64
	#include "../include/syscall_riscv_64.h"
#elif defined(__s390__) && !defined(__s390x__)
	#include "../include/syscall_s390_32.h"
#elif defined(__s390x__)
	#include "../include/syscall_s390_64.h"
#elif defined(__sparc__) && !defined(__arch64__)
	#include "../include/syscall_sparc_32.h"
#elif defined(__sparc__) && defined(__arch64__)
	#include "../include/syscall_sparc_64.h"
#elif defined(__sh__)
	#include "../include/syscall_superh.h"
#elif defined(__x86_64__)
	#include "../include/syscall_x86_64.h"
#elif defined(__xtensa__) || defined(__XTENSA__)
	#include "../include/syscall_xtensa.h"
#else
	#warning "Please submit a syscall table for your architecture"
#endif
};

// 32-bit syscalls for 64-bit archs
static const SyscallEntry syslist32[] = {
#if defined(__aarch64__)
	#include "../include/syscall_armeabi.h"
#elif defined(__mips__) && _MIPS_SIM == _ABI64
	#include "../include/syscall_mips_o32.h"
#elif defined(__riscv) && __riscv_xlen == 64
	#include "../include/syscall_riscv_32.h"
#elif defined(__s390x__)
	#include "../include/syscall_s390_32.h"
#elif defined(__sparc__) && defined(__arch64__)
	#include "../include/syscall_sparc_32.h"
#elif defined(__x86_64__)
	#include "../include/syscall_i386.h"
/*
#elif defined(__i386__) || defined(__arm__) || defined(__m68k__) || ...
	no secondary arch for 32-bit archs
*/
#endif
};

static const SyscallGroupList sysgroups[] = {
	{ .name = "@aio", .list =
#ifdef __NR_io_cancel
	"io_cancel,"
#endif
#ifdef __NR_io_destroy
	"io_destroy,"
#endif
#ifdef __NR_io_getevents
	"io_getevents,"
#endif
#ifdef __NR_io_pgetevents
	"io_pgetevents,"
#endif
#ifdef __NR_io_pgetevents_time64
	"io_pgetevents_time64,"
#endif
#ifdef __NR_io_setup
	"io_setup,"
#endif
#ifdef __NR_io_submit
	"io_submit,"
#endif
#ifdef __NR_io_uring_enter
	"io_uring_enter,"
#endif
#ifdef __NR_io_uring_register
	"io_uring_register,"
#endif
#ifdef __NR_io_uring_setup
	"io_uring_setup"
#endif
	},
	{ .name = "@basic-io", .list =
#ifdef __NR__llseek
	"_llseek,"
#endif
#ifdef __NR_close
	"close,"
#endif
#ifdef __NR_close_range
	"close_range,"
#endif
#ifdef __NR_dup
	"dup,"
#endif
#ifdef __NR_dup2
	"dup2,"
#endif
#ifdef __NR_dup3
	"dup3,"
#endif
#ifdef __NR_lseek
	"lseek,"
#endif
#ifdef __NR_pread64
	"pread64,"
#endif
#ifdef __NR_preadv
	"preadv,"
#endif
#ifdef __NR_preadv2
	"preadv2,"
#endif
#ifdef __NR_pwrite64
	"pwrite64,"
#endif
#ifdef __NR_pwritev
	"pwritev,"
#endif
#ifdef __NR_pwritev2
	"pwritev2,"
#endif
#ifdef __NR_read
	"read,"
#endif
#ifdef __NR_readv
	"readv,"
#endif
#ifdef __NR_write
	"write,"
#endif
#ifdef __NR_writev
	"writev"
#endif
	},
	{ .name = "@chown", .list =
#ifdef __NR_chown
	"chown,"
#endif
#ifdef __NR_chown32
	"chown32,"
#endif
#ifdef __NR_fchown
	"fchown,"
#endif
#ifdef __NR_fchown32
	"fchown32,"
#endif
#ifdef __NR_fchownat
	"fchownat,"
#endif
#ifdef __NR_lchown
	"lchown,"
#endif
#ifdef __NR_lchown32
	"lchown32"
#endif
	},
	{ .name = "@clock", .list =
#ifdef __NR_adjtimex
	"adjtimex,"
#endif
#ifdef __NR_clock_adjtime
	"clock_adjtime,"
#endif
#ifdef __NR_clock_adjtime64
	"clock_adjtime64,"
#endif
#ifdef __NR_clock_gettime
	"clock_gettime,"
#endif
#ifdef __NR_clock_gettime
	"clock_gettime,"
#endif
#ifdef __NR_clock_gettime64
	"clock_gettime64,"
#endif
#ifdef __NR_clock_getres_time64
	"clock_getres_time64,"
#endif
#ifdef __NR_clock_nanosleep
	"clock_nanosleep,"
#endif
#ifdef __NR_clock_nanosleep_time64
	"clock_nanosleep_time64,"
#endif
#ifdef __NR_clock_settime
	"clock_settime,"
#endif
#ifdef __NR_clock_settime64
	"clock_settime64,"
#endif
#ifdef __NR_gettimeofday
	"gettimeofday,"
#endif
#ifdef __NR_old_adjtimex
	"old_adjtimex,"
#endif
#ifdef __NR_osf_gettimeofday
	"osf_gettimeofday,"
#endif
#ifdef __NR_osf_settimeofday
	"osf_settimeofday,"
#endif
#ifdef __NR_settimeofday
	"settimeofday,"
#endif
#ifdef __NR_stime
	"stime,"
#endif
#ifdef __NR_time
	"time"
#endif
	},
	{ .name = "@cpu-emulation", .list =
#ifdef __NR_modify_ldt
	"modify_ldt,"
#endif
#ifdef __NR_subpage_prot
	"subpage_prot,"
#endif
#ifdef __NR_switch_endian
	"switch_endian,"
#endif
#ifdef __NR_vm86
	"vm86,"
#endif
#ifdef __NR_vm86old
	"vm86old"
#endif
#if !defined(__NR_modify_ldt) && !defined(__NR_subpage_prot) && !defined(__NR_switch_endian) && !defined(__NR_vm86) && !defined(__NR_vm86old)
	"__dummy_syscall__" // workaround for the following architectures which don't have any of above defined and empty syscall lists are not allowed:
						// arm64, alpha, arc32, armeabi, armoabi, csky, hexagon32, loongarch64, m68k, mips_n32, mips_n64, nios2, openrisc32, parisc32, parisc64, riscv32, riscv64, s390_32, s390_64, sparc32, sparc64, superh and xtensa
#endif
	},
	{ .name = "@debug", .list =
#ifdef __NR_lookup_dcookie
	"lookup_dcookie,"
#endif
#ifdef __NR_perf_event_open
	"perf_event_open,"
#endif
#ifdef __NR_pidfd_getfd
	"pidfd_getfd,"
#endif
#ifdef __NR_process_vm_writev
	"process_vm_writev,"
#endif
#ifdef __NR_rtas
	"rtas,"
#endif
#ifdef __NR_s390_runtime_instr
	"s390_runtime_instr,"
#endif
#ifdef __NR_sys_debug_setcontext
	"sys_debug_setcontext,"
#endif
#ifdef __NR_uprobe
	"uprobe,"
#endif
#ifdef __NR_uretprobe
	"uretprobe" // occasional breakages with seccomp reported, see https://lwn.net/Articles/1005662
#endif
	},
	{ .name = "@default", .list =
	"@clock,"
	"@cpu-emulation,"
	"@debug,"
	"@module,"
	"@mount,"
	"@obsolete,"
	"@raw-io,"
	"@reboot,"
	"@swap,"
#ifdef __NR_open_by_handle_at
	"open_by_handle_at,"
#endif
#ifdef __NR_name_to_handle_at
	"name_to_handle_at,"
#endif
#ifdef __NR_ioprio_set
	"ioprio_set,"
#endif
#ifdef __NR_syslog
	"syslog,"
#endif
#ifdef __NR_fanotify_init
	"fanotify_init,"
#endif
#ifdef __NR_add_key
	"add_key,"
#endif
#ifdef __NR_request_key
	"request_key,"
#endif
#ifdef __NR_mbind
	"mbind,"
#endif
#ifdef __NR_migrate_pages
	"migrate_pages,"
#endif
#ifdef __NR_move_pages
	"move_pages,"
#endif
#ifdef __NR_keyctl
	"keyctl,"
#endif
#ifdef __NR_io_setup
	"io_setup,"
#endif
#ifdef __NR_io_destroy
	"io_destroy,"
#endif
#ifdef __NR_io_getevents
	"io_getevents,"
#endif
#ifdef __NR_io_submit
	"io_submit,"
#endif
#ifdef __NR_io_cancel
	"io_cancel,"
#endif
#ifdef __NR_remap_file_pages
	"remap_file_pages,"
#endif
#ifdef __NR_set_mempolicy
	"set_mempolicy,"
#endif
#ifdef __NR_vmsplice
	"vmsplice,"
#endif
#ifdef __NR_userfaultfd
	"userfaultfd,"
#endif
#ifdef __NR_acct
	"acct,"
#endif
#ifdef __NR_bpf
	"bpf,"
#endif
#ifdef __NR_nfsservctl
	"nfsservctl,"
#endif
#ifdef __NR_setdomainname
	"setdomainname,"
#endif
#ifdef __NR_sethostname
	"sethostname,"
#endif
#ifdef __NR_vhangup
	"vhangup"
#endif
	},
	{ .name = "@default-keep", .list =
#ifdef __NR_arch_prctl
	"arch_prctl," // breaks glibc, i386 and x86_64 only
#endif
#ifdef __NR_execv
	"execv," // sparc only
#endif
	"execveat," // commonly used by fexecve
	"execve,"
	"futex,"
#ifdef __NR_mmap
	"mmap," // cannot load shared libraries
#endif
#ifdef __NR_mmap2
	"mmap2,"
#endif
	"mprotect," // cannot load shared libraries
	"prctl"
	},
	{ .name = "@default-nodebuggers", .list =
	"@default,"
#ifdef __NR_ptrace
	"ptrace,"
#endif
#ifdef __NR_personality
	"personality,"
#endif
#ifdef __NR_process_vm_readv
	"process_vm_readv"
#endif
	},
	{ .name = "@file-system", .list =
#ifdef __NR_access
	"access,"
#endif
#ifdef __NR_cachestat
	"cachestat,"
#endif
#ifdef __NR_chdir
	"chdir,"
#endif
#ifdef __NR_chmod
	"chmod,"
#endif
#ifdef __NR_close
	"close,"
#endif
#ifdef __NR_close_range
	"close_range,"
#endif
#ifdef __NR_creat
	"creat,"
#endif
#ifdef __NR_faccessat
	"faccessat,"
#endif
#ifdef __NR_faccessat2
	"faccessat2,"
#endif
#ifdef __NR_fallocate
	"fallocate,"
#endif
#ifdef __NR_fanotify_mark
	"fanotify_mark,"
#endif
#ifdef __NR_fchdir
	"fchdir,"
#endif
#ifdef __NR_fchmod
	"fchmod,"
#endif
#ifdef __NR_fchmodat
	"fchmodat,"
#endif
#ifdef __NR_fchmodat2
	"fchmodat2,"
#endif
#ifdef __NR_fcntl
	"fcntl,"
#endif
#ifdef __NR_fcntl64
	"fcntl64,"
#endif
#ifdef __NR_fgetxattr
	"fgetxattr,"
#endif
#ifdef __NR_file_getattr
	"file_getattr,"
#endif
#ifdef __NR_file_setattr
	"file_setattr,"
#endif
#ifdef __NR_flistxattr
	"flistxattr,"
#endif
#ifdef __NR_fremovexattr
	"fremovexattr,"
#endif
#ifdef __NR_fsetxattr
	"fsetxattr,"
#endif
#ifdef __NR_fstat
	"fstat,"
#endif
#ifdef __NR_fstat64
	"fstat64,"
#endif
#ifdef __NR_fstatat64
	"fstatat64,"
#endif
#ifdef __NR_fstatfs
	"fstatfs,"
#endif
#ifdef __NR_fstatfs64
	"fstatfs64,"
#endif
#ifdef __NR_ftruncate
	"ftruncate,"
#endif
#ifdef __NR_ftruncate64
	"ftruncate64,"
#endif
#ifdef __NR_futimesat
	"futimesat,"
#endif
#ifdef __NR_getcwd
	"getcwd,"
#endif
#ifdef __NR_getdents
	"getdents,"
#endif
#ifdef __NR_getdents64
	"getdents64,"
#endif
#ifdef __NR_getxattr
	"getxattr,"
#endif
#ifdef __NR_getxattrat
	"getxattrat,"
#endif
#ifdef __NR_inotify_add_watch
	"inotify_add_watch,"
#endif
#ifdef __NR_inotify_init
	"inotify_init,"
#endif
#ifdef __NR_inotify_init1
	"inotify_init1,"
#endif
#ifdef __NR_inotify_rm_watch
	"inotify_rm_watch,"
#endif
#ifdef __NR_lgetxattr
	"lgetxattr,"
#endif
#ifdef __NR_link
	"link,"
#endif
#ifdef __NR_linkat
	"linkat,"
#endif
#ifdef __NR_listxattr
	"listxattr,"
#endif
#ifdef __NR_listxattrat
	"listxattrat,"
#endif
#ifdef __NR_llistxattr
	"llistxattr,"
#endif
#ifdef __NR_lremovexattr
	"lremovexattr,"
#endif
#ifdef __NR_lsetxattr
	"lsetxattr,"
#endif
#ifdef __NR_lstat
	"lstat,"
#endif
#ifdef __NR_lstat64
	"lstat64,"
#endif
#ifdef __NR_mkdir
	"mkdir,"
#endif
#ifdef __NR_mkdirat
	"mkdirat,"
#endif
#ifdef __NR_mknod
	"mknod,"
#endif
#ifdef __NR_mknodat
	"mknodat,"
#endif
#ifdef __NR_munmap
	"munmap,"
#endif
#ifdef __NR_newfstatat
	"newfstatat,"
#endif
#ifdef __NR_oldfstat
	"oldfstat,"
#endif
#ifdef __NR_oldlstat
	"oldlstat,"
#endif
#ifdef __NR_oldstat
	"oldstat,"
#endif
#ifdef __NR_open
	"open,"
#endif
#ifdef __NR_openat
	"openat,"
#endif
#ifdef __NR_openat2
	"openat2,"
#endif
#ifdef __NR_osf_fstat
	"osf_fstat,"
#endif
#ifdef __NR_osf_fstatfs
	"osf_fstatfs,"
#endif
#ifdef __NR_osf_fstatfs64
	"osf_fstatfs64,"
#endif
#ifdef __NR_osf_getdirentries
	"osf_getdirentries,"
#endif
#ifdef __NR_osf_lstat
	"osf_lstat,"
#endif
#ifdef __NR_osf_proplist_syscall
	"osf_proplist_syscall,"
#endif
#ifdef __NR_osf_utimes
	"osf_utimes,"
#endif
#ifdef __NR_quotactl_fd
	"quotactl_fd,"
#endif
#ifdef __NR_readlink
	"readlink,"
#endif
#ifdef __NR_readlinkat
	"readlinkat,"
#endif
#ifdef __NR_removexattr
	"removexattr,"
#endif
#ifdef __NR_removexattrat
	"removexattrat,"
#endif
#ifdef __NR_rename
	"rename,"
#endif
#ifdef __NR_renameat
	"renameat,"
#endif
#ifdef __NR_renameat2
	"renameat2,"
#endif
#ifdef __NR_rmdir
	"rmdir,"
#endif
#ifdef __NR_setxattr
	"setxattr,"
#endif
#ifdef __NR_setxattrat
	"setxattrat,"
#endif
#ifdef __NR_stat
	"stat,"
#endif
#ifdef __NR_stat64
	"stat64,"
#endif
#ifdef __NR_statfs
	"statfs,"
#endif
#ifdef __NR_statfs64
	"statfs64,"
#endif
#ifdef __NR_statx
	"statx,"
#endif
#ifdef __NR_symlink
	"symlink,"
#endif
#ifdef __NR_symlinkat
	"symlinkat,"
#endif
#ifdef __NR_truncate
	"truncate,"
#endif
#ifdef __NR_truncate64
	"truncate64,"
#endif
#ifdef __NR_unlink
	"unlink,"
#endif
#ifdef __NR_unlinkat
	"unlinkat,"
#endif
#ifdef __NR_utime
	"utime,"
#endif
#ifdef __NR_utimensat
	"utimensat,"
#endif
#ifdef __NR_utimes
	"utimes"
#endif
	},
	{ .name = "@io-event", .list =
#ifdef __NR__newselect
	"_newselect,"
#endif
#ifdef __NR_epoll_create
	"epoll_create,"
#endif
#ifdef __NR_epoll_create1
	"epoll_create1,"
#endif
#ifdef __NR_epoll_ctl
	"epoll_ctl,"
#endif
#ifdef __NR_epoll_pwait
	"epoll_pwait,"
#endif
#ifdef __NR_epoll_pwait2
	"epoll_pwait2,"
#endif
#ifdef __NR_epoll_wait
	"epoll_wait,"
#endif
#ifdef __NR_eventfd
	"eventfd,"
#endif
#ifdef __NR_eventfd2
	"eventfd2,"
#endif
#ifdef __NR_osf_select
	"osf_select,"
#endif
#ifdef __NR_poll
	"poll,"
#endif
#ifdef __NR_ppoll
	"ppoll,"
#endif
#ifdef __NR_ppoll_time64
	"ppoll_time64,"
#endif
#ifdef __NR_pselect6_time64
	"pselect6_time64,"
#endif
#ifdef __NR_pselect6
	"pselect6,"
#endif
#ifdef __NR_select
	"select"
#endif
	},
	{ .name = "@ipc", .list =
#ifdef __NR_ipc
	"ipc,"
#endif
#ifdef __NR_mq_getsetattr
	"mq_getsetattr,"
#endif
#ifdef __NR_mq_notify
	"mq_notify,"
#endif
#ifdef __NR_mq_open
	"mq_open,"
#endif
#ifdef __NR_mq_timedreceive
	"mq_timedreceive,"
#endif
#ifdef __NR_mq_timedreceive_time64
	"mq_timedreceive_time64,"
#endif
#ifdef __NR_mq_timedsend
	"mq_timedsend,"
#endif
#ifdef __NR_mq_timedsend_time64
	"mq_timedsend_time64,"
#endif
#ifdef __NR_mq_unlink
	"mq_unlink,"
#endif
#ifdef __NR_msgctl
	"msgctl,"
#endif
#ifdef __NR_msgget
	"msgget,"
#endif
#ifdef __NR_msgrcv
	"msgrcv,"
#endif
#ifdef __NR_msgsnd
	"msgsnd,"
#endif
#ifdef __NR_pipe
	"pipe,"
#endif
#ifdef __NR_pipe2
	"pipe2,"
#endif
#ifdef __NR_process_madvise
	"process_madvise,"
#endif
#ifdef __NR_process_mrelease
	"process_mrelease,"
#endif
#ifdef __NR_process_vm_readv
	"process_vm_readv,"
#endif
#ifdef __NR_process_vm_writev
	"process_vm_writev,"
#endif
#ifdef __NR_semctl
	"semctl,"
#endif
#ifdef __NR_semget
	"semget,"
#endif
#ifdef __NR_semop
	"semop,"
#endif
#ifdef __NR_semtimedop
	"semtimedop,"
#endif
#ifdef __NR_semtimedop_time64
	"semtimedop_time64,"
#endif
#ifdef __NR_shmat
	"shmat,"
#endif
#ifdef __NR_shmctl
	"shmctl,"
#endif
#ifdef __NR_shmdt
	"shmdt,"
#endif
#ifdef __NR_shmget
	"shmget"
#endif
	},
	{ .name = "@keyring", .list =
#ifdef __NR_add_key
	"add_key,"
#endif
#ifdef __NR_keyctl
	"keyctl,"
#endif
#ifdef __NR_request_key
	"request_key"
#endif
	},
	{ .name = "@memfd", .list =
#ifdef __NR_memfd_create
	"memfd_create,"
#endif
#ifdef __NR_memfd_secret
	"memfd_secret"
#endif
	},
	{ .name = "@memlock", .list =
#ifdef __NR_mlock
	"mlock,"
#endif
#ifdef __NR_mlock2
	"mlock2,"
#endif
#ifdef __NR_mlockall
	"mlockall,"
#endif
#ifdef __NR_munlock
	"munlock,"
#endif
#ifdef __NR_munlockall
	"munlockall"
#endif
	},
	{ .name = "@module", .list =
#ifdef __NR_delete_module
	"delete_module,"
#endif
#ifdef __NR_finit_module
	"finit_module,"
#endif
#ifdef __NR_init_module
	"init_module"
#endif
	},
	{ .name = "@mount", .list =
#ifdef __NR_chroot
	"chroot,"
#endif
#ifdef __NR_fsconfig
	"fsconfig,"
#endif
#ifdef __NR_fsmount
	"fsmount,"
#endif
#ifdef __NR_fsopen
	"fsopen,"
#endif
#ifdef __NR_fspick
	"fspick,"
#endif
#ifdef __NR_listmount
	"listmount,"
#endif
#ifdef __NR_mount
	"mount,"
#endif
#ifdef __NR_mount_setattr
	"mount_setattr,"
#endif
#ifdef __NR_move_mount
	"move_mount,"
#endif
#ifdef __NR_oldumount
	"open_oldumount,"
#endif
#ifdef __NR_open_tree
	"open_tree,"
#endif
#ifdef __NR_open_tree_attr
	"open_tree_attr,"
#endif
#ifdef __NR_osf_mount
	"osf_mount,"
#endif
#ifdef __NR_pivot_root
	"pivot_root,"
#endif
#ifdef __NR_statmount
	"statmount,"
#endif
#ifdef __NR_umount
	"umount,"
#endif
#ifdef __NR_umount2
	"umount2"
#endif
	},
	{ .name = "@network-io", .list =
#ifdef __NR_accept
	"accept,"
#endif
#ifdef __NR_accept4
	"accept4,"
#endif
#ifdef __NR_bind
	"bind,"
#endif
#ifdef __NR_connect
	"connect,"
#endif
#ifdef __NR_getpeername
	"getpeername,"
#endif
#ifdef __NR_getsockname
	"getsockname,"
#endif
#ifdef __NR_getsockopt
	"getsockopt,"
#endif
#ifdef __NR_listen
	"listen,"
#endif
#ifdef __NR_recv
	"recv,"
#endif
#ifdef __NR_recvfrom
	"recvfrom,"
#endif
#ifdef __NR_recvmmsg
	"recvmmsg,"
#endif
#ifdef __NR_recvmmsg_time64
	"recvmmsg_time64,"
#endif
#ifdef __NR_recvmsg
	"recvmsg,"
#endif
#ifdef __NR_send
	"send,"
#endif
#ifdef __NR_sendmmsg
	"sendmmsg,"
#endif
#ifdef __NR_sendmsg
	"sendmsg,"
#endif
#ifdef __NR_sendto
	"sendto,"
#endif
#ifdef __NR_setsockopt
	"setsockopt,"
#endif
#ifdef __NR_shutdown
	"shutdown,"
#endif
#ifdef __NR_socket
	"socket,"
#endif
#ifdef __NR_socketcall
	"socketcall,"
#endif
#ifdef __NR_socketpair
	"socketpair"
#endif
	},
	{ .name = "@obsolete", .list =
#ifdef __NR__sysctl
	"_sysctl,"
#endif
#ifdef __NR_afs_syscall
	"afs_syscall,"
#endif
#ifdef __NR_bdflush
	"bdflush,"
#endif
#ifdef __NR_break
	"break,"
#endif
#ifdef __NR_create_module
	"create_module,"
#endif
#ifdef __NR_dipc
	"dipc,"
#endif
#ifdef __NR_epoll_ctl_old
	"epoll_ctl_old,"
#endif
#ifdef __NR_epoll_wait_old
	"epoll_wait_old,"
#endif
#ifdef __NR_exec_with_loader
	"exec_with_loader,"
#endif
#ifdef __NR_ftime
	"ftime,"
#endif
#ifdef __NR_get_kernel_syms
	"get_kernel_syms,"
#endif
#ifdef __NR_getpmsg
	"getpmsg,"
#endif
#ifdef __NR_gtty
	"gtty,"
#endif
#ifdef __NR_idle
	"idle,"
#endif
#ifdef __NR_llseek
	"llseek,"
#endif
#ifdef __NR_lock
	"lock,"
#endif
#ifdef __NR_mpx
	"mpx,"
#endif
#ifdef __NR_multiplexer
	"multiplexer,"
#endif
#ifdef __NR_osf_adjtime
	"osf_adjtime,"
#endif
#ifdef __NR_osf_afs_syscall
	"osf_afs_syscall,"
#endif
#ifdef __NR_osf_alt_plock
	"osf_alt_plock,"
#endif
#ifdef __NR_osf_alt_setsid
	"osf_alt_setsid,"
#endif
#ifdef __NR_osf_alt_sigpending
	"osf_alt_sigpending,"
#endif
#ifdef __NR_osf_asynch_daemon
	"osf_asynch_daemon,"
#endif
#ifdef __NR_osf_audcntl
	"osf_audcntl,"
#endif
#ifdef __NR_osf_audgen
	"osf_audgen,"
#endif
#ifdef __NR_osf_chflags
	"osf_chflags,"
#endif
#ifdef __NR_osf_execve
	"osf_execve,"
#endif
#ifdef __NR_osf_exportfs
	"osf_exportfs,"
#endif
#ifdef __NR_osf_fchflags
	"osf_fchflags,"
#endif
#ifdef __NR_osf_fdatasync
	"osf_fdatasync,"
#endif
#ifdef __NR_osf_fpathconf
	"osf_fpathconf,"
#endif
#ifdef __NR_osf_fuser
	"osf_fuser,"
#endif
#ifdef __NR_osf_getaddressconf
	"osf_getaddressconf,"
#endif
#ifdef __NR_osf_getfh
	"osf_getfh,"
#endif
#ifdef __NR_osf_getfsstat
	"osf_getfsstat,"
#endif
#ifdef __NR_osf_gethostid
	"osf_gethostid,"
#endif
#ifdef __NR_osf_getlogin
	"osf_getlogin,"
#endif
#ifdef __NR_osf_getmnt
	"osf_getmnt,"
#endif
#ifdef __NR_osf_kloadcall
	"osf_kloadcall,"
#endif
#ifdef __NR_osf_kmodcall
	"osf_kmodcall,"
#endif
#ifdef __NR_osf_memcntl
	"osf_memcntl,"
#endif
#ifdef __NR_osf_mincore
	"osf_mincore,"
#endif
#ifdef __NR_osf_mremap
	"osf_mremap,"
#endif
#ifdef __NR_osf_msfs_syscall
	"osf_msfs_syscall,"
#endif
#ifdef __NR_osf_msleep
	"osf_msleep,"
#endif
#ifdef __NR_osf_mvalid
	"osf_mvalid,"
#endif
#ifdef __NR_osf_mwakeup
	"osf_mwakeup,"
#endif
#ifdef __NR_osf_naccept
	"osf_naccept,"
#endif
#ifdef __NR_osf_nfssvc
	"osf_nfssvc,"
#endif
#ifdef __NR_osf_ngetpeername
	"osf_ngetpeername,"
#endif
#ifdef __NR_osf_ngetsockname
	"osf_ngetsockname,"
#endif
#ifdef __NR_osf_nrecvfrom
	"osf_nrecvfrom,"
#endif
#ifdef __NR_osf_nrecvmsg
	"osf_nrecvmsg,"
#endif
#ifdef __NR_osf_nsendmsg
	"osf_nsendmsg,"
#endif
#ifdef __NR_osf_ntp_adjtime
	"osf_ntp_adjtime,"
#endif
#ifdef __NR_osf_ntp_gettime
	"osf_ntp_gettime,"
#endif
#ifdef __NR_osf_old_creat
	"osf_old_creat,"
#endif
#ifdef __NR_osf_old_fstat
	"osf_old_fstat,"
#endif
#ifdef __NR_osf_old_getpgrp
	"osf_old_getpgrp,"
#endif
#ifdef __NR_osf_old_killpg
	"osf_old_killpg,"
#endif
#ifdef __NR_osf_old_lstat
	"osf_old_lstat,"
#endif
#ifdef __NR_osf_old_open
	"osf_old_open,"
#endif
#ifdef __NR_osf_old_sigaction
	"osf_old_sigaction,"
#endif
#ifdef __NR_osf_old_sigblock
	"osf_old_sigblock,"
#endif
#ifdef __NR_osf_old_sigreturn
	"osf_old_sigreturn,"
#endif
#ifdef __NR_osf_old_sigsetmask
	"osf_old_sigsetmask,"
#endif
#ifdef __NR_osf_old_sigvec
	"osf_old_sigvec,"
#endif
#ifdef __NR_osf_old_stat
	"osf_old_stat,"
#endif
#ifdef __NR_osf_old_vadvise
	"osf_old_vadvise,"
#endif
#ifdef __NR_osf_old_vtrace
	"osf_old_vtrace,"
#endif
#ifdef __NR_osf_old_wait
	"osf_old_wait,"
#endif
#ifdef __NR_osf_oldquota
	"osf_oldquota,"
#endif
#ifdef __NR_osf_pathconf
	"osf_pathconf,"
#endif
#ifdef __NR_osf_pid_block
	"osf_pid_block,"
#endif
#ifdef __NR_osf_pid_unblock
	"osf_pid_unblock,"
#endif
#ifdef __NR_osf_plock
	"osf_plock,"
#endif
#ifdef __NR_osf_priocntlset
	"osf_priocntlset,"
#endif
#ifdef __NR_osf_profil
	"osf_profil,"
#endif
#ifdef __NR_osf_reboot
	"osf_reboot,"
#endif
#ifdef __NR_osf_revoke
	"osf_revoke,"
#endif
#ifdef __NR_osf_sbrk
	"osf_sbrk,"
#endif
#ifdef __NR_osf_security
	"osf_security,"
#endif
#ifdef __NR_osf_set_speculative
	"osf_set_speculative,"
#endif
#ifdef __NR_osf_sethostid
	"osf_sethostid,"
#endif
#ifdef __NR_osf_setlogin
	"osf_setlogin,"
#endif
#ifdef __NR_osf_signal
	"osf_signal,"
#endif
#ifdef __NR_osf_sigsendset
	"osf_sigsendset,"
#endif
#ifdef __NR_osf_sigwaitprim
	"osf_sigwaitprim,"
#endif
#ifdef __NR_osf_sstk
	"osf_sstk,"
#endif
#ifdef __NR_osf_stat
	"osf_stat,"
#endif
#ifdef __NR_osf_statfs
	"osf_statfs,"
#endif
#ifdef __NR_osf_statfs64
	"osf_statfs64,"
#endif
#ifdef __NR_osf_subsys_info
	"osf_subsys_info,"
#endif
#ifdef __NR_osf_swapctl
	"osf_swapctl,"
#endif
#ifdef __NR_osf_table
	"osf_table,"
#endif
#ifdef __NR_osf_uadmin
	"osf_uadmin,"
#endif
#ifdef __NR_osf_uswitch
	"osf_uswitch,"
#endif
#ifdef __NR_osf_utc_adjtime
	"osf_utc_adjtime,"
#endif
#ifdef __NR_osf_utc_gettime
	"osf_utc_gettime,"
#endif
#ifdef __NR_osf_waitid
	"osf_waitid,"
#endif
#ifdef __NR_perfctr
	"perfctr,"
#endif
#ifdef __NR_prof
	"prof,"
#endif
#ifdef __NR_profil
	"profil,"
#endif
#ifdef __NR_putpmsg
	"putpmsg,"
#endif
#ifdef __NR_query_module
	"query_module,"
#endif
#ifdef __NR_security
	"security,"
#endif
#ifdef __NR_sgetmask
	"sgetmask,"
#endif
#ifdef __NR_spill
	"spill,"
#endif
#ifdef __NR_ssetmask
	"ssetmask,"
#endif
#ifdef __NR_stty
	"stty,"
#endif
#ifdef __NR_sysfs
	"sysfs,"
#endif
#ifdef __NR_timerfd
	"timerfd,"
#endif
#ifdef __NR_tuxcall
	"tuxcall,"
#endif
#ifdef __NR_ulimit
	"ulimit,"
#endif
#ifdef __NR_uselib
	"uselib,"
#endif
#ifdef __NR_ustat
	"ustat,"
#endif
#ifdef __NR_vserver
	"vserver,"
#endif
#ifdef __NR_xtensa
	"xtensa"
#endif
#if defined(__aarch64__) || defined(__loongarch64) || __loongarch_grlen == 64 || (defined(__riscv) && __riscv_xlen == 64)
	"__dummy_syscall__" // workaround for arm64, loongarch64 and riscv64 which doesn't have any of above defined and empty syscall lists are not allowed
#endif
	},
	{ .name = "@privileged", .list =
	"@chown,"
	"@clock,"
	"@module,"
	"@raw-io,"
	"@reboot,"
	"@swap,"
#ifdef __NR__sysctl
	"_sysctl,"
#endif
#ifdef __NR_acct
	"acct,"
#endif
#ifdef __NR_bpf
	"bpf,"
#endif
#ifdef __NR_capset
	"capset,"
#endif
#ifdef __NR_chroot
	"chroot,"
#endif
#ifdef __NR_fanotify_init
	"fanotify_init,"
#endif
#ifdef __NR_mount
	"mount,"
#endif
#ifdef __NR_nfsservctl
	"nfsservctl,"
#endif
#ifdef __NR_open_by_handle_at
	"open_by_handle_at,"
#endif
#ifdef __NR_pivot_root
	"pivot_root,"
#endif
#ifdef __NR_quotactl
	"quotactl,"
#endif
#ifdef __NR_setdomainname
	"setdomainname,"
#endif
#ifdef __NR_setfsuid
	"setfsuid,"
#endif
#ifdef __NR_setfsuid32
	"setfsuid32,"
#endif
#ifdef __NR_setgroups
	"setgroups,"
#endif
#ifdef __NR_setgroups32
	"setgroups32,"
#endif
#ifdef __NR_sethostname
	"sethostname,"
#endif
#ifdef __NR_setresuid
	"setresuid,"
#endif
#ifdef __NR_setresuid32
	"setresuid32,"
#endif
#ifdef __NR_setreuid
	"setreuid,"
#endif
#ifdef __NR_setreuid32
	"setreuid32,"
#endif
#ifdef __NR_setuid
	"setuid,"
#endif
#ifdef __NR_setuid32
	"setuid32,"
#endif
#ifdef __NR_umount2
	"umount2,"
#endif
#ifdef __NR_vhangup
	"vhangup"
#endif
	},
	{ .name = "@process", .list =
#ifdef __NR_arc_gettls
	"arc_gettls,"
#endif
#ifdef __NR_arc_settls
	"arc_settls,"
#endif
#ifdef __NR_arc_usr_cmpxchg
	"arc_usr_cmpxchg,"
#endif
#ifdef __NR_atomic_barrier
	"atomic_barrier,"
#endif
#ifdef __NR_atomic_cmpxchg_32
	"atomic_cmpxchg_32,"
#endif
#ifdef __NR_cachectl
	"cachectl,"
#endif
#ifdef __NR_cacheflush
	"cacheflush,"
#endif
#ifdef __NR_capget
	"capget,"
#endif
#ifdef __NR_clone
	"clone,"
#endif
#ifdef __NR_clone3
	"clone3,"
#endif
#ifdef __NR_exit
	"exit,"
#endif
#ifdef __NR_exit_group
	"exit_group,"
#endif
#ifdef __NR_fork
	"fork,"
#endif
#ifdef __NR_futex_requeue
	"futex_requeue,"
#endif
#ifdef __NR_futex_time64
	"futex_time64,"
#endif
#ifdef __NR_futex_wait
	"futex_wait,"
#endif
#ifdef __NR_futex_waitv
	"futex_waitv,"
#endif
#ifdef __NR_futex_wake
	"futex_wake,"
#endif
#ifdef __NR_get_robust_list
	"get_robust_list,"
#endif
#ifdef __NR_get_thread_area
	"get_thread_area,"
#endif
#ifdef __NR_getegid
	"getegid,"
#endif
#ifdef __NR_geteuid
	"geteuid,"
#endif
#ifdef __NR_geteuid32
	"geteuid32,"
#endif
#ifdef __NR_getgid
	"getgid,"
#endif
#ifdef __NR_getegid32
	"getegid32,"
#endif
#ifdef __NR_getgroups
	"getgroups,"
#endif
#ifdef __NR_getgroups32
	"getgroups32,"
#endif
#ifdef __NR_getpgid
	"getpgid,"
#endif
#ifdef __NR_getpgrp
	"getpgrp,"
#endif
#ifdef __NR_getpid
	"getpid,"
#endif
#ifdef __NR_getppid
	"getppid,"
#endif
#ifdef __NR_getresgid
	"getresgid,"
#endif
#ifdef __NR_getresgid32
	"getresgid32,"
#endif
#ifdef __NR_getresuid
	"getresuid,"
#endif
#ifdef __NR_getresuid32
	"getresuid32,"
#endif
#ifdef __NR_getsid
	"getsid,"
#endif
#ifdef __NR_gettid
	"gettid,"
#endif
#ifdef __NR_getuid
	"getuid,"
#endif
#ifdef __NR_getuid32
	"getuid32,"
#endif
#ifdef __NR_getxgid
	"getxgid,"
#endif
#ifdef __NR_getxpid
	"getxpid,"
#endif
#ifdef __NR_getxuid
	"getxuid,"
#endif
#ifdef __NR_kill
	"kill,"
#endif
#ifdef __NR_membarrier
	"membarrier,"
#endif
#ifdef __or1k_atomic
	"or1k_atomic,"
#endif
#ifdef __NR_osf_set_program_attributes
	"osf_set_program_attributes,"
#endif
#ifdef __NR_osf_wait4
	"osf_wait4,"
#endif
#ifdef __NR_pidfd_open
	"pidfd_open,"
#endif
#ifdef __NR_pidfd_send_signal
	"pidfd_send_signal,"
#endif
#ifdef __NR_riscv_flush_icache
	"riscv_flush_icache,"
#endif
#ifdef __NR_rseq
	"rseq,"
#endif
#ifdef __NR_rt_sigqueueinfo
	"rt_sigqueueinfo,"
#endif
#ifdef __NR_rt_tgsigqueueinfo
	"rt_tgsigqueueinfo,"
#endif
#ifdef __NR_s390_guarded_storage
	"s390_guarded_storage,"
#endif
#ifdef __NR_sched_get_affinity
	"sched_get_affinity,"
#endif
#ifdef __NR_setns
	"setns,"
#endif
#ifdef __NR_set_robust_list
	"set_robust_list,"
#endif
#ifdef __NR_set_thread_area
	"set_thread_area,"
#endif
#ifdef __NR_set_tid_address
	"set_tid_address,"
#endif
#ifdef __NR_sethae
	"sethae,"
#endif
#ifdef __NR_setpgrp
	"setpgrp,"
#endif
#ifdef __NR_setpriority
	"setpriority,"
#endif
#ifdef __NR_spu_create
	"spu_create,"
#endif
#ifdef __NR_spu_run
	"spu_run,"
#endif
#ifdef __NR_swapcontext
	"swapcontext,"
#endif
#ifdef __NR_tgkill
	"tgkill,"
#endif
#ifdef __NR_times
	"times,"
#endif
#ifdef __NR_tkill
	"tkill,"
#endif
#ifdef __NR_unshare
	"unshare,"
#endif
#ifdef __NR_utimensat_time64
	"utimensat_time64,"
#endif
#ifdef __NR_vfork
	"vfork,"
#endif
#ifdef __NR_wait4
	"wait4,"
#endif
#ifdef __NR_waitid
	"waitid,"
#endif
#ifdef __NR_waitpid
	"waitpid"
#endif
	},
	{ .name = "@raw-io", .list =
#ifdef __NR_ioperm
	"ioperm,"
#endif
#ifdef __NR_iopl
	"iopl,"
#endif
#ifdef __NR_pciconfig_iobase
	"pciconfig_iobase,"
#endif
#ifdef __NR_pciconfig_read
	"pciconfig_read,"
#endif
#ifdef __NR_pciconfig_write
	"pciconfig_write,"
#endif
#ifdef __NR_s390_pci_mmio_read
	"s390_pci_mmio_read,"
#endif
#ifdef __NR_s390_pci_mmio_write
	"s390_pci_mmio_write"
#endif
#if !defined(__NR_ioperm) && !defined(__NR_iopl) && !defined(__NR_pciconfig_iobase) && !defined(__NR_pciconfig_read) && !defined(__NR_pciconfig_write) && !defined(__NR_s390_pci_mmio_read) && !defined(__NR_s390_pci_mmio_write)
	"__dummy_syscall__" // workaround for the following architectures which doesn't have any of above defined and empty syscall lists are not allowed:
						// arm64, arc32, hexagon32, loongarch64, m68k, mips_n32, mips_n64, nios2, openrisc32, parisc32, parisc64, riscv32, riscv64, superh and xtensa
#endif
	},
	{ .name = "@reboot", .list =
#ifdef __NR_kexec_load
	"kexec_load,"
#endif
#ifdef __NR_kexec_file_load
	"kexec_file_load,"
#endif
#ifdef __NR_reboot
	"reboot"
#endif
	},
	{ .name = "@resources", .list =
#ifdef __NR_getdtablesize
	"getdtablesize,"
#endif
#ifdef __NR_getrlimit
	"getrlimit,"
#endif
#ifdef __NR_getrusage
	"getrusage,"
#endif
#ifdef __NR_ioprio_set
	"ioprio_set,"
#endif
#ifdef __NR_mbind
	"mbind,"
#endif
#ifdef __NR_migrate_pages
	"migrate_pages,"
#endif
#ifdef __NR_mincore
	"mincore,"
#endif
#ifdef __NR_move_pages
	"move_pages,"
#endif
#ifdef __NR_nice
	"nice,"
#endif
#ifdef __NR_osf_getrusage
	"osf_getrusage,"
#endif
#ifdef __NR_prlimit64
	"prlimit64,"
#endif
#ifdef __NR_sched_set_affinity
	"sched_set_affinity,"
#endif
#ifdef __NR_sched_set_mempolicy_home_node
	"set_mempolicy_home_node,"
#endif
#ifdef __NR_sched_setaffinity
	"sched_setaffinity,"
#endif
#ifdef __NR_sched_setattr
	"sched_setattr,"
#endif
#ifdef __NR_sched_setparam
	"sched_setparam,"
#endif
#ifdef __NR_setrlimit
	"sched_setrlimit,"
#endif
#ifdef __NR_sched_setscheduler
	"sched_setscheduler,"
#endif
#ifdef __NR_set_mempolicy
	"set_mempolicy,"
#endif
#ifdef __NR_set_mempolicy
	"ugetrlimit"
#endif
	},
	{ .name = "@sandbox", .list =
#ifdef __NR_landlock_add_rule
	"landlock_add_rule,"
#endif
#ifdef __NR_landlock_create_ruleset
	"landlock_create_ruleset,"
#endif
#ifdef __NR_landlock_restrict_self
	"landlock_restrict_self,"
#endif
#ifdef __NR_seccomp
	"seccomp"
#endif
	},
	{ .name = "@setuid", .list =
#ifdef __NR_setgid
	"setgid,"
#endif
#ifdef __NR_setgid32
	"setgid32,"
#endif
#ifdef __NR_setgroups
	"setgroups,"
#endif
#ifdef __NR_setgroups32
	"setgroups32,"
#endif
#ifdef __NR_setregid
	"setregid,"
#endif
#ifdef __NR_setregid32
	"setregid32,"
#endif
#ifdef __NR_setresgid
	"setresgid,"
#endif
#ifdef __NR_setresgid32
	"setresgid32,"
#endif
#ifdef __NR_setresuid
	"setresuid,"
#endif
#ifdef __NR_setresuid32
	"setresuid32,"
#endif
#ifdef __NR_setreuid
	"setreuid,"
#endif
#ifdef __NR_setreuid32
	"setreuid32,"
#endif
#ifdef __NR_setuid
	"setuid,"
#endif
#ifdef __NR_setuid32
	"setuid32"
#endif
	},
	{ .name = "@signal", .list =
#ifdef __NR_osf_sigprocmask
	"osf_sigprocmask,"
#endif
#ifdef __NR_osf_sigstack
	"osf_sigstack,"
#endif
#ifdef __NR_pause
	"pause,"
#endif
#ifdef __NR_restart_syscall
	"restart_syscall,"
#endif
#ifdef __NR_rt_sigaction
	"rt_sigaction,"
#endif
#ifdef __NR_rt_sigpending
	"rt_sigpending,"
#endif
#ifdef __NR_rt_sigprocmask
	"rt_sigprocmask,"
#endif
#ifdef __NR_rt_sigreturn
	"rt_sigreturn,"
#endif
#ifdef __NR_rt_sigtimedwait_time64
	"rt_sigtimedwait_time64,"
#endif
#ifdef __NR_rt_sigsuspend
	"rt_sigsuspend,"
#endif
#ifdef __NR_rt_sigtimedwait
	"rt_sigtimedwait,"
#endif
#ifdef __NR_sigaction
	"sigaction,"
#endif
#ifdef __NR_sigaltstack
	"sigaltstack,"
#endif
#ifdef __NR_signal
	"signal,"
#endif
#ifdef __NR_signalfd
	"signalfd,"
#endif
#ifdef __NR_signalfd4
	"signalfd4,"
#endif
#ifdef __NR_sigpending
	"sigpending,"
#endif
#ifdef __NR_sigprocmask
	"sigprocmask,"
#endif
#ifdef __NR_sigreturn
	"sigreturn,"
#endif
#ifdef __NR_sigsuspend
	"sigsuspend,"
#endif
#ifdef __NR_utrap_install
	"utrap_install"
#endif
	},
	{ .name = "@swap", .list =
#ifdef __NR_osf_swapon
	"osf_swapon,"
#endif
#ifdef __NR_swapon
	"swapon,"
#endif
#ifdef __NR_swapoff
	"swapoff"
#endif
	},
	{ .name = "@sync", .list =
#ifdef __NR_arm_sync_file_range
	"arm_sync_file_range,"
#endif
#ifdef __NR_fdatasync
	"fdatasync,"
#endif
#ifdef __NR_fsync
	"fsync,"
#endif
#ifdef __NR_msync
	"msync,"
#endif
#ifdef __NR_sync
	"sync,"
#endif
#ifdef __NR_sync_file_range
	"sync_file_range,"
#endif
#ifdef __NR_sync_file_range2
	"sync_file_range2,"
#endif
#ifdef __NR_syncfs
	"syncfs"
#endif
	},
	{ .name = "@system-service", .list =
	"@aio,"
	"@basic-io,"
	"@chown,"
	"@default,"
	"@file-system,"
	"@io-event,"
	"@ipc,"
	"@keyring,"
	"@memlock,"
	"@network-io,"
	"@process,"
	"@resources,"
	"@setuid,"
	"@signal,"
	"@sync,"
	"@timer,"
#ifdef __NR_arm_fadvise64_64
	"arm_fadvise64_64,"
#endif
#ifdef __NR_brk
	"brk,"
#endif
#ifdef __NR_capget
	"capget,"
#endif
#ifdef __NR_capset
	"capset,"
#endif
#ifdef __NR_copy_file_range
	"copy_file_range,"
#endif
#ifdef __NR_fadvise64
	"fadvise64,"
#endif
#ifdef __NR_fadvise64_64
	"fadvise64_64,"
#endif
#ifdef __NR_flock
	"flock,"
#endif
#ifdef __NR_get_mempolicy
	"get_mempolicy,"
#endif
#ifdef __NR_getcpu
	"getcpu,"
#endif
#ifdef __NR_getdomainname
	"getdomainname,"
#endif
#ifdef __NR_gethostname
	"gethostname,"
#endif
#ifdef __NR_getpagesize
	"getpagesize,"
#endif
#ifdef __NR_getpriority
	"getpriority,"
#endif
#ifdef __NR_getrandom
	"getrandom,"
#endif
#ifdef __NR_ioctl
	"ioctl,"
#endif
#ifdef __NR_ioprio_get
	"ioprio_get,"
#endif
#ifdef __NR_kcmp
	"kcmp,"
#endif
#ifdef __NR_kern_features
	"kern_features,"
#endif
#ifdef __NR_listns
	"listns,"
#endif
#ifdef __NR_lsm_get_self_attr
	"lsm_get_self_attr,"
#endif
#ifdef __NR_lsm_list_modules
	"lsm_list_modules,"
#endif
#ifdef __NR_lsm_set_self_attr
	"lsm_set_self_attr,"
#endif
#ifdef __NR_map_shadow_stack
	"map_shadow_stack,"
#endif
#ifdef __NR_madvise
	"madvise,"
#endif
#ifdef __NR_memory_ordering
	"memory_ordering,"
#endif
#ifdef __NR_mremap
	"mremap,"
#endif
#ifdef __NR_mseal
	"mseal,"
#endif
#ifdef __NR_name_to_handle_at
	"name_to_handle_at,"
#endif
#ifdef __NR_oldolduname
	"oldolduname,"
#endif
#ifdef __NR_olduname
	"olduname,"
#endif
#ifdef __NR_osf_getdomainname
	"osf_getdomainname,"
#endif
#ifdef __NR_osf_getsysinfo
	"osf_getsysinfo,"
#endif
#ifdef __NR_osf_setsysinfo
	"osf_setsysinfo,"
#endif
#ifdef __NR_osf_syscall
	"osf_syscall,"
#endif
#ifdef __NR_osf_sysinfo
	"osf_sysinfo,"
#endif
#ifdef __NR_osf_utsname
	"osf_utsname,"
#endif
#ifdef __NR_personality
	"personality,"
#endif
#ifdef __NR_pkey_alloc
	"pkey_alloc,"
#endif
#ifdef __NR_pkey_free
	"pkey_free,"
#endif
#ifdef __NR_pkey_mprotect
	"pkey_mprotect,"
#endif
#ifdef __NR_readahead
	"readahead,"
#endif
#ifdef __NR_readdir
	"readdir,"
#endif
#ifdef __NR_remap_file_pages
	"remap_file_pages,"
#endif
#ifdef __NR_riscv_hwprobe
	"riscv_hwprobe,"
#endif
#ifdef __NR_s390_sthyi
	"s390_sthyi,"
#endif
#ifdef __NR_sched_get_priority_max
	"sched_get_priority_max,"
#endif
#ifdef __NR_sched_get_priority_min
	"sched_get_priority_min,"
#endif
#ifdef __NR_sched_getaffinity
	"sched_getaffinity,"
#endif
#ifdef __NR_sched_getattr
	"sched_getattr,"
#endif
#ifdef __NR_sched_getparam
	"sched_getparam,"
#endif
#ifdef __NR_sched_getscheduler
	"sched_getscheduler,"
#endif
#ifdef __NR_sched_rr_get_interval
	"sched_rr_get_interval,"
#endif
#ifdef __NR_sched_rr_get_interval_time64
	"sched_rr_get_interval_time64,"
#endif
#ifdef __NR_sched_yield
	"sched_yield,"
#endif
#ifdef __NR_sendfile
	"sendfile,"
#endif
#ifdef __NR_sendfile64
	"sendfile64,"
#endif
#ifdef __NR_setfsgid
	"setfsgid,"
#endif
#ifdef __NR_setfsgid32
	"setfsgid32,"
#endif
#ifdef __NR_setfsuid
	"setfsuid,"
#endif
#ifdef __NR_setfsuid32
	"setfsuid32,"
#endif
#ifdef __NR_setpgid
	"setpgid,"
#endif
#ifdef __NR_setsid
	"setsid,"
#endif
#ifdef __NR_splice
	"splice,"
#endif
#ifdef __NR_syscall
	"syscall,"
#endif
#ifdef __NR_sysinfo
	"sysinfo,"
#endif
#ifdef __NR_sysmips
	"sysmips,"
#endif
#ifdef __NR_tee
	"tee,"
#endif
#ifdef __NR_umask
	"umask,"
#endif
#ifdef __NR_uname
	"uname,"
#endif
#ifdef __NR_userfaultfd
	"userfaultfd,"
#endif
#ifdef __NR_vmsplice
	"vmsplice"
#endif
	},
	{ .name = "@timer", .list =
#ifdef __NR_alarm
	"alarm,"
#endif
#ifdef __NR_getitimer
	"getitimer,"
#endif
#ifdef __NR_nanosleep
	"nanosleep,"
#endif
#ifdef __NR_osf_getitimer
	"osf_getitimer,"
#endif
#ifdef __NR_osf_setitimer
	"osf_setitimer,"
#endif
#ifdef __NR_osf_usleep_thread
	"osf_usleep_thread,"
#endif
#ifdef __NR_setitimer
	"setitimer,"
#endif
#ifdef __NR_timer_create
	"timer_create,"
#endif
#ifdef __NR_timer_delete
	"timer_delete,"
#endif
#ifdef __NR_timer_getoverrun
	"timer_getoverrun,"
#endif
#ifdef __NR_timer_gettime
	"timer_gettime,"
#endif
#ifdef __NR_timer_gettime64
	"timer_gettime64,"
#endif
#ifdef __NR_timer_settime
	"timer_settime,"
#endif
#ifdef __NR_timer_settime64
	"timer_settime64,"
#endif
#ifdef __NR_timerfd_create
	"timerfd_create,"
#endif
#ifdef __NR_timerfd_gettime
	"timerfd_gettime,"
#endif
#ifdef __NR_timerfd_gettime64
	"timerfd_gettime64,"
#endif
#ifdef __NR_timerfd_settime
	"timerfd_settime,"
#endif
#ifdef __NR_timerfd_settime64
	"timerfd_settime64,"
#endif
#ifdef __NR_times
	"times"
#endif
	}
};

// return SYSCALL_ERROR if error, or syscall number
static int syscall_find_name(const char *name) {
	int i;
	int elems = sizeof(syslist) / sizeof(syslist[0]);
	for (i = 0; i < elems; i++) {
		if (strcmp(name, syslist[i].name) == 0)
			return syslist[i].nr;
	}

	return SYSCALL_ERROR;
}

static int syscall_find_name_32(const char *name) {
	int i;
	int elems = sizeof(syslist32) / sizeof(syslist32[0]);
	for (i = 0; i < elems; i++) {
		if (strcmp(name, syslist32[i].name) == 0)
			return syslist32[i].nr;
	}

	return SYSCALL_ERROR;
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

const char *syscall_find_nr_32(int nr) {
	int i;
	int elems = sizeof(syslist32) / sizeof(syslist32[0]);
	for (i = 0; i < elems; i++) {
		if (nr == syslist32[i].nr)
			return syslist32[i].name;
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

void syscall_print_32(void) {
	int i;
	int elems = sizeof(syslist32) / sizeof(syslist32[0]);
	for (i = 0; i < elems; i++) {
		printf("%d\t- %s\n", syslist32[i].nr, syslist32[i].name);
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
static void syscall_process_name(const char *name, int *syscall_nr, int *error_nr, bool native) {
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
	else {
		if (native)
			*syscall_nr = syscall_find_name(syscall_name);
		else
			*syscall_nr = syscall_find_name_32(syscall_name);
	}
	if (error_name) {
		if (strcmp(error_name, "kill") == 0)
			*error_nr = ERRNO_KILL;
		else {
			*error_nr = errno_find_name(error_name);
			if (*error_nr == -1)
				*syscall_nr = SYSCALL_ERROR;
		}
	}

	free(str);
	return;

error:
	fprintf(stderr, "Error fseccomp: invalid syscall list entry %s\n", name);
	exit(1);
}

// return 1 if error, 0 if OK
int syscall_check_list(const char *slist, filter_fn *callback, int fd, int arg, void *ptrarg, bool native) {
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
			syscall_check_list(new_list, callback, fd, arg, ptrarg, native);
		}
		else {
			bool negate = false;
			if (*ptr == '!') {
				negate = true;
				ptr++;
			}
			syscall_process_name(ptr, &syscall_nr, &error_nr, native);
			if (syscall_nr != SYSCALL_ERROR && callback != NULL) {
				if (negate) {
					syscall_nr = -syscall_nr;
				}
				if (error_nr >= 0 && fd > 0)
					filter_add_errno(fd, syscall_nr, error_nr, ptrarg, native);
				else if (error_nr == ERRNO_KILL && fd > 0)
					filter_add_blacklist_override(fd, syscall_nr, 0, ptrarg, native);
				else if (error_nr >= 0 && fd == 0) {
					callback(fd, syscall_nr, error_nr, ptrarg, native);
				}
				else {
					callback(fd, syscall_nr, arg, ptrarg, native);
				}
			}
		}
		ptr = strtok_r(NULL, ",", &saveptr);
	}

	free(str);
	return 0;
}

static void find_syscall(int fd, int syscall, int arg, void *ptrarg, bool native) {
	(void)fd;
	(void) arg;
	(void)native;
	SyscallCheckList *ptr = ptrarg;
	if (abs(syscall) == ptr->syscall)
		ptr->found = true;
}

// go through list2 and find matches for problem syscall
static void syscall_in_list(int fd, int syscall, int arg, void *ptrarg, bool native) {
	(void) fd;
	(void)arg;
	SyscallCheckList *ptr = ptrarg;
	SyscallCheckList sl;
	const char *name;

	sl.found = false;
	sl.syscall = syscall;
	syscall_check_list(ptr->slist, find_syscall, fd, 0, &sl, native);

	if (native)
		name = syscall_find_nr(syscall);
	else
		name = syscall_find_nr_32(syscall);

	// if found in the problem list, add to post-exec list
	if (sl.found) {
		if (ptr->postlist) {
			if (asprintf(&ptr->postlist, "%s,%s", ptr->postlist, name) == -1)
				errExit("asprintf");
		}
		else
			ptr->postlist = strdup(name);
	}
	else { // no problem, add to pre-exec list
		// build syscall:error_no
		char *newcall = NULL;
		if (arg != 0) {
			if (asprintf(&newcall, "%s:%s", name, errno_find_nr(arg)) == -1)
				errExit("asprintf");
		}
		else {
			newcall = strdup(name);
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
void syscalls_in_list(const char *list, const char *slist, int fd, char **prelist, char **postlist, bool native) {
	(void) fd;
	SyscallCheckList sl;
	// these syscalls are used by firejail after the seccomp filter is initialized
	sl.slist = slist;
	sl.prelist = NULL;
	sl.postlist = NULL;
	syscall_check_list(list, syscall_in_list, 0, 0, &sl, native);
	if (!arg_quiet) {
		fprintf(stderr, "Seccomp list in: %s,", list);
		if (sl.slist)
			fprintf(stderr, " check list: %s,", sl.slist);
		if (sl.prelist)
			fprintf(stderr, " prelist: %s,", sl.prelist);
		if (sl.postlist)
			fprintf(stderr, " postlist: %s", sl.postlist);
		fprintf(stderr, "\n");
	}
	*prelist = sl.prelist;
	*postlist = sl.postlist;
}
