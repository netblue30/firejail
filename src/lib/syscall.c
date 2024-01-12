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

// Native syscalls (64 bit versions for 64 bit arch etc)
static const SyscallEntry syslist[] = {
#if defined(__x86_64__)
// code generated using
// awk '/__NR_/ { print "{ \"" gensub("__NR_", "", "g", $2) "\", " $3 " },"; }' < /usr/include/x86_64-linux-gnu/asm/unistd_64.h
#include "../include/syscall_x86_64.h"
#elif defined(__i386__)
// awk '/__NR_/ { print "{ \"" gensub("__NR_", "", "g", $2) "\", " $3 " },"; }' < /usr/include/x86_64-linux-gnu/asm/unistd_32.h
#include "../include/syscall_i386.h"
#elif defined(__arm__)
#include "../include/syscall_armeabi.h"
#else
#warning "Please submit a syscall table for your architecture"
#endif
};

// 32 bit syscalls for 64 bit arch
static const SyscallEntry syslist32[] = {
#if defined(__x86_64__)
#include "../include/syscall_i386.h"
// TODO for other 64 bit archs
#elif defined(__i386__) || defined(__arm__) || defined(__powerpc__)
// no secondary arch for 32 bit archs
#endif
};

static const SyscallGroupList sysgroups[] = {
	{ .name = "@aio", .list =
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
	{ .name = "@basic-io", .list =
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
	{ .name = "@chown", .list =
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
#ifdef SYS_add_key
	  "add_key,"
#endif
#ifdef SYS_request_key
	  "request_key,"
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
#ifdef SYS_set_mempolicy
	  "set_mempolicy,"
#endif
#ifdef SYS_vmsplice
	  "vmsplice,"
#endif
#ifdef SYS_userfaultfd
	  "userfaultfd,"
#endif
#ifdef SYS_acct
	  "acct,"
#endif
#ifdef SYS_bpf
	  "bpf,"
#endif
#ifdef SYS_nfsservctl
	  "nfsservctl,"
#endif
#ifdef SYS_setdomainname
	  "setdomainname,"
#endif
#ifdef SYS_sethostname
	  "sethostname,"
#endif
#ifdef SYS_vhangup
	  "vhangup"
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
	  "execveat," // commonly used by fexecve
	  "execve,"
	  "prctl"
	},
	{ .name = "@file-system", .list =
#ifdef SYS_access
	  "access,"
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
#ifdef SYS_fchdir
	  "fchdir,"
#endif
#ifdef SYS_fchmod
	  "fchmod,"
#endif
#ifdef SYS_fchmodat
	  "fchmodat,"
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
#ifdef SYS_futimesat
	  "futimesat,"
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
#ifdef SYS_mmap
	  "mmap,"
#endif
#ifdef SYS_mmap2
	  "mmap2,"
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
#ifdef SYS_readlink
	  "readlink,"
#endif
#ifdef SYS_readlinkat
	  "readlinkat,"
#endif
#ifdef SYS_removexattr
	  "removexattr,"
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
#ifdef SYS_utime
	  "utime,"
#endif
#ifdef SYS_utimensat
	  "utimensat,"
#endif
#ifdef SYS_utimes
	  "utimes"
#endif
	},
	{ .name = "@io-event", .list =
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
#ifdef SYS_epoll_ctl_old
	  "epoll_ctl_old,"
#endif
#ifdef SYS_epoll_pwait
	  "epoll_pwait,"
#endif
#ifdef SYS_epoll_wait
	  "epoll_wait,"
#endif
#ifdef SYS_epoll_wait_old
	  "epoll_wait_old,"
#endif
#ifdef SYS_eventfd
	  "eventfd,"
#endif
#ifdef SYS_eventfd2
	  "eventfd2,"
#endif
#ifdef SYS_poll
	  "poll,"
#endif
#ifdef SYS_ppoll
	  "ppoll,"
#endif
#ifdef SYS_pselect6
	  "pselect6,"
#endif
#ifdef SYS_select
	  "select"
#endif
	},
	{ .name = "@ipc", .list =
#ifdef SYS_ipc
	  "ipc,"
#endif
#ifdef SYS_memfd_create
	  "memfd_create,"
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
#ifdef SYS_mq_timedsend
	  "mq_timedsend,"
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
	{ .name = "@keyring", .list =
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
	{ .name = "@memlock", .list =
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
	{ .name = "@mount", .list =
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
#ifdef SYS_mount
	  "mount,"
#endif
#ifdef SYS_move_mount
	  "move_mount,"
#endif
#ifdef SYS_open_tree
	  "open_tree,"
#endif
#ifdef SYS_pivot_root
	  "pivot_root,"
#endif
#ifdef SYS_umount
	  "umount,"
#endif
#ifdef SYS_umount2
	  "umount2"
#endif
	},
	{ .name = "@network-io", .list =
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
#ifdef SYS_idle
	  "idle,"
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
	{ .name = "@process", .list =
#ifdef SYS_arch_prctl
	  "arch_prctl,"
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
#ifdef SYS_execveat
	  "execveat,"
#endif
#ifdef SYS_fork
	  "fork,"
#endif
#ifdef SYS_getrusage
	  "getrusage,"
#endif
#ifdef SYS_kill
	  "kill,"
#endif
#ifdef SYS_pidfd_open
	  "pidfd_open,"
#endif
#ifdef SYS_pidfd_send_signal
	  "pidfd_send_signal,"
#endif
#ifdef SYS_prctl
	  "prctl,"
#endif
#ifdef SYS_rt_sigqueueinfo
	  "rt_sigqueueinfo,"
#endif
#ifdef SYS_rt_tgsigqueueinfo
	  "rt_tgsigqueueinfo,"
#endif
#ifdef SYS_setns
	  "setns,"
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
#ifdef SYS_tkill
	  "tkill,"
#endif
#ifdef SYS_unshare
	  "unshare,"
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
#ifdef SYS_s390_pci_mmio_read
	  "s390_pci_mmio_read,"
#endif
#ifdef SYS_s390_pci_mmio_write
	  "s390_pci_mmio_write"
#endif
#if !defined(SYS_ioperm) && !defined(SYS_iopl) && !defined(SYS_pciconfig_iobase) && !defined(SYS_pciconfig_read) && !defined(SYS_pciconfig_write) && !defined(SYS_s390_pci_mmio_read) && !defined(SYS_s390_pci_mmio_write)
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
#ifdef SYS_ioprio_set
	  "ioprio_set,"
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
#ifdef SYS_nice
	  "nice,"
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
	  "set_mempolicy"
#endif
	},
	{ .name = "@setuid", .list =
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
	{ .name = "@signal", .list =
#ifdef SYS_rt_sigaction
	  "rt_sigaction,"
#endif
#ifdef SYS_rt_sigpending
	  "rt_sigpending,"
#endif
#ifdef SYS_rt_sigprocmask
	  "rt_sigprocmask,"
#endif
#ifdef SYS_rt_sigsuspend
	  "rt_sigsuspend,"
#endif
#ifdef SYS_rt_sigtimedwait
	  "rt_sigtimedwait,"
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
#ifdef SYS_sigsuspend
	  "sigsuspend"
#endif
	},
	{ .name = "@swap", .list =
#ifdef SYS_swapon
	  "swapon,"
#endif
#ifdef SYS_swapoff
	  "swapoff"
#endif
	},
	{ .name = "@sync", .list =
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
#ifdef SYS_madvise
	  "madvise,"
#endif
#ifdef SYS_mprotect
	  "mprotect,"
#endif
#ifdef SYS_mremap
	  "mremap,"
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
#ifdef SYS_personality
	  "personality,"
#endif
#ifdef SYS_readahead
	  "readahead,"
#endif
#ifdef SYS_readdir
	  "readdir,"
#endif
#ifdef SYS_remap_file_pages
	  "remap_file_pages,"
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
#ifdef SYS_sysinfo
	  "sysinfo,"
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
	{ .name = "@timer", .list =
#ifdef SYS_alarm
	  "alarm,"
#endif
#ifdef SYS_getitimer
	  "getitimer,"
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
#ifdef SYS_timer_settime
	  "timer_settime,"
#endif
#ifdef SYS_timerfd_create
	  "timerfd_create,"
#endif
#ifdef SYS_timerfd_gettime
	  "timerfd_gettime,"
#endif
#ifdef SYS_timerfd_settime
	  "timerfd_settime,"
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
