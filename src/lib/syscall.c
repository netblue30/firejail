/*
 * Copyright (C) 2014-2026 Firejail Authors
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
    const char * const description;
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
	{ .name = "@aio",
	  .description = "Asynchronous I/O and io_uring operations.",
	  .list =
#ifdef SYS_io_cancel
	  "io_cancel,"
#endif
#ifdef SYS_io_destroy
	  "io_destroy,"
#endif
#ifdef SYS_io_getevents
	  "io_getevents,"
#endif
#ifdef SYS_io_pgetevents
	  "io_pgetevents,"
#endif
#ifdef SYS_io_pgetevents_time64
	  "io_pgetevents_time64,"
#endif
#ifdef SYS_io_setup
	  "io_setup,"
#endif
#ifdef SYS_io_submit
	  "io_submit,"
#endif
#ifdef SYS_io_uring_enter
	  "io_uring_enter,"
#endif
#ifdef SYS_io_uring_register
	  "io_uring_register,"
#endif
#ifdef SYS_io_uring_setup
	  "io_uring_setup"
#endif
	},
	{ .name = "@basic-io",
	  .description = "Basic file-descriptor read, write, seek and dup operations.",
	  .list =
#ifdef SYS__llseek
	  "_llseek,"
#endif
#ifdef SYS_close
	  "close,"
#endif
#ifdef SYS_close_range
	  "close_range,"
#endif
#ifdef SYS_dup
	  "dup,"
#endif
#ifdef SYS_dup2
	  "dup2,"
#endif
#ifdef SYS_dup3
	  "dup3,"
#endif
#ifdef SYS_lseek
	  "lseek,"
#endif
#ifdef SYS_pread64
	  "pread64,"
#endif
#ifdef SYS_preadv
	  "preadv,"
#endif
#ifdef SYS_preadv2
	  "preadv2,"
#endif
#ifdef SYS_pwrite64
	  "pwrite64,"
#endif
#ifdef SYS_pwritev
	  "pwritev,"
#endif
#ifdef SYS_pwritev2
	  "pwritev2,"
#endif
#ifdef SYS_read
	  "read,"
#endif
#ifdef SYS_readv
	  "readv,"
#endif
#ifdef SYS_write
	  "write,"
#endif
#ifdef SYS_writev
	  "writev"
#endif
	},
	{ .name = "@chown",
	  .description = "Change file owner and group metadata.",
	  .list =
#ifdef SYS_chown
	  "chown,"
#endif
#ifdef SYS_chown32
	  "chown32,"
#endif
#ifdef SYS_fchown
	  "fchown,"
#endif
#ifdef SYS_fchown32
	  "fchown32,"
#endif
#ifdef SYS_fchownat
	  "fchownat,"
#endif
#ifdef SYS_lchown
	  "lchown,"
#endif
#ifdef SYS_lchown32
	  "lchown32"
#endif
	},
	{ .name = "@clock",
	  .description = "System clock adjustment.",
	  .list =
#ifdef SYS_adjtimex
	  "adjtimex,"
#endif
#ifdef SYS_clock_adjtime
	  "clock_adjtime,"
#endif
#ifdef SYS_clock_adjtime64
	  "clock_adjtime64,"
#endif
#ifdef SYS_clock_settime
	  "clock_settime,"
#endif
#ifdef SYS_clock_settime64
	  "clock_settime64,"
#endif
#ifdef SYS_old_adjtimex
	  "old_adjtimex"
#endif
	},
	{ .name = "@cpu-emulation",
	  .description = "Legacy CPU, segment and VM86 emulation helpers.",
	  .list =
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
	  "__dummy_syscall__" // workaround for the following architectures which don't have any of above defined and empty syscall lists are not allowed:
						  // arm64, alpha, arc32, armeabi, armoabi, csky, hexagon32, loongarch64, m68k, mips_n32, mips_n64, nios2, openrisc32, parisc32, parisc64, riscv32, riscv64, s390_32, s390_64, sparc32, sparc64, superh and xtensa
#endif
	},
	{ .name = "@debug",
	  .description = "Low-level debugging, tracing, and perf monitoring interfaces.",
	  .list =
#ifdef SYS_lookup_dcookie
	  "lookup_dcookie,"
#endif
#ifdef SYS_perf_event_open
	  "perf_event_open,"
#endif
#ifdef SYS_pidfd_getfd
	  "pidfd_getfd,"
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
#ifdef SYS_uprobe
	  "uprobe,"
#endif
#ifdef SYS_uretprobe
	  "uretprobe" // occasional breakages with seccomp reported, see https://lwn.net/Articles/1005662
#endif
	},
	{ .name = "@default",
	  .description = "Broad set of syscalls usually considered unsafe or rarely used.",
	  .list =
	  "@clock,"
	  "@cpu-emulation,"
	  "@debug,"
	  "@module,"
	  "@mount,"
	  "@obsolete,"
	  "@raw-io,"
	  "@reboot,"
	  "@swap,"
#ifdef SYS_acct
	  "acct,"
#endif
#ifdef SYS_add_key
	  "add_key,"
#endif
#ifdef SYS_bpf
	  "bpf,"
#endif
#ifdef SYS_fanotify_init
	  "fanotify_init,"
#endif
#ifdef SYS_io_cancel
	  "io_cancel,"
#endif
#ifdef SYS_io_destroy
	  "io_destroy,"
#endif
#ifdef SYS_io_getevents
	  "io_getevents,"
#endif
#ifdef SYS_io_setup
	  "io_setup,"
#endif
#ifdef SYS_io_submit
	  "io_submit,"
#endif
#ifdef SYS_ioprio_set
	  "ioprio_set,"
#endif
#ifdef SYS_keyctl
	  "keyctl,"
#endif
#ifdef SYS_mbind
	  "mbind,"
#endif
#ifdef SYS_migrate_pages
	  "migrate_pages,"
#endif
#ifdef SYS_move_pages
	  "move_pages,"
#endif
#ifdef SYS_name_to_handle_at
	  "name_to_handle_at,"
#endif
#ifdef SYS_nfsservctl
	  "nfsservctl,"
#endif
#ifdef SYS_open_by_handle_at
	  "open_by_handle_at,"
#endif
#ifdef SYS_request_key
	  "request_key,"
#endif
#ifdef SYS_set_mempolicy
	  "set_mempolicy,"
#endif
#ifdef SYS_setdomainname
	  "setdomainname,"
#endif
#ifdef SYS_sethostname
	  "sethostname,"
#endif
#ifdef SYS_syslog
	  "syslog,"
#endif
#ifdef SYS_userfaultfd
	  "userfaultfd,"
#endif
#ifdef SYS_vhangup
	  "vhangup,"
#endif
#ifdef SYS_vmsplice
	  "vmsplice"
#endif
	},
	{ .name = "@default-keep",
	  .description = "Minimal core exec and other syscalls usually kept even under strict filters.",
	  .list =
#ifdef SYS_arch_prctl
	  "arch_prctl," // breaks glibc, i386 and x86_64 only
#endif
	  "clock_getres," // clock_getres*, stop programs that try to read theoretical resolution
#ifdef SYS_clock_getres_time64
	  "clock_getres_time64,"
#endif
	  "clock_gettime," // clock_gettime* and time, stop programs that try to read time
#ifdef SYS_clock_gettime64
	  "clock_gettime64,"
#endif
	  "clock_nanosleep," // clock_nanosleep*, stop programs that try to use sleep functions
#ifdef SYS_clock_nanosleep_time64
	  "clock_nanosleep_time64,"
#endif
#ifdef SYS_gettimeofday
	  "gettimeofday,"
#endif
#ifdef SYS_execv
	  "execv," // sparc only
#endif
	  "execve,"
	  "execveat," // commonly used by fexecve
	  "exit," // breaks most Qt applications
	  "futex," // frequently used and causes breakages
#ifdef SYS_mmap
	  "mmap," // cannot load shared libraries
#endif
#ifdef SYS_mmap2
	  "mmap2,"
#endif
	  "mprotect," // cannot load shared libraries
	  "prctl,"
#ifdef SYS_time
	  "time"
#endif
	},
	{ .name = "@default-nodebuggers",
	  .description = "Debugger and introspection syscalls, also includes the @default group.",
	  .list =
	  "@default,"
#ifdef SYS_personality
	  "personality,"
#endif
#ifdef SYS_process_vm_readv
	  "process_vm_readv,"
#endif
#ifdef SYS_ptrace
	  "ptrace"
#endif
	},
	{ .name = "@file-system",
	  .description = "Filesystem access: path navigation, metadata, open, create, remove, and inotify.",
	  .list =
#ifdef SYS_access
	  "access,"
#endif
#ifdef SYS_cachestat
	  "cachestat,"
#endif
#ifdef SYS_chdir
	  "chdir,"
#endif
#ifdef SYS_chmod
	  "chmod,"
#endif
#ifdef SYS_close
	  "close,"
#endif
#ifdef SYS_close_range
	  "close_range,"
#endif
#ifdef SYS_creat
	  "creat,"
#endif
#ifdef SYS_faccessat
	  "faccessat,"
#endif
#ifdef SYS_faccessat2
	  "faccessat2,"
#endif
#ifdef SYS_fallocate
	  "fallocate,"
#endif
#ifdef SYS_fanotify_mark
	  "fanotify_mark,"
#endif
#ifdef SYS_fchdir
	  "fchdir,"
#endif
#ifdef SYS_fchmod
	  "fchmod,"
#endif
#ifdef SYS_fchmodat
	  "fchmodat,"
#endif
#ifdef SYS_fchmodat2
	  "fchmodat2,"
#endif
#ifdef SYS_fcntl
	  "fcntl,"
#endif
#ifdef SYS_fcntl64
	  "fcntl64,"
#endif
#ifdef SYS_fgetxattr
	  "fgetxattr,"
#endif
#ifdef SYS_file_getattr
	  "file_getattr,"
#endif
#ifdef SYS_file_setattr
	  "file_setattr,"
#endif
#ifdef SYS_flistxattr
	  "flistxattr,"
#endif
#ifdef SYS_fremovexattr
	  "fremovexattr,"
#endif
#ifdef SYS_fsetxattr
	  "fsetxattr,"
#endif
#ifdef SYS_fstat
	  "fstat,"
#endif
#ifdef SYS_fstat64
	  "fstat64,"
#endif
#ifdef SYS_fstatat64
	  "fstatat64,"
#endif
#ifdef SYS_fstatfs
	  "fstatfs,"
#endif
#ifdef SYS_fstatfs64
	  "fstatfs64,"
#endif
#ifdef SYS_ftruncate
	  "ftruncate,"
#endif
#ifdef SYS_ftruncate64
	  "ftruncate64,"
#endif
#ifdef SYS_getcwd
	  "getcwd,"
#endif
#ifdef SYS_getdents
	  "getdents,"
#endif
#ifdef SYS_getdents64
	  "getdents64,"
#endif
#ifdef SYS_getxattr
	  "getxattr,"
#endif
#ifdef SYS_getxattrat
	  "getxattrat,"
#endif
#ifdef SYS_inotify_add_watch
	  "inotify_add_watch,"
#endif
#ifdef SYS_inotify_init
	  "inotify_init,"
#endif
#ifdef SYS_inotify_init1
	  "inotify_init1,"
#endif
#ifdef SYS_inotify_rm_watch
	  "inotify_rm_watch,"
#endif
#ifdef SYS_lgetxattr
	  "lgetxattr,"
#endif
#ifdef SYS_link
	  "link,"
#endif
#ifdef SYS_linkat
	  "linkat,"
#endif
#ifdef SYS_listxattr
	  "listxattr,"
#endif
#ifdef SYS_listxattrat
	  "listxattrat,"
#endif
#ifdef SYS_llistxattr
	  "llistxattr,"
#endif
#ifdef SYS_lremovexattr
	  "lremovexattr,"
#endif
#ifdef SYS_lsetxattr
	  "lsetxattr,"
#endif
#ifdef SYS_lstat
	  "lstat,"
#endif
#ifdef SYS_lstat64
	  "lstat64,"
#endif
#ifdef SYS_mkdir
	  "mkdir,"
#endif
#ifdef SYS_mkdirat
	  "mkdirat,"
#endif
#ifdef SYS_mknod
	  "mknod,"
#endif
#ifdef SYS_mknodat
	  "mknodat,"
#endif
#ifdef SYS_munmap
	  "munmap,"
#endif
#ifdef SYS_newfstatat
	  "newfstatat,"
#endif
#ifdef SYS_oldfstat
	  "oldfstat,"
#endif
#ifdef SYS_oldlstat
	  "oldlstat,"
#endif
#ifdef SYS_oldstat
	  "oldstat,"
#endif
#ifdef SYS_open
	  "open,"
#endif
#ifdef SYS_openat
	  "openat,"
#endif
#ifdef SYS_openat2
	  "openat2,"
#endif
#ifdef SYS_osf_fstat
	  "osf_fstat,"
#endif
#ifdef SYS_osf_fstatfs
	  "osf_fstatfs,"
#endif
#ifdef SYS_osf_fstatfs64
	  "osf_fstatfs64,"
#endif
#ifdef SYS_osf_getdirentries
	  "osf_getdirentries,"
#endif
#ifdef SYS_osf_lstat
	  "osf_lstat,"
#endif
#ifdef SYS_osf_proplist_syscall
	  "osf_proplist_syscall,"
#endif
#ifdef SYS_osf_utimes
	  "osf_utimes,"
#endif
#ifdef SYS_quotactl_fd
	  "quotactl_fd,"
#endif
#ifdef SYS_readlink
	  "readlink,"
#endif
#ifdef SYS_readlinkat
	  "readlinkat,"
#endif
#ifdef SYS_removexattr
	  "removexattr,"
#endif
#ifdef SYS_removexattrat
	  "removexattrat,"
#endif
#ifdef SYS_rename
	  "rename,"
#endif
#ifdef SYS_renameat
	  "renameat,"
#endif
#ifdef SYS_renameat2
	  "renameat2,"
#endif
#ifdef SYS_rmdir
	  "rmdir,"
#endif
#ifdef SYS_setxattr
	  "setxattr,"
#endif
#ifdef SYS_setxattrat
	  "setxattrat,"
#endif
#ifdef SYS_stat
	  "stat,"
#endif
#ifdef SYS_stat64
	  "stat64,"
#endif
#ifdef SYS_statfs
	  "statfs,"
#endif
#ifdef SYS_statfs64
	  "statfs64,"
#endif
#ifdef SYS_statx
	  "statx,"
#endif
#ifdef SYS_symlink
	  "symlink,"
#endif
#ifdef SYS_symlinkat
	  "symlinkat,"
#endif
#ifdef SYS_truncate
	  "truncate,"
#endif
#ifdef SYS_truncate64
	  "truncate64,"
#endif
#ifdef SYS_unlink
	  "unlink,"
#endif
#ifdef SYS_unlinkat
	  "unlinkat,"
#endif
#ifdef SYS_utimensat
	  "utimensat,"
#endif
#ifdef SYS_utimes
	  "utimes"
#endif
	},
	{ .name = "@io-event",
	  .description = "Evented I/O multiplexing.",
	  .list =
#ifdef SYS__newselect
	  "_newselect,"
#endif
#ifdef SYS_epoll_create
	  "epoll_create,"
#endif
#ifdef SYS_epoll_create1
	  "epoll_create1,"
#endif
#ifdef SYS_epoll_ctl
	  "epoll_ctl,"
#endif
#ifdef SYS_epoll_pwait
	  "epoll_pwait,"
#endif
#ifdef SYS_epoll_pwait2
	  "epoll_pwait2,"
#endif
#ifdef SYS_epoll_wait
	  "epoll_wait,"
#endif
#ifdef SYS_eventfd
	  "eventfd,"
#endif
#ifdef SYS_eventfd2
	  "eventfd2,"
#endif
#ifdef SYS_osf_select
	  "osf_select,"
#endif
#ifdef SYS_poll
	  "poll,"
#endif
#ifdef SYS_ppoll
	  "ppoll,"
#endif
#ifdef SYS_ppoll_time64
	  "ppoll_time64,"
#endif
#ifdef SYS_pselect6
	  "pselect6,"
#endif
#ifdef SYS_pselect6_time64
	  "pselect6_time64,"
#endif
#ifdef SYS_select
	  "select"
#endif
	},
	{ .name = "@ipc",
	  .description = "Inter-process communication: pipes, SysV IPC and POSIX message queues.",
	  .list =
#ifdef SYS_ipc
	  "ipc,"
#endif
#ifdef SYS_mq_getsetattr
	  "mq_getsetattr,"
#endif
#ifdef SYS_mq_notify
	  "mq_notify,"
#endif
#ifdef SYS_mq_open
	  "mq_open,"
#endif
#ifdef SYS_mq_timedreceive
	  "mq_timedreceive,"
#endif
#ifdef SYS_mq_timedreceive_time64
	  "mq_timedreceive_time64,"
#endif
#ifdef SYS_mq_timedsend
	  "mq_timedsend,"
#endif
#ifdef SYS_mq_timedsend_time64
	  "mq_timedsend_time64,"
#endif
#ifdef SYS_mq_unlink
	  "mq_unlink,"
#endif
#ifdef SYS_msgctl
	  "msgctl,"
#endif
#ifdef SYS_msgget
	  "msgget,"
#endif
#ifdef SYS_msgrcv
	  "msgrcv,"
#endif
#ifdef SYS_msgsnd
	  "msgsnd,"
#endif
#ifdef SYS_pipe
	  "pipe,"
#endif
#ifdef SYS_pipe2
	  "pipe2,"
#endif
#ifdef SYS_process_madvise
	  "process_madvise,"
#endif
#ifdef SYS_process_mrelease
	  "process_mrelease,"
#endif
#ifdef SYS_process_vm_readv
	  "process_vm_readv,"
#endif
#ifdef SYS_process_vm_writev
	  "process_vm_writev,"
#endif
#ifdef SYS_semctl
	  "semctl,"
#endif
#ifdef SYS_semget
	  "semget,"
#endif
#ifdef SYS_semop
	  "semop,"
#endif
#ifdef SYS_semtimedop
	  "semtimedop,"
#endif
#ifdef SYS_semtimedop_time64
	  "semtimedop_time64,"
#endif
#ifdef SYS_shmat
	  "shmat,"
#endif
#ifdef SYS_shmctl
	  "shmctl,"
#endif
#ifdef SYS_shmdt
	  "shmdt,"
#endif
#ifdef SYS_shmget
	  "shmget"
#endif
	},
	{ .name = "@keyring",
	  .description = "Kernel keyring and key management operations.",
	  .list =
#ifdef SYS_add_key
	  "add_key,"
#endif
#ifdef SYS_keyctl
	  "keyctl,"
#endif
#ifdef SYS_request_key
	  "request_key"
#endif
	},
	{ .name = "@memfd",
	  .description = "Anonymous in-kernel file-like memory objects.",
	  .list =
#ifdef SYS_memfd_create
	  "memfd_create,"
#endif
#ifdef SYS_memfd_secret
	  "memfd_secret"
#endif
	},
	{ .name = "@memlock",
	  .description = "Lock and unlock memory to and from RAM (no swapping).",
	  .list =
#ifdef SYS_mlock
	  "mlock,"
#endif
#ifdef SYS_mlock2
	  "mlock2,"
#endif
#ifdef SYS_mlockall
	  "mlockall,"
#endif
#ifdef SYS_munlock
	  "munlock,"
#endif
#ifdef SYS_munlockall
	  "munlockall"
#endif
	},
	{ .name = "@module",
	  .description = "Load, initialize, and unload kernel modules.",
	  .list =
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
	{ .name = "@mount",
	  .description = "Mount, unmount, manage filesystems and mount namespaces.",
	  .list =
#ifdef SYS_chroot
	  "chroot,"
#endif
#ifdef SYS_fsconfig
	  "fsconfig,"
#endif
#ifdef SYS_fsmount
	  "fsmount,"
#endif
#ifdef SYS_fsopen
	  "fsopen,"
#endif
#ifdef SYS_fspick
	  "fspick,"
#endif
#ifdef SYS_listmount
	  "listmount,"
#endif
#ifdef SYS_mount
	  "mount,"
#endif
#ifdef SYS_mount_setattr
	  "mount_setattr,"
#endif
#ifdef SYS_move_mount
	  "move_mount,"
#endif
#ifdef SYS_oldumount
	  "oldumount,"
#endif
#ifdef SYS_open_tree
	  "open_tree,"
#endif
#ifdef SYS_open_tree_attr
	  "open_tree_attr,"
#endif
#ifdef SYS_osf_mount
	  "osf_mount,"
#endif
#ifdef SYS_pivot_root
	  "pivot_root,"
#endif
#ifdef SYS_statmount
	  "statmount,"
#endif
#ifdef SYS_umount
	  "umount,"
#endif
#ifdef SYS_umount2
	  "umount2"
#endif
	},
	{ .name = "@network-io",
	  .description = "Create and use sockets, send and receive network data.",
	  .list =
#ifdef SYS_accept
	  "accept,"
#endif
#ifdef SYS_accept4
	  "accept4,"
#endif
#ifdef SYS_bind
	  "bind,"
#endif
#ifdef SYS_connect
	  "connect,"
#endif
#ifdef SYS_getpeername
	  "getpeername,"
#endif
#ifdef SYS_getsockname
	  "getsockname,"
#endif
#ifdef SYS_getsockopt
	  "getsockopt,"
#endif
#ifdef SYS_listen
	  "listen,"
#endif
#ifdef SYS_recv
	  "recv,"
#endif
#ifdef SYS_recvfrom
	  "recvfrom,"
#endif
#ifdef SYS_recvmmsg
	  "recvmmsg,"
#endif
#ifdef SYS_recvmmsg_time64
	  "recvmmsg_time64,"
#endif
#ifdef SYS_recvmsg
	  "recvmsg,"
#endif
#ifdef SYS_send
	  "send,"
#endif
#ifdef SYS_sendmmsg
	  "sendmmsg,"
#endif
#ifdef SYS_sendmsg
	  "sendmsg,"
#endif
#ifdef SYS_sendto
	  "sendto,"
#endif
#ifdef SYS_setsockopt
	  "setsockopt,"
#endif
#ifdef SYS_shutdown
	  "shutdown,"
#endif
#ifdef SYS_socket
	  "socket,"
#endif
#ifdef SYS_socketcall
	  "socketcall,"
#endif
#ifdef SYS_socketpair
	  "socketpair"
#endif
	},
	{ .name = "@obsolete",
	  .description = "Deprecated or very old arch-specific legacy syscalls.",
	  .list =
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
#ifdef SYS_dipc
	  "dipc,"
#endif
#ifdef SYS_epoll_ctl_old
	  "epoll_ctl_old,"
#endif
#ifdef SYS_epoll_wait_old
	  "epoll_wait_old,"
#endif
#ifdef SYS_exec_with_loader
	  "exec_with_loader,"
#endif
#ifdef SYS_ftime
	  "ftime,"
#endif
#ifdef SYS_futimesat
	  "futimesat,"
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
#ifdef SYS_idle
	  "idle,"
#endif
#ifdef SYS_llseek
	  "llseek,"
#endif
#ifdef SYS_lock
	  "lock,"
#endif
#ifdef SYS_mpx
	  "mpx,"
#endif
#ifdef SYS_multiplexer
	  "multiplexer,"
#endif
#ifdef SYS_osf_adjtime
	  "osf_adjtime,"
#endif
#ifdef SYS_osf_afs_syscall
	  "osf_afs_syscall,"
#endif
#ifdef SYS_osf_alt_plock
	  "osf_alt_plock,"
#endif
#ifdef SYS_osf_alt_setsid
	  "osf_alt_setsid,"
#endif
#ifdef SYS_osf_alt_sigpending
	  "osf_alt_sigpending,"
#endif
#ifdef SYS_osf_asynch_daemon
	  "osf_asynch_daemon,"
#endif
#ifdef SYS_osf_audcntl
	  "osf_audcntl,"
#endif
#ifdef SYS_osf_audgen
	  "osf_audgen,"
#endif
#ifdef SYS_osf_chflags
	  "osf_chflags,"
#endif
#ifdef SYS_osf_execve
	  "osf_execve,"
#endif
#ifdef SYS_osf_exportfs
	  "osf_exportfs,"
#endif
#ifdef SYS_osf_fchflags
	  "osf_fchflags,"
#endif
#ifdef SYS_osf_fdatasync
	  "osf_fdatasync,"
#endif
#ifdef SYS_osf_fpathconf
	  "osf_fpathconf,"
#endif
#ifdef SYS_osf_fuser
	  "osf_fuser,"
#endif
#ifdef SYS_osf_getaddressconf
	  "osf_getaddressconf,"
#endif
#ifdef SYS_osf_getfh
	  "osf_getfh,"
#endif
#ifdef SYS_osf_getfsstat
	  "osf_getfsstat,"
#endif
#ifdef SYS_osf_gethostid
	  "osf_gethostid,"
#endif
#ifdef SYS_osf_getlogin
	  "osf_getlogin,"
#endif
#ifdef SYS_osf_getmnt
	  "osf_getmnt,"
#endif
#ifdef SYS_osf_gettimeofday
	  "osf_gettimeofday,"
#endif
#ifdef SYS_osf_kloadcall
	  "osf_kloadcall,"
#endif
#ifdef SYS_osf_kmodcall
	  "osf_kmodcall,"
#endif
#ifdef SYS_osf_memcntl
	  "osf_memcntl,"
#endif
#ifdef SYS_osf_mincore
	  "osf_mincore,"
#endif
#ifdef SYS_osf_mremap
	  "osf_mremap,"
#endif
#ifdef SYS_osf_msfs_syscall
	  "osf_msfs_syscall,"
#endif
#ifdef SYS_osf_msleep
	  "osf_msleep,"
#endif
#ifdef SYS_osf_mvalid
	  "osf_mvalid,"
#endif
#ifdef SYS_osf_mwakeup
	  "osf_mwakeup,"
#endif
#ifdef SYS_osf_naccept
	  "osf_naccept,"
#endif
#ifdef SYS_osf_nfssvc
	  "osf_nfssvc,"
#endif
#ifdef SYS_osf_ngetpeername
	  "osf_ngetpeername,"
#endif
#ifdef SYS_osf_ngetsockname
	  "osf_ngetsockname,"
#endif
#ifdef SYS_osf_nrecvfrom
	  "osf_nrecvfrom,"
#endif
#ifdef SYS_osf_nrecvmsg
	  "osf_nrecvmsg,"
#endif
#ifdef SYS_osf_nsendmsg
	  "osf_nsendmsg,"
#endif
#ifdef SYS_osf_ntp_adjtime
	  "osf_ntp_adjtime,"
#endif
#ifdef SYS_osf_ntp_gettime
	  "osf_ntp_gettime,"
#endif
#ifdef SYS_osf_old_creat
	  "osf_old_creat,"
#endif
#ifdef SYS_osf_old_fstat
	  "osf_old_fstat,"
#endif
#ifdef SYS_osf_old_getpgrp
	  "osf_old_getpgrp,"
#endif
#ifdef SYS_osf_old_killpg
	  "osf_old_killpg,"
#endif
#ifdef SYS_osf_old_lstat
	  "osf_old_lstat,"
#endif
#ifdef SYS_osf_old_open
	  "osf_old_open,"
#endif
#ifdef SYS_osf_old_sigaction
	  "osf_old_sigaction,"
#endif
#ifdef SYS_osf_old_sigblock
	  "osf_old_sigblock,"
#endif
#ifdef SYS_osf_old_sigreturn
	  "osf_old_sigreturn,"
#endif
#ifdef SYS_osf_old_sigsetmask
	  "osf_old_sigsetmask,"
#endif
#ifdef SYS_osf_old_sigvec
	  "osf_old_sigvec,"
#endif
#ifdef SYS_osf_old_stat
	  "osf_old_stat,"
#endif
#ifdef SYS_osf_old_vadvise
	  "osf_old_vadvise,"
#endif
#ifdef SYS_osf_old_vtrace
	  "osf_old_vtrace,"
#endif
#ifdef SYS_osf_old_wait
	  "osf_old_wait,"
#endif
#ifdef SYS_osf_oldquota
	  "osf_oldquota,"
#endif
#ifdef SYS_osf_pathconf
	  "osf_pathconf,"
#endif
#ifdef SYS_osf_pid_block
	  "osf_pid_block,"
#endif
#ifdef SYS_osf_pid_unblock
	  "osf_pid_unblock,"
#endif
#ifdef SYS_osf_plock
	  "osf_plock,"
#endif
#ifdef SYS_osf_priocntlset
	  "osf_priocntlset,"
#endif
#ifdef SYS_osf_profil
	  "osf_profil,"
#endif
#ifdef SYS_osf_reboot
	  "osf_reboot,"
#endif
#ifdef SYS_osf_revoke
	  "osf_revoke,"
#endif
#ifdef SYS_osf_sbrk
	  "osf_sbrk,"
#endif
#ifdef SYS_osf_security
	  "osf_security,"
#endif
#ifdef SYS_osf_set_speculative
	  "osf_set_speculative,"
#endif
#ifdef SYS_osf_sethostid
	  "osf_sethostid,"
#endif
#ifdef SYS_osf_setlogin
	  "osf_setlogin,"
#endif
#ifdef SYS_osf_settimeofday
	  "osf_settimeofday,"
#endif
#ifdef SYS_osf_signal
	  "osf_signal,"
#endif
#ifdef SYS_osf_sigsendset
	  "osf_sigsendset,"
#endif
#ifdef SYS_osf_sigwaitprim
	  "osf_sigwaitprim,"
#endif
#ifdef SYS_osf_sstk
	  "osf_sstk,"
#endif
#ifdef SYS_osf_stat
	  "osf_stat,"
#endif
#ifdef SYS_osf_statfs
	  "osf_statfs,"
#endif
#ifdef SYS_osf_statfs64
	  "osf_statfs64,"
#endif
#ifdef SYS_osf_subsys_info
	  "osf_subsys_info,"
#endif
#ifdef SYS_osf_swapctl
	  "osf_swapctl,"
#endif
#ifdef SYS_osf_table
	  "osf_table,"
#endif
#ifdef SYS_osf_uadmin
	  "osf_uadmin,"
#endif
#ifdef SYS_osf_uswitch
	  "osf_uswitch,"
#endif
#ifdef SYS_osf_utc_adjtime
	  "osf_utc_adjtime,"
#endif
#ifdef SYS_osf_utc_gettime
	  "osf_utc_gettime,"
#endif
#ifdef SYS_osf_waitid
	  "osf_waitid,"
#endif
#ifdef SYS_perfctr
	  "perfctr,"
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
#ifdef SYS_remap_file_pages
	  "remap_file_pages,"
#endif
#ifdef SYS_security
	  "security,"
#endif
#ifdef SYS_settimeofday
	  "settimeofday,"
#endif
#ifdef SYS_sgetmask
	  "sgetmask,"
#endif
#ifdef SYS_spill
	  "spill,"
#endif
#ifdef SYS_ssetmask
	  "ssetmask,"
#endif
#ifdef SYS_stime
	  "stime,"
#endif
#ifdef SYS_stty
	  "stty,"
#endif
#ifdef SYS_sysfs
	  "sysfs,"
#endif
#ifdef SYS_timerfd
	  "timerfd,"
#endif
#ifdef SYS_tkill
	  "tkill,"
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
#ifdef SYS_utime
	  "utime,"
#endif
#ifdef SYS_vserver
	  "vserver,"
#endif
#ifdef SYS_xtensa
	  "xtensa"
#endif
#if defined(__aarch64__) || defined(__loongarch64) || __loongarch_grlen == 64 || (defined(__riscv) && __riscv_xlen == 64)
	  "__dummy_syscall__" // workaround for arm64, loongarch64 and riscv64 which don't have any of above defined and empty syscall lists are not allowed
#endif
	},
	{ .name = "@privileged",
	  .description = "Highly privileged operations: IDs, mounts, modules, raw I/O, reboot, etc.",
	  .list =
	  "@chown,"
	  "@clock,"
	  "@module,"
	  "@raw-io,"
	  "@reboot,"
	  "@swap,"
#ifdef SYS__sysctl
	  "_sysctl,"
#endif
#ifdef SYS_acct
	  "acct,"
#endif
#ifdef SYS_bpf
	  "bpf,"
#endif
#ifdef SYS_capset
	  "capset,"
#endif
#ifdef SYS_chroot
	  "chroot,"
#endif
#ifdef SYS_fanotify_init
	  "fanotify_init,"
#endif
#ifdef SYS_mount
	  "mount,"
#endif
#ifdef SYS_nfsservctl
	  "nfsservctl,"
#endif
#ifdef SYS_open_by_handle_at
	  "open_by_handle_at,"
#endif
#ifdef SYS_pivot_root
	  "pivot_root,"
#endif
#ifdef SYS_quotactl
	  "quotactl,"
#endif
#ifdef SYS_setdomainname
	  "setdomainname,"
#endif
#ifdef SYS_setfsuid
	  "setfsuid,"
#endif
#ifdef SYS_setfsuid32
	  "setfsuid32,"
#endif
#ifdef SYS_setgroups
	  "setgroups,"
#endif
#ifdef SYS_setgroups32
	  "setgroups32,"
#endif
#ifdef SYS_sethostname
	  "sethostname,"
#endif
#ifdef SYS_setresuid
	  "setresuid,"
#endif
#ifdef SYS_setresuid32
	  "setresuid32,"
#endif
#ifdef SYS_setreuid
	  "setreuid,"
#endif
#ifdef SYS_setreuid32
	  "setreuid32,"
#endif
#ifdef SYS_setuid
	  "setuid,"
#endif
#ifdef SYS_setuid32
	  "setuid32,"
#endif
#ifdef SYS_umount2
	  "umount2,"
#endif
#ifdef SYS_vhangup
	  "vhangup"
#endif
	},
	{ .name = "@process",
	  .description = "Process and thread lifecycle, IDs, signals sending, namespaces and futex-related helpers.",
	  .list =
#ifdef SYS_arc_gettls
	  "arc_gettls,"
#endif
#ifdef SYS_arc_settls
	  "arc_settls,"
#endif
#ifdef SYS_arc_usr_cmpxchg
	  "arc_usr_cmpxchg,"
#endif
#ifdef SYS_atomic_barrier
	  "atomic_barrier,"
#endif
#ifdef SYS_atomic_cmpxchg_32
	  "atomic_cmpxchg_32,"
#endif
#ifdef SYS_cachectl
	  "cachectl,"
#endif
#ifdef SYS_cacheflush
	  "cacheflush,"
#endif
#ifdef SYS_capget
	  "capget,"
#endif
#ifdef SYS_clone
	  "clone,"
#endif
#ifdef SYS_clone3
	  "clone3,"
#endif
#ifdef SYS_exit_group
	  "exit_group,"
#endif
#ifdef SYS_fork
	  "fork,"
#endif
#ifdef SYS_futex_requeue
	  "futex_requeue,"
#endif
#ifdef SYS_futex_time64
	  "futex_time64,"
#endif
#ifdef SYS_futex_wait
	  "futex_wait,"
#endif
#ifdef SYS_futex_waitv
	  "futex_waitv,"
#endif
#ifdef SYS_futex_wake
	  "futex_wake,"
#endif
#ifdef SYS_get_robust_list
	  "get_robust_list,"
#endif
#ifdef SYS_get_thread_area
	  "get_thread_area,"
#endif
#ifdef SYS_getegid
	  "getegid,"
#endif
#ifdef SYS_getegid32
	  "getegid32,"
#endif
#ifdef SYS_geteuid
	  "geteuid,"
#endif
#ifdef SYS_geteuid32
	  "geteuid32,"
#endif
#ifdef SYS_getgid
	  "getgid,"
#endif
#ifdef SYS_getgid32
	  "getgid32,"
#endif
#ifdef SYS_getgroups
	  "getgroups,"
#endif
#ifdef SYS_getgroups32
	  "getgroups32,"
#endif
#ifdef SYS_getpgid
	  "getpgid,"
#endif
#ifdef SYS_getpgrp
	  "getpgrp,"
#endif
#ifdef SYS_getpid
	  "getpid,"
#endif
#ifdef SYS_getppid
	  "getppid,"
#endif
#ifdef SYS_getresgid
	  "getresgid,"
#endif
#ifdef SYS_getresgid32
	  "getresgid32,"
#endif
#ifdef SYS_getresuid
	  "getresuid,"
#endif
#ifdef SYS_getresuid32
	  "getresuid32,"
#endif
#ifdef SYS_getsid
	  "getsid,"
#endif
#ifdef SYS_gettid
	  "gettid,"
#endif
#ifdef SYS_getuid
	  "getuid,"
#endif
#ifdef SYS_getuid32
	  "getuid32,"
#endif
#ifdef SYS_getxgid
	  "getxgid,"
#endif
#ifdef SYS_getxpid
	  "getxpid,"
#endif
#ifdef SYS_getxuid
	  "getxuid,"
#endif
#ifdef SYS_kill
	  "kill,"
#endif
#ifdef SYS_membarrier
	  "membarrier,"
#endif
#ifdef SYS_or1k_atomic
	  "or1k_atomic,"
#endif
#ifdef SYS_osf_set_program_attributes
	  "osf_set_program_attributes,"
#endif
#ifdef SYS_osf_wait4
	  "osf_wait4,"
#endif
#ifdef SYS_pidfd_open
	  "pidfd_open,"
#endif
#ifdef SYS_pidfd_send_signal
	  "pidfd_send_signal,"
#endif
#ifdef SYS_riscv_flush_icache
	  "riscv_flush_icache,"
#endif
#ifdef SYS_rseq
	  "rseq,"
#endif
#ifdef SYS_rt_sigqueueinfo
	  "rt_sigqueueinfo,"
#endif
#ifdef SYS_rt_tgsigqueueinfo
	  "rt_tgsigqueueinfo,"
#endif
#ifdef SYS_s390_guarded_storage
	  "s390_guarded_storage,"
#endif
#ifdef SYS_sched_get_affinity
	  "sched_get_affinity,"
#endif
#ifdef SYS_set_robust_list
	  "set_robust_list,"
#endif
#ifdef SYS_set_thread_area
	  "set_thread_area,"
#endif
#ifdef SYS_set_tid_address
	  "set_tid_address,"
#endif
#ifdef SYS_sethae
	  "sethae,"
#endif
#ifdef SYS_setns
	  "setns,"
#endif
#ifdef SYS_setpgrp
	  "setpgrp,"
#endif
#ifdef SYS_setpriority
	  "setpriority,"
#endif
#ifdef SYS_spu_create
	  "spu_create,"
#endif
#ifdef SYS_spu_run
	  "spu_run,"
#endif
#ifdef SYS_swapcontext
	  "swapcontext,"
#endif
#ifdef SYS_tgkill
	  "tgkill,"
#endif
#ifdef SYS_times
	  "times,"
#endif
#ifdef SYS_unshare
	  "unshare,"
#endif
#ifdef SYS_utimensat_time64
	  "utimensat_time64,"
#endif
#ifdef SYS_vfork
	  "vfork,"
#endif
#ifdef SYS_wait4
	  "wait4,"
#endif
#ifdef SYS_waitid
	  "waitid,"
#endif
#ifdef SYS_waitpid
	  "waitpid"
#endif
	},
	{ .name = "@raw-io",
	  .description = "Direct port/PCI and low-level device I/O.",
	  .list =
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
#ifdef SYS_s390_pci_mmio_read
	  "s390_pci_mmio_read,"
#endif
#ifdef SYS_s390_pci_mmio_write
	  "s390_pci_mmio_write"
#endif
#if !defined(SYS_ioperm) && !defined(SYS_iopl) && !defined(SYS_pciconfig_iobase) && !defined(SYS_pciconfig_read) && !defined(SYS_pciconfig_write) && !defined(SYS_s390_pci_mmio_read) && !defined(SYS_s390_pci_mmio_write)
	  "__dummy_syscall__" // workaround for the following architectures which don't have any of above defined and empty syscall lists are not allowed:
						  // arm64, arc32, hexagon32, loongarch64, m68k, mips_n32, mips_n64, nios2, openrisc32, parisc32, parisc64, riscv32, riscv64, superh and xtensa
#endif
	},
	{ .name = "@reboot",
	  .description = "Reboot and kexec-related operations.",
	  .list =
#ifdef SYS_kexec_file_load
	  "kexec_file_load,"
#endif
#ifdef SYS_kexec_load
	  "kexec_load,"
#endif
#ifdef SYS_reboot
	  "reboot"
#endif
	},
	{ .name = "@resources",
	  .description = "Resource limits, priorities, CPU affinity and NUMA memory policies.",
	  .list =
#ifdef SYS_getdtablesize
	  "getdtablesize,"
#endif
#ifdef SYS_getrlimit
	  "getrlimit,"
#endif
#ifdef SYS_getrusage
	  "getrusage,"
#endif
#ifdef SYS_ioprio_set
	  "ioprio_set,"
#endif
#ifdef SYS_mbind
	  "mbind,"
#endif
#ifdef SYS_migrate_pages
	  "migrate_pages,"
#endif
#ifdef SYS_mincore
	  "mincore,"
#endif
#ifdef SYS_move_pages
	  "move_pages,"
#endif
#ifdef SYS_nice
	  "nice,"
#endif
#ifdef SYS_osf_getrusage
	  "osf_getrusage,"
#endif
#ifdef SYS_prlimit64
	  "prlimit64,"
#endif
#ifdef SYS_sched_set_affinity
	  "sched_set_affinity,"
#endif
#ifdef SYS_sched_setaffinity
	  "sched_setaffinity,"
#endif
#ifdef SYS_sched_setattr
	  "sched_setattr,"
#endif
#ifdef SYS_sched_setparam
	  "sched_setparam,"
#endif
#ifdef SYS_sched_setscheduler
	  "sched_setscheduler,"
#endif
#ifdef SYS_set_mempolicy
	  "set_mempolicy,"
#endif
#ifdef SYS_set_mempolicy_home_node
	  "set_mempolicy_home_node,"
#endif
#ifdef SYS_setrlimit
	  "setrlimit,"
#endif
#ifdef SYS_set_ugetrlimit
	  "ugetrlimit"
#endif
	},
	{ .name = "@sandbox",
	  .description = "Seccomp and Landlock sandbox configuration syscalls.",
	  .list =
#ifdef SYS_landlock_add_rule
	  "landlock_add_rule,"
#endif
#ifdef SYS_landlock_create_ruleset
	  "landlock_create_ruleset,"
#endif
#ifdef SYS_landlock_restrict_self
	  "landlock_restrict_self,"
#endif
#ifdef SYS_seccomp
	  "seccomp"
#endif
	},
	{ .name = "@setuid",
	  .description = "Change user and group IDs.",
	  .list =
#ifdef SYS_setgid
	  "setgid,"
#endif
#ifdef SYS_setgid32
	  "setgid32,"
#endif
#ifdef SYS_setgroups
	  "setgroups,"
#endif
#ifdef SYS_setgroups32
	  "setgroups32,"
#endif
#ifdef SYS_setregid
	  "setregid,"
#endif
#ifdef SYS_setregid32
	  "setregid32,"
#endif
#ifdef SYS_setresgid
	  "setresgid,"
#endif
#ifdef SYS_setresgid32
	  "setresgid32,"
#endif
#ifdef SYS_setresuid
	  "setresuid,"
#endif
#ifdef SYS_setresuid32
	  "setresuid32,"
#endif
#ifdef SYS_setreuid
	  "setreuid,"
#endif
#ifdef SYS_setreuid32
	  "setreuid32,"
#endif
#ifdef SYS_setuid
	  "setuid,"
#endif
#ifdef SYS_setuid32
	  "setuid32"
#endif
	},
	{ .name = "@signal",
	  .description = "Signal handling, masks, signal delivery and signalfd-based interfaces.",
	  .list =
#ifdef SYS_osf_sigprocmask
	  "osf_sigprocmask,"
#endif
#ifdef SYS_osf_sigstack
	  "osf_sigstack,"
#endif
#ifdef SYS_pause
	  "pause,"
#endif
#ifdef SYS_restart_syscall
	  "restart_syscall,"
#endif
#ifdef SYS_rt_sigaction
	  "rt_sigaction,"
#endif
#ifdef SYS_rt_sigpending
	  "rt_sigpending,"
#endif
#ifdef SYS_rt_sigprocmask
	  "rt_sigprocmask,"
#endif
#ifdef SYS_rt_sigreturn
	  "rt_sigreturn,"
#endif
#ifdef SYS_rt_sigsuspend
	  "rt_sigsuspend,"
#endif
#ifdef SYS_rt_sigtimedwait
	  "rt_sigtimedwait,"
#endif
#ifdef SYS_rt_sigtimedwait_time64
	  "rt_sigtimedwait_time64,"
#endif
#ifdef SYS_sigaction
	  "sigaction,"
#endif
#ifdef SYS_sigaltstack
	  "sigaltstack,"
#endif
#ifdef SYS_signal
	  "signal,"
#endif
#ifdef SYS_signalfd
	  "signalfd,"
#endif
#ifdef SYS_signalfd4
	  "signalfd4,"
#endif
#ifdef SYS_sigpending
	  "sigpending,"
#endif
#ifdef SYS_sigprocmask
	  "sigprocmask,"
#endif
#ifdef SYS_sigreturn
	  "sigreturn,"
#endif
#ifdef SYS_sigsuspend
	  "sigsuspend,"
#endif
#ifdef SYS_utrap_install
	  "utrap_install"
#endif
	},
	{ .name = "@swap",
	  .description = "Enable and disable swap devices and partitions.",
	  .list =
#ifdef SYS_osf_swapon
	  "osf_swapon,"
#endif
#ifdef SYS_swapoff
	  "swapoff,"
#endif
#ifdef SYS_swapon
	  "swapon"
#endif
	},
	{ .name = "@sync",
	  .description = "Synchronize file data and memory mappings to storage.",
	  .list =
#ifdef SYS_arm_sync_file_range
	  "arm_sync_file_range,"
#endif
#ifdef SYS_fdatasync
	  "fdatasync,"
#endif
#ifdef SYS_fsync
	  "fsync,"
#endif
#ifdef SYS_msync
	  "msync,"
#endif
#ifdef SYS_sync
	  "sync,"
#endif
#ifdef SYS_sync_file_range
	  "sync_file_range,"
#endif
#ifdef SYS_sync_file_range2
	  "sync_file_range2,"
#endif
#ifdef SYS_syncfs
	  "syncfs"
#endif
	},
	{ .name = "@system-service",
	  .description = "Extended system call set focusing on the user (program).",
	  .list =
	  "@aio,"
	  "@basic-io,"
	  "@chown,"
	  "@default,"
	  "@file-system,"
	  "@io-event,"
	  "@ipc,"
	  "@keyring,"
      "@memfd,"
	  "@memlock,"
	  "@network-io,"
	  "@process,"
	  "@resources,"
      "@sandbox,"
	  "@setuid,"
	  "@signal,"
	  "@sync,"
	  "@timer,"
#ifdef SYS_arm_fadvise64_64
	  "arm_fadvise64_64,"
#endif
#ifdef SYS_brk
	  "brk,"
#endif
#ifdef SYS_capget
	  "capget,"
#endif
#ifdef SYS_capset
	  "capset,"
#endif
#ifdef SYS_copy_file_range
	  "copy_file_range,"
#endif
#ifdef SYS_fadvise64
	  "fadvise64,"
#endif
#ifdef SYS_fadvise64_64
	  "fadvise64_64,"
#endif
#ifdef SYS_flock
	  "flock,"
#endif
#ifdef SYS_get_mempolicy
	  "get_mempolicy,"
#endif
#ifdef SYS_getcpu
	  "getcpu,"
#endif
#ifdef SYS_getdomainname
	  "getdomainname,"
#endif
#ifdef SYS_gethostname
	  "gethostname,"
#endif
#ifdef SYS_getpagesize
	  "getpagesize,"
#endif
#ifdef SYS_getpriority
	  "getpriority,"
#endif
#ifdef SYS_getrandom
	  "getrandom,"
#endif
#ifdef SYS_ioctl
	  "ioctl,"
#endif
#ifdef SYS_ioprio_get
	  "ioprio_get,"
#endif
#ifdef SYS_kcmp
	  "kcmp,"
#endif
#ifdef SYS_kern_features
	  "kern_features,"
#endif
#ifdef SYS_listns
	  "listns,"
#endif
#ifdef SYS_lsm_get_self_attr
	  "lsm_get_self_attr,"
#endif
#ifdef SYS_lsm_list_modules
	  "lsm_list_modules,"
#endif
#ifdef SYS_lsm_set_self_attr
	  "lsm_set_self_attr,"
#endif
#ifdef SYS_madvise
	  "madvise,"
#endif
#ifdef SYS_map_shadow_stack
	  "map_shadow_stack,"
#endif
#ifdef SYS_memory_ordering
	  "memory_ordering,"
#endif
#ifdef SYS_mremap
	  "mremap,"
#endif
#ifdef SYS_mseal
	  "mseal,"
#endif
#ifdef SYS_name_to_handle_at
	  "name_to_handle_at,"
#endif
#ifdef SYS_oldolduname
	  "oldolduname,"
#endif
#ifdef SYS_olduname
	  "olduname,"
#endif
#ifdef SYS_osf_getdomainname
	  "osf_getdomainname,"
#endif
#ifdef SYS_osf_getsysinfo
	  "osf_getsysinfo,"
#endif
#ifdef SYS_osf_setsysinfo
	  "osf_setsysinfo,"
#endif
#ifdef SYS_osf_syscall
	  "osf_syscall,"
#endif
#ifdef SYS_osf_sysinfo
	  "osf_sysinfo,"
#endif
#ifdef SYS_osf_utsname
	  "osf_utsname,"
#endif
#ifdef SYS_personality
	  "personality,"
#endif
#ifdef SYS_pkey_alloc
	  "pkey_alloc,"
#endif
#ifdef SYS_pkey_free
	  "pkey_free,"
#endif
#ifdef SYS_pkey_mprotect
	  "pkey_mprotect,"
#endif
#ifdef SYS_readahead
	  "readahead,"
#endif
#ifdef SYS_readdir
	  "readdir,"
#endif
#ifdef SYS_riscv_hwprobe
	  "riscv_hwprobe,"
#endif
#ifdef SYS_s390_sthyi
	  "s390_sthyi,"
#endif
#ifdef SYS_sched_get_priority_max
	  "sched_get_priority_max,"
#endif
#ifdef SYS_sched_get_priority_min
	  "sched_get_priority_min,"
#endif
#ifdef SYS_sched_getaffinity
	  "sched_getaffinity,"
#endif
#ifdef SYS_sched_getattr
	  "sched_getattr,"
#endif
#ifdef SYS_sched_getparam
	  "sched_getparam,"
#endif
#ifdef SYS_sched_getscheduler
	  "sched_getscheduler,"
#endif
#ifdef SYS_sched_rr_get_interval
	  "sched_rr_get_interval,"
#endif
#ifdef SYS_sched_rr_get_interval_time64
	  "sched_rr_get_interval_time64,"
#endif
#ifdef SYS_sched_yield
	  "sched_yield,"
#endif
#ifdef SYS_sendfile
	  "sendfile,"
#endif
#ifdef SYS_sendfile64
	  "sendfile64,"
#endif
#ifdef SYS_setfsgid
	  "setfsgid,"
#endif
#ifdef SYS_setfsgid32
	  "setfsgid32,"
#endif
#ifdef SYS_setfsuid
	  "setfsuid,"
#endif
#ifdef SYS_setfsuid32
	  "setfsuid32,"
#endif
#ifdef SYS_setpgid
	  "setpgid,"
#endif
#ifdef SYS_setsid
	  "setsid,"
#endif
#ifdef SYS_splice
	  "splice,"
#endif
#ifdef SYS_syscall
	  "syscall,"
#endif
#ifdef SYS_sysinfo
	  "sysinfo,"
#endif
#ifdef SYS_sysmips
	  "sysmips,"
#endif
#ifdef SYS_tee
	  "tee,"
#endif
#ifdef SYS_umask
	  "umask,"
#endif
#ifdef SYS_uname
	  "uname,"
#endif
#ifdef SYS_userfaultfd
	  "userfaultfd,"
#endif
#ifdef SYS_vmsplice
	  "vmsplice"
#endif
	},
	{ .name = "@timer",
	  .description = "Timers, sleeps and interval operations.",
	  .list =
#ifdef SYS_alarm
	  "alarm,"
#endif
#ifdef SYS_getitimer
	  "getitimer,"
#endif
#ifdef SYS_nanosleep
	  "nanosleep,"
#endif
#ifdef SYS_osf_getitimer
	  "osf_getitimer,"
#endif
#ifdef SYS_osf_setitimer
	  "osf_setitimer,"
#endif
#ifdef SYS_osf_usleep_thread
	  "osf_usleep_thread,"
#endif
#ifdef SYS_setitimer
	  "setitimer,"
#endif
#ifdef SYS_timer_create
	  "timer_create,"
#endif
#ifdef SYS_timer_delete
	  "timer_delete,"
#endif
#ifdef SYS_timer_getoverrun
	  "timer_getoverrun,"
#endif
#ifdef SYS_timer_gettime
	  "timer_gettime,"
#endif
#ifdef SYS_timer_gettime64
	  "timer_gettime64,"
#endif
#ifdef SYS_timer_settime
	  "timer_settime,"
#endif
#ifdef SYS_timer_settime64
	  "timer_settime64,"
#endif
#ifdef SYS_timerfd_create
	  "timerfd_create,"
#endif
#ifdef SYS_timerfd_gettime
	  "timerfd_gettime,"
#endif
#ifdef SYS_timerfd_gettime64
	  "timerfd_gettime64,"
#endif
#ifdef SYS_timerfd_settime
	  "timerfd_settime,"
#endif
#ifdef SYS_timerfd_settime64
	  "timerfd_settime64,"
#endif
#ifdef SYS_times
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

void syscall_groups_print(void) {
	int i;
	int elems = sizeof(sysgroups) / sizeof(sysgroups[0]);

	printf ("%-23s %s\n", "Group", "Description");
	printf ("─────────────────────────────────────────────────────────────────────────────\n");

	for (i = 0; i < elems; i++) {
		printf ("%-23s %s\n", sysgroups[i].name, sysgroups[i].description);
	}
}

void is_syscall_groups_exist(const char *groups_list)
{
	int i;
	int elems = sizeof(sysgroups) / sizeof(sysgroups[0]);
	int no_match = 0;
	char *copy = strdup(groups_list); // duplicate the string for tokenization, since strtok modifies the string
	char *token = strtok(copy, ",");
	char *new_str = malloc(strlen(copy) + 1); // unrecognized groups go here

	if ((copy == NULL) || (new_str == NULL)) {
		fprintf(stderr, "Memory allocation failed\n");
		exit(1);
	}

	new_str[0] = '\0'; // init with an empty string

	while (token != NULL) {
		if (strcmp(token, "@all") == 0) {
			token = strtok(NULL, ",");
			continue;
		}

		for (i = 0; i < elems; i++) {
			if (strcmp(token, sysgroups[i].name) == 0)
			{
				no_match = 0;
				break;
			}
			else
				no_match = 1;
		}

		if (no_match) {
			if (new_str[0] != '\0')
				strcat(new_str, ",");
			strcat(new_str, token);
		}

		token = strtok(NULL, ",");
	}

	if (new_str[0] != '\0') {
		fprintf(stderr, "Unrecognized syscall group(s): %s\n", new_str);
		fprintf(stderr, "See --debug-syscall-groups for valid seccomp groups\n");
		free(copy);
		free(new_str);
		exit(1);
	}

	free(copy);
	free(new_str);
}

void syscall_in_groups_print(const char *groups_list) {
	if (groups_list == NULL || *groups_list == '\0') {
		fprintf(stderr, "Value for --debug-syscall-groups can not be empty\n");
		exit(1);
	}

	is_syscall_groups_exist(groups_list);

	int i;
	int elems = sizeof(sysgroups) / sizeof(sysgroups[0]);
	char *copy = strdup(groups_list);

	if (copy == NULL) {
		fprintf(stderr, "Memory allocation failed\n");
		exit(1);
	}

	char *token = strtok(copy, ",");

	while (token != NULL) {
		for (i = 0; i < elems; i++) {
			if ((strcmp(token, "@all") == 0) || (strcmp(token, sysgroups[i].name) == 0)) {
				if (strcmp(sysgroups[i].list, "__dummy_syscall__") == 0) {
					printf ("%s=(There are no system calls defined in this group for the current architecture)\n", sysgroups[i].name);
					continue;
				}

				int len = strlen(sysgroups[i].list);
				char new_list[len + 1];

				strcpy(new_list, sysgroups[i].list);

				if (len > 0 && new_list[len - 1] == ',') // remove the last comma if present
					new_list[len - 1] = '\0';

				printf ("%s=%s\n", sysgroups[i].name, new_list);
			}
		}

		token = strtok(NULL, ",");
	}

	free(copy);
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
	if (*syscall_nr == SYSCALL_ERROR) {
		free(str);
		goto error;
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
