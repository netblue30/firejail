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

// content extracted from /bits/syscall.h file form glibc 2.22
// using ../tools/extract_syscall tool
#if !defined __x86_64__
#ifdef SYS__llseek
#ifdef __NR__llseek
	{"_llseek", __NR__llseek},
#endif
#endif
#ifdef SYS__newselect
#ifdef __NR__newselect
	{"_newselect", __NR__newselect},
#endif
#endif
#ifdef SYS__sysctl
#ifdef __NR__sysctl
	{"_sysctl", __NR__sysctl},
#endif
#endif
#ifdef SYS_accept4
#ifdef __NR_accept4
	{"accept4", __NR_accept4},
#endif
#endif
#ifdef SYS_access
#ifdef __NR_access
	{"access", __NR_access},
#endif
#endif
#ifdef SYS_acct
#ifdef __NR_acct
	{"acct", __NR_acct},
#endif
#endif
#ifdef SYS_add_key
#ifdef __NR_add_key
	{"add_key", __NR_add_key},
#endif
#endif
#ifdef SYS_adjtimex
#ifdef __NR_adjtimex
	{"adjtimex", __NR_adjtimex},
#endif
#endif
#ifdef SYS_afs_syscall
#ifdef __NR_afs_syscall
	{"afs_syscall", __NR_afs_syscall},
#endif
#endif
#ifdef SYS_alarm
#ifdef __NR_alarm
	{"alarm", __NR_alarm},
#endif
#endif
#ifdef SYS_arch_prctl
#ifdef __NR_arch_prctl
	{"arch_prctl", __NR_arch_prctl},
#endif
#endif
#ifdef SYS_bdflush
#ifdef __NR_bdflush
	{"bdflush", __NR_bdflush},
#endif
#endif
#ifdef SYS_bind
#ifdef __NR_bind
	{"bind", __NR_bind},
#endif
#endif
#ifdef SYS_bpf
#ifdef __NR_bpf
	{"bpf", __NR_bpf},
#endif
#endif
#ifdef SYS_break
#ifdef __NR_break
	{"break", __NR_break},
#endif
#endif
#ifdef SYS_brk
#ifdef __NR_brk
	{"brk", __NR_brk},
#endif
#endif
#ifdef SYS_capget
#ifdef __NR_capget
	{"capget", __NR_capget},
#endif
#endif
#ifdef SYS_capset
#ifdef __NR_capset
	{"capset", __NR_capset},
#endif
#endif
#ifdef SYS_chdir
#ifdef __NR_chdir
	{"chdir", __NR_chdir},
#endif
#endif
#ifdef SYS_chmod
#ifdef __NR_chmod
	{"chmod", __NR_chmod},
#endif
#endif
#ifdef SYS_chown
#ifdef __NR_chown
	{"chown", __NR_chown},
#endif
#endif
#ifdef SYS_chown32
#ifdef __NR_chown32
	{"chown32", __NR_chown32},
#endif
#endif
#ifdef SYS_chroot
#ifdef __NR_chroot
	{"chroot", __NR_chroot},
#endif
#endif
#ifdef SYS_clock_adjtime
#ifdef __NR_clock_adjtime
	{"clock_adjtime", __NR_clock_adjtime},
#endif
#endif
#ifdef SYS_clock_getres
#ifdef __NR_clock_getres
	{"clock_getres", __NR_clock_getres},
#endif
#endif
#ifdef SYS_clock_gettime
#ifdef __NR_clock_gettime
	{"clock_gettime", __NR_clock_gettime},
#endif
#endif
#ifdef SYS_clock_nanosleep
#ifdef __NR_clock_nanosleep
	{"clock_nanosleep", __NR_clock_nanosleep},
#endif
#endif
#ifdef SYS_clock_settime
#ifdef __NR_clock_settime
	{"clock_settime", __NR_clock_settime},
#endif
#endif
#ifdef SYS_clone
#ifdef __NR_clone
	{"clone", __NR_clone},
#endif
#endif
#ifdef SYS_close
#ifdef __NR_close
	{"close", __NR_close},
#endif
#endif
#ifdef SYS_connect
#ifdef __NR_connect
	{"connect", __NR_connect},
#endif
#endif
#ifdef SYS_copy_file_range
#ifdef __NR_copy_file_range
	{"copy_file_range", __NR_copy_file_range},
#endif
#endif
#ifdef SYS_creat
#ifdef __NR_creat
	{"creat", __NR_creat},
#endif
#endif
#ifdef SYS_create_module
#ifdef __NR_create_module
	{"create_module", __NR_create_module},
#endif
#endif
#ifdef SYS_delete_module
#ifdef __NR_delete_module
	{"delete_module", __NR_delete_module},
#endif
#endif
#ifdef SYS_dup
#ifdef __NR_dup
	{"dup", __NR_dup},
#endif
#endif
#ifdef SYS_dup2
#ifdef __NR_dup2
	{"dup2", __NR_dup2},
#endif
#endif
#ifdef SYS_dup3
#ifdef __NR_dup3
	{"dup3", __NR_dup3},
#endif
#endif
#ifdef SYS_epoll_create
#ifdef __NR_epoll_create
	{"epoll_create", __NR_epoll_create},
#endif
#endif
#ifdef SYS_epoll_create1
#ifdef __NR_epoll_create1
	{"epoll_create1", __NR_epoll_create1},
#endif
#endif
#ifdef SYS_epoll_ctl
#ifdef __NR_epoll_ctl
	{"epoll_ctl", __NR_epoll_ctl},
#endif
#endif
#ifdef SYS_epoll_pwait
#ifdef __NR_epoll_pwait
	{"epoll_pwait", __NR_epoll_pwait},
#endif
#endif
#ifdef SYS_epoll_wait
#ifdef __NR_epoll_wait
	{"epoll_wait", __NR_epoll_wait},
#endif
#endif
#ifdef SYS_eventfd
#ifdef __NR_eventfd
	{"eventfd", __NR_eventfd},
#endif
#endif
#ifdef SYS_eventfd2
#ifdef __NR_eventfd2
	{"eventfd2", __NR_eventfd2},
#endif
#endif
#ifdef SYS_execve
#ifdef __NR_execve
	{"execve", __NR_execve},
#endif
#endif
#ifdef SYS_execveat
#ifdef __NR_execveat
	{"execveat", __NR_execveat},
#endif
#endif
#ifdef SYS_exit
#ifdef __NR_exit
	{"exit", __NR_exit},
#endif
#endif
#ifdef SYS_exit_group
#ifdef __NR_exit_group
	{"exit_group", __NR_exit_group},
#endif
#endif
#ifdef SYS_faccessat
#ifdef __NR_faccessat
	{"faccessat", __NR_faccessat},
#endif
#endif
#ifdef SYS_fadvise64
#ifdef __NR_fadvise64
	{"fadvise64", __NR_fadvise64},
#endif
#endif
#ifdef SYS_fadvise64_64
#ifdef __NR_fadvise64_64
	{"fadvise64_64", __NR_fadvise64_64},
#endif
#endif
#ifdef SYS_fallocate
#ifdef __NR_fallocate
	{"fallocate", __NR_fallocate},
#endif
#endif
#ifdef SYS_fanotify_init
#ifdef __NR_fanotify_init
	{"fanotify_init", __NR_fanotify_init},
#endif
#endif
#ifdef SYS_fanotify_mark
#ifdef __NR_fanotify_mark
	{"fanotify_mark", __NR_fanotify_mark},
#endif
#endif
#ifdef SYS_fchdir
#ifdef __NR_fchdir
	{"fchdir", __NR_fchdir},
#endif
#endif
#ifdef SYS_fchmod
#ifdef __NR_fchmod
	{"fchmod", __NR_fchmod},
#endif
#endif
#ifdef SYS_fchmodat
#ifdef __NR_fchmodat
	{"fchmodat", __NR_fchmodat},
#endif
#endif
#ifdef SYS_fchown
#ifdef __NR_fchown
	{"fchown", __NR_fchown},
#endif
#endif
#ifdef SYS_fchown32
#ifdef __NR_fchown32
	{"fchown32", __NR_fchown32},
#endif
#endif
#ifdef SYS_fchownat
#ifdef __NR_fchownat
	{"fchownat", __NR_fchownat},
#endif
#endif
#ifdef SYS_fcntl
#ifdef __NR_fcntl
	{"fcntl", __NR_fcntl},
#endif
#endif
#ifdef SYS_fcntl64
#ifdef __NR_fcntl64
	{"fcntl64", __NR_fcntl64},
#endif
#endif
#ifdef SYS_fdatasync
#ifdef __NR_fdatasync
	{"fdatasync", __NR_fdatasync},
#endif
#endif
#ifdef SYS_fgetxattr
#ifdef __NR_fgetxattr
	{"fgetxattr", __NR_fgetxattr},
#endif
#endif
#ifdef SYS_finit_module
#ifdef __NR_finit_module
	{"finit_module", __NR_finit_module},
#endif
#endif
#ifdef SYS_flistxattr
#ifdef __NR_flistxattr
	{"flistxattr", __NR_flistxattr},
#endif
#endif
#ifdef SYS_flock
#ifdef __NR_flock
	{"flock", __NR_flock},
#endif
#endif
#ifdef SYS_fork
#ifdef __NR_fork
	{"fork", __NR_fork},
#endif
#endif
#ifdef SYS_fremovexattr
#ifdef __NR_fremovexattr
	{"fremovexattr", __NR_fremovexattr},
#endif
#endif
#ifdef SYS_fsetxattr
#ifdef __NR_fsetxattr
	{"fsetxattr", __NR_fsetxattr},
#endif
#endif
#ifdef SYS_fstat
#ifdef __NR_fstat
	{"fstat", __NR_fstat},
#endif
#endif
#ifdef SYS_fstat64
#ifdef __NR_fstat64
	{"fstat64", __NR_fstat64},
#endif
#endif
#ifdef SYS_fstatat64
#ifdef __NR_fstatat64
	{"fstatat64", __NR_fstatat64},
#endif
#endif
#ifdef SYS_fstatfs
#ifdef __NR_fstatfs
	{"fstatfs", __NR_fstatfs},
#endif
#endif
#ifdef SYS_fstatfs64
#ifdef __NR_fstatfs64
	{"fstatfs64", __NR_fstatfs64},
#endif
#endif
#ifdef SYS_fsync
#ifdef __NR_fsync
	{"fsync", __NR_fsync},
#endif
#endif
#ifdef SYS_ftime
#ifdef __NR_ftime
	{"ftime", __NR_ftime},
#endif
#endif
#ifdef SYS_ftruncate
#ifdef __NR_ftruncate
	{"ftruncate", __NR_ftruncate},
#endif
#endif
#ifdef SYS_ftruncate64
#ifdef __NR_ftruncate64
	{"ftruncate64", __NR_ftruncate64},
#endif
#endif
#ifdef SYS_futex
#ifdef __NR_futex
	{"futex", __NR_futex},
#endif
#endif
#ifdef SYS_futimesat
#ifdef __NR_futimesat
	{"futimesat", __NR_futimesat},
#endif
#endif
#ifdef SYS_get_kernel_syms
#ifdef __NR_get_kernel_syms
	{"get_kernel_syms", __NR_get_kernel_syms},
#endif
#endif
#ifdef SYS_get_mempolicy
#ifdef __NR_get_mempolicy
	{"get_mempolicy", __NR_get_mempolicy},
#endif
#endif
#ifdef SYS_get_robust_list
#ifdef __NR_get_robust_list
	{"get_robust_list", __NR_get_robust_list},
#endif
#endif
#ifdef SYS_get_thread_area
#ifdef __NR_get_thread_area
	{"get_thread_area", __NR_get_thread_area},
#endif
#endif
#ifdef SYS_getcpu
#ifdef __NR_getcpu
	{"getcpu", __NR_getcpu},
#endif
#endif
#ifdef SYS_getcwd
#ifdef __NR_getcwd
	{"getcwd", __NR_getcwd},
#endif
#endif
#ifdef SYS_getdents
#ifdef __NR_getdents
	{"getdents", __NR_getdents},
#endif
#endif
#ifdef SYS_getdents64
#ifdef __NR_getdents64
	{"getdents64", __NR_getdents64},
#endif
#endif
#ifdef SYS_getegid
#ifdef __NR_getegid
	{"getegid", __NR_getegid},
#endif
#endif
#ifdef SYS_getegid32
#ifdef __NR_getegid32
	{"getegid32", __NR_getegid32},
#endif
#endif
#ifdef SYS_geteuid
#ifdef __NR_geteuid
	{"geteuid", __NR_geteuid},
#endif
#endif
#ifdef SYS_geteuid32
#ifdef __NR_geteuid32
	{"geteuid32", __NR_geteuid32},
#endif
#endif
#ifdef SYS_getgid
#ifdef __NR_getgid
	{"getgid", __NR_getgid},
#endif
#endif
#ifdef SYS_getgid32
#ifdef __NR_getgid32
	{"getgid32", __NR_getgid32},
#endif
#endif
#ifdef SYS_getgroups
#ifdef __NR_getgroups
	{"getgroups", __NR_getgroups},
#endif
#endif
#ifdef SYS_getgroups32
#ifdef __NR_getgroups32
	{"getgroups32", __NR_getgroups32},
#endif
#endif
#ifdef SYS_getitimer
#ifdef __NR_getitimer
	{"getitimer", __NR_getitimer},
#endif
#endif
#ifdef SYS_getpeername
#ifdef __NR_getpeername
	{"getpeername", __NR_getpeername},
#endif
#endif
#ifdef SYS_getpgid
#ifdef __NR_getpgid
	{"getpgid", __NR_getpgid},
#endif
#endif
#ifdef SYS_getpgrp
#ifdef __NR_getpgrp
	{"getpgrp", __NR_getpgrp},
#endif
#endif
#ifdef SYS_getpid
#ifdef __NR_getpid
	{"getpid", __NR_getpid},
#endif
#endif
#ifdef SYS_getpmsg
#ifdef __NR_getpmsg
	{"getpmsg", __NR_getpmsg},
#endif
#endif
#ifdef SYS_getppid
#ifdef __NR_getppid
	{"getppid", __NR_getppid},
#endif
#endif
#ifdef SYS_getpriority
#ifdef __NR_getpriority
	{"getpriority", __NR_getpriority},
#endif
#endif
#ifdef SYS_getrandom
#ifdef __NR_getrandom
	{"getrandom", __NR_getrandom},
#endif
#endif
#ifdef SYS_getresgid
#ifdef __NR_getresgid
	{"getresgid", __NR_getresgid},
#endif
#endif
#ifdef SYS_getresgid32
#ifdef __NR_getresgid32
	{"getresgid32", __NR_getresgid32},
#endif
#endif
#ifdef SYS_getresuid
#ifdef __NR_getresuid
	{"getresuid", __NR_getresuid},
#endif
#endif
#ifdef SYS_getresuid32
#ifdef __NR_getresuid32
	{"getresuid32", __NR_getresuid32},
#endif
#endif
#ifdef SYS_getrlimit
#ifdef __NR_getrlimit
	{"getrlimit", __NR_getrlimit},
#endif
#endif
#ifdef SYS_getrusage
#ifdef __NR_getrusage
	{"getrusage", __NR_getrusage},
#endif
#endif
#ifdef SYS_getsid
#ifdef __NR_getsid
	{"getsid", __NR_getsid},
#endif
#endif
#ifdef SYS_getsockname
#ifdef __NR_getsockname
	{"getsockname", __NR_getsockname},
#endif
#endif
#ifdef SYS_getsockopt
#ifdef __NR_getsockopt
	{"getsockopt", __NR_getsockopt},
#endif
#endif
#ifdef SYS_gettid
#ifdef __NR_gettid
	{"gettid", __NR_gettid},
#endif
#endif
#ifdef SYS_gettimeofday
#ifdef __NR_gettimeofday
	{"gettimeofday", __NR_gettimeofday},
#endif
#endif
#ifdef SYS_getuid
#ifdef __NR_getuid
	{"getuid", __NR_getuid},
#endif
#endif
#ifdef SYS_getuid32
#ifdef __NR_getuid32
	{"getuid32", __NR_getuid32},
#endif
#endif
#ifdef SYS_getxattr
#ifdef __NR_getxattr
	{"getxattr", __NR_getxattr},
#endif
#endif
#ifdef SYS_gtty
#ifdef __NR_gtty
	{"gtty", __NR_gtty},
#endif
#endif
#ifdef SYS_idle
#ifdef __NR_idle
	{"idle", __NR_idle},
#endif
#endif
#ifdef SYS_init_module
#ifdef __NR_init_module
	{"init_module", __NR_init_module},
#endif
#endif
#ifdef SYS_inotify_add_watch
#ifdef __NR_inotify_add_watch
	{"inotify_add_watch", __NR_inotify_add_watch},
#endif
#endif
#ifdef SYS_inotify_init
#ifdef __NR_inotify_init
	{"inotify_init", __NR_inotify_init},
#endif
#endif
#ifdef SYS_inotify_init1
#ifdef __NR_inotify_init1
	{"inotify_init1", __NR_inotify_init1},
#endif
#endif
#ifdef SYS_inotify_rm_watch
#ifdef __NR_inotify_rm_watch
	{"inotify_rm_watch", __NR_inotify_rm_watch},
#endif
#endif
#ifdef SYS_io_cancel
#ifdef __NR_io_cancel
	{"io_cancel", __NR_io_cancel},
#endif
#endif
#ifdef SYS_io_destroy
#ifdef __NR_io_destroy
	{"io_destroy", __NR_io_destroy},
#endif
#endif
#ifdef SYS_io_getevents
#ifdef __NR_io_getevents
	{"io_getevents", __NR_io_getevents},
#endif
#endif
#ifdef SYS_io_setup
#ifdef __NR_io_setup
	{"io_setup", __NR_io_setup},
#endif
#endif
#ifdef SYS_io_submit
#ifdef __NR_io_submit
	{"io_submit", __NR_io_submit},
#endif
#endif
#ifdef SYS_ioctl
#ifdef __NR_ioctl
	{"ioctl", __NR_ioctl},
#endif
#endif
#ifdef SYS_ioperm
#ifdef __NR_ioperm
	{"ioperm", __NR_ioperm},
#endif
#endif
#ifdef SYS_iopl
#ifdef __NR_iopl
	{"iopl", __NR_iopl},
#endif
#endif
#ifdef SYS_ioprio_get
#ifdef __NR_ioprio_get
	{"ioprio_get", __NR_ioprio_get},
#endif
#endif
#ifdef SYS_ioprio_set
#ifdef __NR_ioprio_set
	{"ioprio_set", __NR_ioprio_set},
#endif
#endif
#ifdef SYS_ipc
#ifdef __NR_ipc
	{"ipc", __NR_ipc},
#endif
#endif
#ifdef SYS_kcmp
#ifdef __NR_kcmp
	{"kcmp", __NR_kcmp},
#endif
#endif
#ifdef SYS_kexec_load
#ifdef __NR_kexec_load
	{"kexec_load", __NR_kexec_load},
#endif
#endif
#ifdef SYS_keyctl
#ifdef __NR_keyctl
	{"keyctl", __NR_keyctl},
#endif
#endif
#ifdef SYS_kill
#ifdef __NR_kill
	{"kill", __NR_kill},
#endif
#endif
#ifdef SYS_lchown
#ifdef __NR_lchown
	{"lchown", __NR_lchown},
#endif
#endif
#ifdef SYS_lchown32
#ifdef __NR_lchown32
	{"lchown32", __NR_lchown32},
#endif
#endif
#ifdef SYS_lgetxattr
#ifdef __NR_lgetxattr
	{"lgetxattr", __NR_lgetxattr},
#endif
#endif
#ifdef SYS_link
#ifdef __NR_link
	{"link", __NR_link},
#endif
#endif
#ifdef SYS_linkat
#ifdef __NR_linkat
	{"linkat", __NR_linkat},
#endif
#endif
#ifdef SYS_listen
#ifdef __NR_listen
	{"listen", __NR_listen},
#endif
#endif
#ifdef SYS_listxattr
#ifdef __NR_listxattr
	{"listxattr", __NR_listxattr},
#endif
#endif
#ifdef SYS_llistxattr
#ifdef __NR_llistxattr
	{"llistxattr", __NR_llistxattr},
#endif
#endif
#ifdef SYS_lock
#ifdef __NR_lock
	{"lock", __NR_lock},
#endif
#endif
#ifdef SYS_lookup_dcookie
#ifdef __NR_lookup_dcookie
	{"lookup_dcookie", __NR_lookup_dcookie},
#endif
#endif
#ifdef SYS_lremovexattr
#ifdef __NR_lremovexattr
	{"lremovexattr", __NR_lremovexattr},
#endif
#endif
#ifdef SYS_lseek
#ifdef __NR_lseek
	{"lseek", __NR_lseek},
#endif
#endif
#ifdef SYS_lsetxattr
#ifdef __NR_lsetxattr
	{"lsetxattr", __NR_lsetxattr},
#endif
#endif
#ifdef SYS_lstat
#ifdef __NR_lstat
	{"lstat", __NR_lstat},
#endif
#endif
#ifdef SYS_lstat64
#ifdef __NR_lstat64
	{"lstat64", __NR_lstat64},
#endif
#endif
#ifdef SYS_madvise
#ifdef __NR_madvise
	{"madvise", __NR_madvise},
#endif
#endif
#ifdef SYS_mbind
#ifdef __NR_mbind
	{"mbind", __NR_mbind},
#endif
#endif
#ifdef SYS_membarrier
#ifdef __NR_membarrier
	{"membarrier", __NR_membarrier},
#endif
#endif
#ifdef SYS_memfd_create
#ifdef __NR_memfd_create
	{"memfd_create", __NR_memfd_create},
#endif
#endif
#ifdef SYS_migrate_pages
#ifdef __NR_migrate_pages
	{"migrate_pages", __NR_migrate_pages},
#endif
#endif
#ifdef SYS_mincore
#ifdef __NR_mincore
	{"mincore", __NR_mincore},
#endif
#endif
#ifdef SYS_mkdir
#ifdef __NR_mkdir
	{"mkdir", __NR_mkdir},
#endif
#endif
#ifdef SYS_mkdirat
#ifdef __NR_mkdirat
	{"mkdirat", __NR_mkdirat},
#endif
#endif
#ifdef SYS_mknod
#ifdef __NR_mknod
	{"mknod", __NR_mknod},
#endif
#endif
#ifdef SYS_mknodat
#ifdef __NR_mknodat
	{"mknodat", __NR_mknodat},
#endif
#endif
#ifdef SYS_mlock
#ifdef __NR_mlock
	{"mlock", __NR_mlock},
#endif
#endif
#ifdef SYS_mlock2
#ifdef __NR_mlock2
	{"mlock2", __NR_mlock2},
#endif
#endif
#ifdef SYS_mlockall
#ifdef __NR_mlockall
	{"mlockall", __NR_mlockall},
#endif
#endif
#ifdef SYS_mmap
#ifdef __NR_mmap
	{"mmap", __NR_mmap},
#endif
#endif
#ifdef SYS_mmap2
#ifdef __NR_mmap2
	{"mmap2", __NR_mmap2},
#endif
#endif
#ifdef SYS_modify_ldt
#ifdef __NR_modify_ldt
	{"modify_ldt", __NR_modify_ldt},
#endif
#endif
#ifdef SYS_mount
#ifdef __NR_mount
	{"mount", __NR_mount},
#endif
#endif
#ifdef SYS_move_pages
#ifdef __NR_move_pages
	{"move_pages", __NR_move_pages},
#endif
#endif
#ifdef SYS_mprotect
#ifdef __NR_mprotect
	{"mprotect", __NR_mprotect},
#endif
#endif
#ifdef SYS_mpx
#ifdef __NR_mpx
	{"mpx", __NR_mpx},
#endif
#endif
#ifdef SYS_mq_getsetattr
#ifdef __NR_mq_getsetattr
	{"mq_getsetattr", __NR_mq_getsetattr},
#endif
#endif
#ifdef SYS_mq_notify
#ifdef __NR_mq_notify
	{"mq_notify", __NR_mq_notify},
#endif
#endif
#ifdef SYS_mq_open
#ifdef __NR_mq_open
	{"mq_open", __NR_mq_open},
#endif
#endif
#ifdef SYS_mq_timedreceive
#ifdef __NR_mq_timedreceive
	{"mq_timedreceive", __NR_mq_timedreceive},
#endif
#endif
#ifdef SYS_mq_timedsend
#ifdef __NR_mq_timedsend
	{"mq_timedsend", __NR_mq_timedsend},
#endif
#endif
#ifdef SYS_mq_unlink
#ifdef __NR_mq_unlink
	{"mq_unlink", __NR_mq_unlink},
#endif
#endif
#ifdef SYS_mremap
#ifdef __NR_mremap
	{"mremap", __NR_mremap},
#endif
#endif
#ifdef SYS_msync
#ifdef __NR_msync
	{"msync", __NR_msync},
#endif
#endif
#ifdef SYS_munlock
#ifdef __NR_munlock
	{"munlock", __NR_munlock},
#endif
#endif
#ifdef SYS_munlockall
#ifdef __NR_munlockall
	{"munlockall", __NR_munlockall},
#endif
#endif
#ifdef SYS_munmap
#ifdef __NR_munmap
	{"munmap", __NR_munmap},
#endif
#endif
#ifdef SYS_name_to_handle_at
#ifdef __NR_name_to_handle_at
	{"name_to_handle_at", __NR_name_to_handle_at},
#endif
#endif
#ifdef SYS_nanosleep
#ifdef __NR_nanosleep
	{"nanosleep", __NR_nanosleep},
#endif
#endif
#ifdef SYS_nfsservctl
#ifdef __NR_nfsservctl
	{"nfsservctl", __NR_nfsservctl},
#endif
#endif
#ifdef SYS_nice
#ifdef __NR_nice
	{"nice", __NR_nice},
#endif
#endif
#ifdef SYS_oldfstat
#ifdef __NR_oldfstat
	{"oldfstat", __NR_oldfstat},
#endif
#endif
#ifdef SYS_oldlstat
#ifdef __NR_oldlstat
	{"oldlstat", __NR_oldlstat},
#endif
#endif
#ifdef SYS_oldolduname
#ifdef __NR_oldolduname
	{"oldolduname", __NR_oldolduname},
#endif
#endif
#ifdef SYS_oldstat
#ifdef __NR_oldstat
	{"oldstat", __NR_oldstat},
#endif
#endif
#ifdef SYS_olduname
#ifdef __NR_olduname
	{"olduname", __NR_olduname},
#endif
#endif
#ifdef SYS_open
#ifdef __NR_open
	{"open", __NR_open},
#endif
#endif
#ifdef SYS_open_by_handle_at
#ifdef __NR_open_by_handle_at
	{"open_by_handle_at", __NR_open_by_handle_at},
#endif
#endif
#ifdef SYS_openat
#ifdef __NR_openat
	{"openat", __NR_openat},
#endif
#endif
#ifdef SYS_pause
#ifdef __NR_pause
	{"pause", __NR_pause},
#endif
#endif
#ifdef SYS_perf_event_open
#ifdef __NR_perf_event_open
	{"perf_event_open", __NR_perf_event_open},
#endif
#endif
#ifdef SYS_personality
#ifdef __NR_personality
	{"personality", __NR_personality},
#endif
#endif
#ifdef SYS_pipe
#ifdef __NR_pipe
	{"pipe", __NR_pipe},
#endif
#endif
#ifdef SYS_pipe2
#ifdef __NR_pipe2
	{"pipe2", __NR_pipe2},
#endif
#endif
#ifdef SYS_pivot_root
#ifdef __NR_pivot_root
	{"pivot_root", __NR_pivot_root},
#endif
#endif
#ifdef SYS_pkey_alloc
#ifdef __NR_pkey_alloc
	{"pkey_alloc", __NR_pkey_alloc},
#endif
#endif
#ifdef SYS_pkey_free
#ifdef __NR_pkey_free
	{"pkey_free", __NR_pkey_free},
#endif
#endif
#ifdef SYS_pkey_mprotect
#ifdef __NR_pkey_mprotect
	{"pkey_mprotect", __NR_pkey_mprotect},
#endif
#endif
#ifdef SYS_poll
#ifdef __NR_poll
	{"poll", __NR_poll},
#endif
#endif
#ifdef SYS_ppoll
#ifdef __NR_ppoll
	{"ppoll", __NR_ppoll},
#endif
#endif
#ifdef SYS_prctl
#ifdef __NR_prctl
	{"prctl", __NR_prctl},
#endif
#endif
#ifdef SYS_pread64
#ifdef __NR_pread64
	{"pread64", __NR_pread64},
#endif
#endif
#ifdef SYS_preadv
#ifdef __NR_preadv
	{"preadv", __NR_preadv},
#endif
#endif
#ifdef SYS_preadv2
#ifdef __NR_preadv2
	{"preadv2", __NR_preadv2},
#endif
#endif
#ifdef SYS_prlimit64
#ifdef __NR_prlimit64
	{"prlimit64", __NR_prlimit64},
#endif
#endif
#ifdef SYS_process_vm_readv
#ifdef __NR_process_vm_readv
	{"process_vm_readv", __NR_process_vm_readv},
#endif
#endif
#ifdef SYS_process_vm_writev
#ifdef __NR_process_vm_writev
	{"process_vm_writev", __NR_process_vm_writev},
#endif
#endif
#ifdef SYS_prof
#ifdef __NR_prof
	{"prof", __NR_prof},
#endif
#endif
#ifdef SYS_profil
#ifdef __NR_profil
	{"profil", __NR_profil},
#endif
#endif
#ifdef SYS_pselect6
#ifdef __NR_pselect6
	{"pselect6", __NR_pselect6},
#endif
#endif
#ifdef SYS_ptrace
#ifdef __NR_ptrace
	{"ptrace", __NR_ptrace},
#endif
#endif
#ifdef SYS_putpmsg
#ifdef __NR_putpmsg
	{"putpmsg", __NR_putpmsg},
#endif
#endif
#ifdef SYS_pwrite64
#ifdef __NR_pwrite64
	{"pwrite64", __NR_pwrite64},
#endif
#endif
#ifdef SYS_pwritev
#ifdef __NR_pwritev
	{"pwritev", __NR_pwritev},
#endif
#endif
#ifdef SYS_pwritev2
#ifdef __NR_pwritev2
	{"pwritev2", __NR_pwritev2},
#endif
#endif
#ifdef SYS_query_module
#ifdef __NR_query_module
	{"query_module", __NR_query_module},
#endif
#endif
#ifdef SYS_quotactl
#ifdef __NR_quotactl
	{"quotactl", __NR_quotactl},
#endif
#endif
#ifdef SYS_read
#ifdef __NR_read
	{"read", __NR_read},
#endif
#endif
#ifdef SYS_readahead
#ifdef __NR_readahead
	{"readahead", __NR_readahead},
#endif
#endif
#ifdef SYS_readdir
#ifdef __NR_readdir
	{"readdir", __NR_readdir},
#endif
#endif
#ifdef SYS_readlink
#ifdef __NR_readlink
	{"readlink", __NR_readlink},
#endif
#endif
#ifdef SYS_readlinkat
#ifdef __NR_readlinkat
	{"readlinkat", __NR_readlinkat},
#endif
#endif
#ifdef SYS_readv
#ifdef __NR_readv
	{"readv", __NR_readv},
#endif
#endif
#ifdef SYS_reboot
#ifdef __NR_reboot
	{"reboot", __NR_reboot},
#endif
#endif
#ifdef SYS_recvfrom
#ifdef __NR_recvfrom
	{"recvfrom", __NR_recvfrom},
#endif
#endif
#ifdef SYS_recvmmsg
#ifdef __NR_recvmmsg
	{"recvmmsg", __NR_recvmmsg},
#endif
#endif
#ifdef SYS_recvmsg
#ifdef __NR_recvmsg
	{"recvmsg", __NR_recvmsg},
#endif
#endif
#ifdef SYS_remap_file_pages
#ifdef __NR_remap_file_pages
	{"remap_file_pages", __NR_remap_file_pages},
#endif
#endif
#ifdef SYS_removexattr
#ifdef __NR_removexattr
	{"removexattr", __NR_removexattr},
#endif
#endif
#ifdef SYS_rename
#ifdef __NR_rename
	{"rename", __NR_rename},
#endif
#endif
#ifdef SYS_renameat
#ifdef __NR_renameat
	{"renameat", __NR_renameat},
#endif
#endif
#ifdef SYS_renameat2
#ifdef __NR_renameat2
	{"renameat2", __NR_renameat2},
#endif
#endif
#ifdef SYS_request_key
#ifdef __NR_request_key
	{"request_key", __NR_request_key},
#endif
#endif
#ifdef SYS_restart_syscall
#ifdef __NR_restart_syscall
	{"restart_syscall", __NR_restart_syscall},
#endif
#endif
#ifdef SYS_rmdir
#ifdef __NR_rmdir
	{"rmdir", __NR_rmdir},
#endif
#endif
#ifdef SYS_rt_sigaction
#ifdef __NR_rt_sigaction
	{"rt_sigaction", __NR_rt_sigaction},
#endif
#endif
#ifdef SYS_rt_sigpending
#ifdef __NR_rt_sigpending
	{"rt_sigpending", __NR_rt_sigpending},
#endif
#endif
#ifdef SYS_rt_sigprocmask
#ifdef __NR_rt_sigprocmask
	{"rt_sigprocmask", __NR_rt_sigprocmask},
#endif
#endif
#ifdef SYS_rt_sigqueueinfo
#ifdef __NR_rt_sigqueueinfo
	{"rt_sigqueueinfo", __NR_rt_sigqueueinfo},
#endif
#endif
#ifdef SYS_rt_sigreturn
#ifdef __NR_rt_sigreturn
	{"rt_sigreturn", __NR_rt_sigreturn},
#endif
#endif
#ifdef SYS_rt_sigsuspend
#ifdef __NR_rt_sigsuspend
	{"rt_sigsuspend", __NR_rt_sigsuspend},
#endif
#endif
#ifdef SYS_rt_sigtimedwait
#ifdef __NR_rt_sigtimedwait
	{"rt_sigtimedwait", __NR_rt_sigtimedwait},
#endif
#endif
#ifdef SYS_rt_tgsigqueueinfo
#ifdef __NR_rt_tgsigqueueinfo
	{"rt_tgsigqueueinfo", __NR_rt_tgsigqueueinfo},
#endif
#endif
#ifdef SYS_sched_get_priority_max
#ifdef __NR_sched_get_priority_max
	{"sched_get_priority_max", __NR_sched_get_priority_max},
#endif
#endif
#ifdef SYS_sched_get_priority_min
#ifdef __NR_sched_get_priority_min
	{"sched_get_priority_min", __NR_sched_get_priority_min},
#endif
#endif
#ifdef SYS_sched_getaffinity
#ifdef __NR_sched_getaffinity
	{"sched_getaffinity", __NR_sched_getaffinity},
#endif
#endif
#ifdef SYS_sched_getattr
#ifdef __NR_sched_getattr
	{"sched_getattr", __NR_sched_getattr},
#endif
#endif
#ifdef SYS_sched_getparam
#ifdef __NR_sched_getparam
	{"sched_getparam", __NR_sched_getparam},
#endif
#endif
#ifdef SYS_sched_getscheduler
#ifdef __NR_sched_getscheduler
	{"sched_getscheduler", __NR_sched_getscheduler},
#endif
#endif
#ifdef SYS_sched_rr_get_interval
#ifdef __NR_sched_rr_get_interval
	{"sched_rr_get_interval", __NR_sched_rr_get_interval},
#endif
#endif
#ifdef SYS_sched_setaffinity
#ifdef __NR_sched_setaffinity
	{"sched_setaffinity", __NR_sched_setaffinity},
#endif
#endif
#ifdef SYS_sched_setattr
#ifdef __NR_sched_setattr
	{"sched_setattr", __NR_sched_setattr},
#endif
#endif
#ifdef SYS_sched_setparam
#ifdef __NR_sched_setparam
	{"sched_setparam", __NR_sched_setparam},
#endif
#endif
#ifdef SYS_sched_setscheduler
#ifdef __NR_sched_setscheduler
	{"sched_setscheduler", __NR_sched_setscheduler},
#endif
#endif
#ifdef SYS_sched_yield
#ifdef __NR_sched_yield
	{"sched_yield", __NR_sched_yield},
#endif
#endif
#ifdef SYS_seccomp
#ifdef __NR_seccomp
	{"seccomp", __NR_seccomp},
#endif
#endif
#ifdef SYS_select
#ifdef __NR_select
	{"select", __NR_select},
#endif
#endif
#ifdef SYS_sendfile
#ifdef __NR_sendfile
	{"sendfile", __NR_sendfile},
#endif
#endif
#ifdef SYS_sendfile64
#ifdef __NR_sendfile64
	{"sendfile64", __NR_sendfile64},
#endif
#endif
#ifdef SYS_sendmmsg
#ifdef __NR_sendmmsg
	{"sendmmsg", __NR_sendmmsg},
#endif
#endif
#ifdef SYS_sendmsg
#ifdef __NR_sendmsg
	{"sendmsg", __NR_sendmsg},
#endif
#endif
#ifdef SYS_sendto
#ifdef __NR_sendto
	{"sendto", __NR_sendto},
#endif
#endif
#ifdef SYS_set_mempolicy
#ifdef __NR_set_mempolicy
	{"set_mempolicy", __NR_set_mempolicy},
#endif
#endif
#ifdef SYS_set_robust_list
#ifdef __NR_set_robust_list
	{"set_robust_list", __NR_set_robust_list},
#endif
#endif
#ifdef SYS_set_thread_area
#ifdef __NR_set_thread_area
	{"set_thread_area", __NR_set_thread_area},
#endif
#endif
#ifdef SYS_set_tid_address
#ifdef __NR_set_tid_address
	{"set_tid_address", __NR_set_tid_address},
#endif
#endif
#ifdef SYS_setdomainname
#ifdef __NR_setdomainname
	{"setdomainname", __NR_setdomainname},
#endif
#endif
#ifdef SYS_setfsgid
#ifdef __NR_setfsgid
	{"setfsgid", __NR_setfsgid},
#endif
#endif
#ifdef SYS_setfsgid32
#ifdef __NR_setfsgid32
	{"setfsgid32", __NR_setfsgid32},
#endif
#endif
#ifdef SYS_setfsuid
#ifdef __NR_setfsuid
	{"setfsuid", __NR_setfsuid},
#endif
#endif
#ifdef SYS_setfsuid32
#ifdef __NR_setfsuid32
	{"setfsuid32", __NR_setfsuid32},
#endif
#endif
#ifdef SYS_setgid
#ifdef __NR_setgid
	{"setgid", __NR_setgid},
#endif
#endif
#ifdef SYS_setgid32
#ifdef __NR_setgid32
	{"setgid32", __NR_setgid32},
#endif
#endif
#ifdef SYS_setgroups
#ifdef __NR_setgroups
	{"setgroups", __NR_setgroups},
#endif
#endif
#ifdef SYS_setgroups32
#ifdef __NR_setgroups32
	{"setgroups32", __NR_setgroups32},
#endif
#endif
#ifdef SYS_sethostname
#ifdef __NR_sethostname
	{"sethostname", __NR_sethostname},
#endif
#endif
#ifdef SYS_setitimer
#ifdef __NR_setitimer
	{"setitimer", __NR_setitimer},
#endif
#endif
#ifdef SYS_setns
#ifdef __NR_setns
	{"setns", __NR_setns},
#endif
#endif
#ifdef SYS_setpgid
#ifdef __NR_setpgid
	{"setpgid", __NR_setpgid},
#endif
#endif
#ifdef SYS_setpriority
#ifdef __NR_setpriority
	{"setpriority", __NR_setpriority},
#endif
#endif
#ifdef SYS_setregid
#ifdef __NR_setregid
	{"setregid", __NR_setregid},
#endif
#endif
#ifdef SYS_setregid32
#ifdef __NR_setregid32
	{"setregid32", __NR_setregid32},
#endif
#endif
#ifdef SYS_setresgid
#ifdef __NR_setresgid
	{"setresgid", __NR_setresgid},
#endif
#endif
#ifdef SYS_setresgid32
#ifdef __NR_setresgid32
	{"setresgid32", __NR_setresgid32},
#endif
#endif
#ifdef SYS_setresuid
#ifdef __NR_setresuid
	{"setresuid", __NR_setresuid},
#endif
#endif
#ifdef SYS_setresuid32
#ifdef __NR_setresuid32
	{"setresuid32", __NR_setresuid32},
#endif
#endif
#ifdef SYS_setreuid
#ifdef __NR_setreuid
	{"setreuid", __NR_setreuid},
#endif
#endif
#ifdef SYS_setreuid32
#ifdef __NR_setreuid32
	{"setreuid32", __NR_setreuid32},
#endif
#endif
#ifdef SYS_setrlimit
#ifdef __NR_setrlimit
	{"setrlimit", __NR_setrlimit},
#endif
#endif
#ifdef SYS_setsid
#ifdef __NR_setsid
	{"setsid", __NR_setsid},
#endif
#endif
#ifdef SYS_setsockopt
#ifdef __NR_setsockopt
	{"setsockopt", __NR_setsockopt},
#endif
#endif
#ifdef SYS_settimeofday
#ifdef __NR_settimeofday
	{"settimeofday", __NR_settimeofday},
#endif
#endif
#ifdef SYS_setuid
#ifdef __NR_setuid
	{"setuid", __NR_setuid},
#endif
#endif
#ifdef SYS_setuid32
#ifdef __NR_setuid32
	{"setuid32", __NR_setuid32},
#endif
#endif
#ifdef SYS_setxattr
#ifdef __NR_setxattr
	{"setxattr", __NR_setxattr},
#endif
#endif
#ifdef SYS_sgetmask
#ifdef __NR_sgetmask
	{"sgetmask", __NR_sgetmask},
#endif
#endif
#ifdef SYS_shutdown
#ifdef __NR_shutdown
	{"shutdown", __NR_shutdown},
#endif
#endif
#ifdef SYS_sigaction
#ifdef __NR_sigaction
	{"sigaction", __NR_sigaction},
#endif
#endif
#ifdef SYS_sigaltstack
#ifdef __NR_sigaltstack
	{"sigaltstack", __NR_sigaltstack},
#endif
#endif
#ifdef SYS_signal
#ifdef __NR_signal
	{"signal", __NR_signal},
#endif
#endif
#ifdef SYS_signalfd
#ifdef __NR_signalfd
	{"signalfd", __NR_signalfd},
#endif
#endif
#ifdef SYS_signalfd4
#ifdef __NR_signalfd4
	{"signalfd4", __NR_signalfd4},
#endif
#endif
#ifdef SYS_sigpending
#ifdef __NR_sigpending
	{"sigpending", __NR_sigpending},
#endif
#endif
#ifdef SYS_sigprocmask
#ifdef __NR_sigprocmask
	{"sigprocmask", __NR_sigprocmask},
#endif
#endif
#ifdef SYS_sigreturn
#ifdef __NR_sigreturn
	{"sigreturn", __NR_sigreturn},
#endif
#endif
#ifdef SYS_sigsuspend
#ifdef __NR_sigsuspend
	{"sigsuspend", __NR_sigsuspend},
#endif
#endif
#ifdef SYS_socket
#ifdef __NR_socket
	{"socket", __NR_socket},
#endif
#endif
#ifdef SYS_socketcall
#ifdef __NR_socketcall
	{"socketcall", __NR_socketcall},
#endif
#endif
#ifdef SYS_socketpair
#ifdef __NR_socketpair
	{"socketpair", __NR_socketpair},
#endif
#endif
#ifdef SYS_splice
#ifdef __NR_splice
	{"splice", __NR_splice},
#endif
#endif
#ifdef SYS_ssetmask
#ifdef __NR_ssetmask
	{"ssetmask", __NR_ssetmask},
#endif
#endif
#ifdef SYS_stat
#ifdef __NR_stat
	{"stat", __NR_stat},
#endif
#endif
#ifdef SYS_stat64
#ifdef __NR_stat64
	{"stat64", __NR_stat64},
#endif
#endif
#ifdef SYS_statfs
#ifdef __NR_statfs
	{"statfs", __NR_statfs},
#endif
#endif
#ifdef SYS_statfs64
#ifdef __NR_statfs64
	{"statfs64", __NR_statfs64},
#endif
#endif
#ifdef SYS_statx
#ifdef __NR_statx
	{"statx", __NR_statx},
#endif
#endif
#ifdef SYS_stime
#ifdef __NR_stime
	{"stime", __NR_stime},
#endif
#endif
#ifdef SYS_stty
#ifdef __NR_stty
	{"stty", __NR_stty},
#endif
#endif
#ifdef SYS_swapoff
#ifdef __NR_swapoff
	{"swapoff", __NR_swapoff},
#endif
#endif
#ifdef SYS_swapon
#ifdef __NR_swapon
	{"swapon", __NR_swapon},
#endif
#endif
#ifdef SYS_symlink
#ifdef __NR_symlink
	{"symlink", __NR_symlink},
#endif
#endif
#ifdef SYS_symlinkat
#ifdef __NR_symlinkat
	{"symlinkat", __NR_symlinkat},
#endif
#endif
#ifdef SYS_sync
#ifdef __NR_sync
	{"sync", __NR_sync},
#endif
#endif
#ifdef SYS_sync_file_range
#ifdef __NR_sync_file_range
	{"sync_file_range", __NR_sync_file_range},
#endif
#endif
#ifdef SYS_syncfs
#ifdef __NR_syncfs
	{"syncfs", __NR_syncfs},
#endif
#endif
#ifdef SYS_sysfs
#ifdef __NR_sysfs
	{"sysfs", __NR_sysfs},
#endif
#endif
#ifdef SYS_sysinfo
#ifdef __NR_sysinfo
	{"sysinfo", __NR_sysinfo},
#endif
#endif
#ifdef SYS_syslog
#ifdef __NR_syslog
	{"syslog", __NR_syslog},
#endif
#endif
#ifdef SYS_tee
#ifdef __NR_tee
	{"tee", __NR_tee},
#endif
#endif
#ifdef SYS_tgkill
#ifdef __NR_tgkill
	{"tgkill", __NR_tgkill},
#endif
#endif
#ifdef SYS_time
#ifdef __NR_time
	{"time", __NR_time},
#endif
#endif
#ifdef SYS_timer_create
#ifdef __NR_timer_create
	{"timer_create", __NR_timer_create},
#endif
#endif
#ifdef SYS_timer_delete
#ifdef __NR_timer_delete
	{"timer_delete", __NR_timer_delete},
#endif
#endif
#ifdef SYS_timer_getoverrun
#ifdef __NR_timer_getoverrun
	{"timer_getoverrun", __NR_timer_getoverrun},
#endif
#endif
#ifdef SYS_timer_gettime
#ifdef __NR_timer_gettime
	{"timer_gettime", __NR_timer_gettime},
#endif
#endif
#ifdef SYS_timer_settime
#ifdef __NR_timer_settime
	{"timer_settime", __NR_timer_settime},
#endif
#endif
#ifdef SYS_timerfd_create
#ifdef __NR_timerfd_create
	{"timerfd_create", __NR_timerfd_create},
#endif
#endif
#ifdef SYS_timerfd_gettime
#ifdef __NR_timerfd_gettime
	{"timerfd_gettime", __NR_timerfd_gettime},
#endif
#endif
#ifdef SYS_timerfd_settime
#ifdef __NR_timerfd_settime
	{"timerfd_settime", __NR_timerfd_settime},
#endif
#endif
#ifdef SYS_times
#ifdef __NR_times
	{"times", __NR_times},
#endif
#endif
#ifdef SYS_tkill
#ifdef __NR_tkill
	{"tkill", __NR_tkill},
#endif
#endif
#ifdef SYS_truncate
#ifdef __NR_truncate
	{"truncate", __NR_truncate},
#endif
#endif
#ifdef SYS_truncate64
#ifdef __NR_truncate64
	{"truncate64", __NR_truncate64},
#endif
#endif
#ifdef SYS_ugetrlimit
#ifdef __NR_ugetrlimit
	{"ugetrlimit", __NR_ugetrlimit},
#endif
#endif
#ifdef SYS_ulimit
#ifdef __NR_ulimit
	{"ulimit", __NR_ulimit},
#endif
#endif
#ifdef SYS_umask
#ifdef __NR_umask
	{"umask", __NR_umask},
#endif
#endif
#ifdef SYS_umount
#ifdef __NR_umount
	{"umount", __NR_umount},
#endif
#endif
#ifdef SYS_umount2
#ifdef __NR_umount2
	{"umount2", __NR_umount2},
#endif
#endif
#ifdef SYS_uname
#ifdef __NR_uname
	{"uname", __NR_uname},
#endif
#endif
#ifdef SYS_unlink
#ifdef __NR_unlink
	{"unlink", __NR_unlink},
#endif
#endif
#ifdef SYS_unlinkat
#ifdef __NR_unlinkat
	{"unlinkat", __NR_unlinkat},
#endif
#endif
#ifdef SYS_unshare
#ifdef __NR_unshare
	{"unshare", __NR_unshare},
#endif
#endif
#ifdef SYS_uselib
#ifdef __NR_uselib
	{"uselib", __NR_uselib},
#endif
#endif
#ifdef SYS_userfaultfd
#ifdef __NR_userfaultfd
	{"userfaultfd", __NR_userfaultfd},
#endif
#endif
#ifdef SYS_ustat
#ifdef __NR_ustat
	{"ustat", __NR_ustat},
#endif
#endif
#ifdef SYS_utime
#ifdef __NR_utime
	{"utime", __NR_utime},
#endif
#endif
#ifdef SYS_utimensat
#ifdef __NR_utimensat
	{"utimensat", __NR_utimensat},
#endif
#endif
#ifdef SYS_utimes
#ifdef __NR_utimes
	{"utimes", __NR_utimes},
#endif
#endif
#ifdef SYS_vfork
#ifdef __NR_vfork
	{"vfork", __NR_vfork},
#endif
#endif
#ifdef SYS_vhangup
#ifdef __NR_vhangup
	{"vhangup", __NR_vhangup},
#endif
#endif
#ifdef SYS_vm86
#ifdef __NR_vm86
	{"vm86", __NR_vm86},
#endif
#endif
#ifdef SYS_vm86old
#ifdef __NR_vm86old
	{"vm86old", __NR_vm86old},
#endif
#endif
#ifdef SYS_vmsplice
#ifdef __NR_vmsplice
	{"vmsplice", __NR_vmsplice},
#endif
#endif
#ifdef SYS_vserver
#ifdef __NR_vserver
	{"vserver", __NR_vserver},
#endif
#endif
#ifdef SYS_wait4
#ifdef __NR_wait4
	{"wait4", __NR_wait4},
#endif
#endif
#ifdef SYS_waitid
#ifdef __NR_waitid
	{"waitid", __NR_waitid},
#endif
#endif
#ifdef SYS_waitpid
#ifdef __NR_waitpid
	{"waitpid", __NR_waitpid},
#endif
#endif
#ifdef SYS_write
#ifdef __NR_write
	{"write", __NR_write},
#endif
#endif
#ifdef SYS_writev
#ifdef __NR_writev
	{"writev", __NR_writev},
#endif
#endif
#endif
//#endif
#if defined __x86_64__ && defined __LP64__
#ifdef SYS__sysctl
#ifdef __NR__sysctl
	{"_sysctl", __NR__sysctl},
#endif
#endif
#ifdef SYS_accept
#ifdef __NR_accept
	{"accept", __NR_accept},
#endif
#endif
#ifdef SYS_accept4
#ifdef __NR_accept4
	{"accept4", __NR_accept4},
#endif
#endif
#ifdef SYS_access
#ifdef __NR_access
	{"access", __NR_access},
#endif
#endif
#ifdef SYS_acct
#ifdef __NR_acct
	{"acct", __NR_acct},
#endif
#endif
#ifdef SYS_add_key
#ifdef __NR_add_key
	{"add_key", __NR_add_key},
#endif
#endif
#ifdef SYS_adjtimex
#ifdef __NR_adjtimex
	{"adjtimex", __NR_adjtimex},
#endif
#endif
#ifdef SYS_afs_syscall
#ifdef __NR_afs_syscall
	{"afs_syscall", __NR_afs_syscall},
#endif
#endif
#ifdef SYS_alarm
#ifdef __NR_alarm
	{"alarm", __NR_alarm},
#endif
#endif
#ifdef SYS_arch_prctl
#ifdef __NR_arch_prctl
	{"arch_prctl", __NR_arch_prctl},
#endif
#endif
#ifdef SYS_bind
#ifdef __NR_bind
	{"bind", __NR_bind},
#endif
#endif
#ifdef SYS_bpf
#ifdef __NR_bpf
	{"bpf", __NR_bpf},
#endif
#endif
#ifdef SYS_brk
#ifdef __NR_brk
	{"brk", __NR_brk},
#endif
#endif
#ifdef SYS_capget
#ifdef __NR_capget
	{"capget", __NR_capget},
#endif
#endif
#ifdef SYS_capset
#ifdef __NR_capset
	{"capset", __NR_capset},
#endif
#endif
#ifdef SYS_chdir
#ifdef __NR_chdir
	{"chdir", __NR_chdir},
#endif
#endif
#ifdef SYS_chmod
#ifdef __NR_chmod
	{"chmod", __NR_chmod},
#endif
#endif
#ifdef SYS_chown
#ifdef __NR_chown
	{"chown", __NR_chown},
#endif
#endif
#ifdef SYS_chroot
#ifdef __NR_chroot
	{"chroot", __NR_chroot},
#endif
#endif
#ifdef SYS_clock_adjtime
#ifdef __NR_clock_adjtime
	{"clock_adjtime", __NR_clock_adjtime},
#endif
#endif
#ifdef SYS_clock_getres
#ifdef __NR_clock_getres
	{"clock_getres", __NR_clock_getres},
#endif
#endif
#ifdef SYS_clock_gettime
#ifdef __NR_clock_gettime
	{"clock_gettime", __NR_clock_gettime},
#endif
#endif
#ifdef SYS_clock_nanosleep
#ifdef __NR_clock_nanosleep
	{"clock_nanosleep", __NR_clock_nanosleep},
#endif
#endif
#ifdef SYS_clock_settime
#ifdef __NR_clock_settime
	{"clock_settime", __NR_clock_settime},
#endif
#endif
#ifdef SYS_clone
#ifdef __NR_clone
	{"clone", __NR_clone},
#endif
#endif
#ifdef SYS_close
#ifdef __NR_close
	{"close", __NR_close},
#endif
#endif
#ifdef SYS_connect
#ifdef __NR_connect
	{"connect", __NR_connect},
#endif
#endif
#ifdef SYS_copy_file_range
#ifdef __NR_copy_file_range
	{"copy_file_range", __NR_copy_file_range},
#endif
#endif
#ifdef SYS_creat
#ifdef __NR_creat
	{"creat", __NR_creat},
#endif
#endif
#ifdef SYS_create_module
#ifdef __NR_create_module
	{"create_module", __NR_create_module},
#endif
#endif
#ifdef SYS_delete_module
#ifdef __NR_delete_module
	{"delete_module", __NR_delete_module},
#endif
#endif
#ifdef SYS_dup
#ifdef __NR_dup
	{"dup", __NR_dup},
#endif
#endif
#ifdef SYS_dup2
#ifdef __NR_dup2
	{"dup2", __NR_dup2},
#endif
#endif
#ifdef SYS_dup3
#ifdef __NR_dup3
	{"dup3", __NR_dup3},
#endif
#endif
#ifdef SYS_epoll_create
#ifdef __NR_epoll_create
	{"epoll_create", __NR_epoll_create},
#endif
#endif
#ifdef SYS_epoll_create1
#ifdef __NR_epoll_create1
	{"epoll_create1", __NR_epoll_create1},
#endif
#endif
#ifdef SYS_epoll_ctl
#ifdef __NR_epoll_ctl
	{"epoll_ctl", __NR_epoll_ctl},
#endif
#endif
#ifdef SYS_epoll_ctl_old
#ifdef __NR_epoll_ctl_old
	{"epoll_ctl_old", __NR_epoll_ctl_old},
#endif
#endif
#ifdef SYS_epoll_pwait
#ifdef __NR_epoll_pwait
	{"epoll_pwait", __NR_epoll_pwait},
#endif
#endif
#ifdef SYS_epoll_wait
#ifdef __NR_epoll_wait
	{"epoll_wait", __NR_epoll_wait},
#endif
#endif
#ifdef SYS_epoll_wait_old
#ifdef __NR_epoll_wait_old
	{"epoll_wait_old", __NR_epoll_wait_old},
#endif
#endif
#ifdef SYS_eventfd
#ifdef __NR_eventfd
	{"eventfd", __NR_eventfd},
#endif
#endif
#ifdef SYS_eventfd2
#ifdef __NR_eventfd2
	{"eventfd2", __NR_eventfd2},
#endif
#endif
#ifdef SYS_execve
#ifdef __NR_execve
	{"execve", __NR_execve},
#endif
#endif
#ifdef SYS_execveat
#ifdef __NR_execveat
	{"execveat", __NR_execveat},
#endif
#endif
#ifdef SYS_exit
#ifdef __NR_exit
	{"exit", __NR_exit},
#endif
#endif
#ifdef SYS_exit_group
#ifdef __NR_exit_group
	{"exit_group", __NR_exit_group},
#endif
#endif
#ifdef SYS_faccessat
#ifdef __NR_faccessat
	{"faccessat", __NR_faccessat},
#endif
#endif
#ifdef SYS_fadvise64
#ifdef __NR_fadvise64
	{"fadvise64", __NR_fadvise64},
#endif
#endif
#ifdef SYS_fallocate
#ifdef __NR_fallocate
	{"fallocate", __NR_fallocate},
#endif
#endif
#ifdef SYS_fanotify_init
#ifdef __NR_fanotify_init
	{"fanotify_init", __NR_fanotify_init},
#endif
#endif
#ifdef SYS_fanotify_mark
#ifdef __NR_fanotify_mark
	{"fanotify_mark", __NR_fanotify_mark},
#endif
#endif
#ifdef SYS_fchdir
#ifdef __NR_fchdir
	{"fchdir", __NR_fchdir},
#endif
#endif
#ifdef SYS_fchmod
#ifdef __NR_fchmod
	{"fchmod", __NR_fchmod},
#endif
#endif
#ifdef SYS_fchmodat
#ifdef __NR_fchmodat
	{"fchmodat", __NR_fchmodat},
#endif
#endif
#ifdef SYS_fchown
#ifdef __NR_fchown
	{"fchown", __NR_fchown},
#endif
#endif
#ifdef SYS_fchownat
#ifdef __NR_fchownat
	{"fchownat", __NR_fchownat},
#endif
#endif
#ifdef SYS_fcntl
#ifdef __NR_fcntl
	{"fcntl", __NR_fcntl},
#endif
#endif
#ifdef SYS_fdatasync
#ifdef __NR_fdatasync
	{"fdatasync", __NR_fdatasync},
#endif
#endif
#ifdef SYS_fgetxattr
#ifdef __NR_fgetxattr
	{"fgetxattr", __NR_fgetxattr},
#endif
#endif
#ifdef SYS_finit_module
#ifdef __NR_finit_module
	{"finit_module", __NR_finit_module},
#endif
#endif
#ifdef SYS_flistxattr
#ifdef __NR_flistxattr
	{"flistxattr", __NR_flistxattr},
#endif
#endif
#ifdef SYS_flock
#ifdef __NR_flock
	{"flock", __NR_flock},
#endif
#endif
#ifdef SYS_fork
#ifdef __NR_fork
	{"fork", __NR_fork},
#endif
#endif
#ifdef SYS_fremovexattr
#ifdef __NR_fremovexattr
	{"fremovexattr", __NR_fremovexattr},
#endif
#endif
#ifdef SYS_fsetxattr
#ifdef __NR_fsetxattr
	{"fsetxattr", __NR_fsetxattr},
#endif
#endif
#ifdef SYS_fstat
#ifdef __NR_fstat
	{"fstat", __NR_fstat},
#endif
#endif
#ifdef SYS_fstatfs
#ifdef __NR_fstatfs
	{"fstatfs", __NR_fstatfs},
#endif
#endif
#ifdef SYS_fsync
#ifdef __NR_fsync
	{"fsync", __NR_fsync},
#endif
#endif
#ifdef SYS_ftruncate
#ifdef __NR_ftruncate
	{"ftruncate", __NR_ftruncate},
#endif
#endif
#ifdef SYS_futex
#ifdef __NR_futex
	{"futex", __NR_futex},
#endif
#endif
#ifdef SYS_futimesat
#ifdef __NR_futimesat
	{"futimesat", __NR_futimesat},
#endif
#endif
#ifdef SYS_get_kernel_syms
#ifdef __NR_get_kernel_syms
	{"get_kernel_syms", __NR_get_kernel_syms},
#endif
#endif
#ifdef SYS_get_mempolicy
#ifdef __NR_get_mempolicy
	{"get_mempolicy", __NR_get_mempolicy},
#endif
#endif
#ifdef SYS_get_robust_list
#ifdef __NR_get_robust_list
	{"get_robust_list", __NR_get_robust_list},
#endif
#endif
#ifdef SYS_get_thread_area
#ifdef __NR_get_thread_area
	{"get_thread_area", __NR_get_thread_area},
#endif
#endif
#ifdef SYS_getcpu
#ifdef __NR_getcpu
	{"getcpu", __NR_getcpu},
#endif
#endif
#ifdef SYS_getcwd
#ifdef __NR_getcwd
	{"getcwd", __NR_getcwd},
#endif
#endif
#ifdef SYS_getdents
#ifdef __NR_getdents
	{"getdents", __NR_getdents},
#endif
#endif
#ifdef SYS_getdents64
#ifdef __NR_getdents64
	{"getdents64", __NR_getdents64},
#endif
#endif
#ifdef SYS_getegid
#ifdef __NR_getegid
	{"getegid", __NR_getegid},
#endif
#endif
#ifdef SYS_geteuid
#ifdef __NR_geteuid
	{"geteuid", __NR_geteuid},
#endif
#endif
#ifdef SYS_getgid
#ifdef __NR_getgid
	{"getgid", __NR_getgid},
#endif
#endif
#ifdef SYS_getgroups
#ifdef __NR_getgroups
	{"getgroups", __NR_getgroups},
#endif
#endif
#ifdef SYS_getitimer
#ifdef __NR_getitimer
	{"getitimer", __NR_getitimer},
#endif
#endif
#ifdef SYS_getpeername
#ifdef __NR_getpeername
	{"getpeername", __NR_getpeername},
#endif
#endif
#ifdef SYS_getpgid
#ifdef __NR_getpgid
	{"getpgid", __NR_getpgid},
#endif
#endif
#ifdef SYS_getpgrp
#ifdef __NR_getpgrp
	{"getpgrp", __NR_getpgrp},
#endif
#endif
#ifdef SYS_getpid
#ifdef __NR_getpid
	{"getpid", __NR_getpid},
#endif
#endif
#ifdef SYS_getpmsg
#ifdef __NR_getpmsg
	{"getpmsg", __NR_getpmsg},
#endif
#endif
#ifdef SYS_getppid
#ifdef __NR_getppid
	{"getppid", __NR_getppid},
#endif
#endif
#ifdef SYS_getpriority
#ifdef __NR_getpriority
	{"getpriority", __NR_getpriority},
#endif
#endif
#ifdef SYS_getrandom
#ifdef __NR_getrandom
	{"getrandom", __NR_getrandom},
#endif
#endif
#ifdef SYS_getresgid
#ifdef __NR_getresgid
	{"getresgid", __NR_getresgid},
#endif
#endif
#ifdef SYS_getresuid
#ifdef __NR_getresuid
	{"getresuid", __NR_getresuid},
#endif
#endif
#ifdef SYS_getrlimit
#ifdef __NR_getrlimit
	{"getrlimit", __NR_getrlimit},
#endif
#endif
#ifdef SYS_getrusage
#ifdef __NR_getrusage
	{"getrusage", __NR_getrusage},
#endif
#endif
#ifdef SYS_getsid
#ifdef __NR_getsid
	{"getsid", __NR_getsid},
#endif
#endif
#ifdef SYS_getsockname
#ifdef __NR_getsockname
	{"getsockname", __NR_getsockname},
#endif
#endif
#ifdef SYS_getsockopt
#ifdef __NR_getsockopt
	{"getsockopt", __NR_getsockopt},
#endif
#endif
#ifdef SYS_gettid
#ifdef __NR_gettid
	{"gettid", __NR_gettid},
#endif
#endif
#ifdef SYS_gettimeofday
#ifdef __NR_gettimeofday
	{"gettimeofday", __NR_gettimeofday},
#endif
#endif
#ifdef SYS_getuid
#ifdef __NR_getuid
	{"getuid", __NR_getuid},
#endif
#endif
#ifdef SYS_getxattr
#ifdef __NR_getxattr
	{"getxattr", __NR_getxattr},
#endif
#endif
#ifdef SYS_init_module
#ifdef __NR_init_module
	{"init_module", __NR_init_module},
#endif
#endif
#ifdef SYS_inotify_add_watch
#ifdef __NR_inotify_add_watch
	{"inotify_add_watch", __NR_inotify_add_watch},
#endif
#endif
#ifdef SYS_inotify_init
#ifdef __NR_inotify_init
	{"inotify_init", __NR_inotify_init},
#endif
#endif
#ifdef SYS_inotify_init1
#ifdef __NR_inotify_init1
	{"inotify_init1", __NR_inotify_init1},
#endif
#endif
#ifdef SYS_inotify_rm_watch
#ifdef __NR_inotify_rm_watch
	{"inotify_rm_watch", __NR_inotify_rm_watch},
#endif
#endif
#ifdef SYS_io_cancel
#ifdef __NR_io_cancel
	{"io_cancel", __NR_io_cancel},
#endif
#endif
#ifdef SYS_io_destroy
#ifdef __NR_io_destroy
	{"io_destroy", __NR_io_destroy},
#endif
#endif
#ifdef SYS_io_getevents
#ifdef __NR_io_getevents
	{"io_getevents", __NR_io_getevents},
#endif
#endif
#ifdef SYS_io_setup
#ifdef __NR_io_setup
	{"io_setup", __NR_io_setup},
#endif
#endif
#ifdef SYS_io_submit
#ifdef __NR_io_submit
	{"io_submit", __NR_io_submit},
#endif
#endif
#ifdef SYS_ioctl
#ifdef __NR_ioctl
	{"ioctl", __NR_ioctl},
#endif
#endif
#ifdef SYS_ioperm
#ifdef __NR_ioperm
	{"ioperm", __NR_ioperm},
#endif
#endif
#ifdef SYS_iopl
#ifdef __NR_iopl
	{"iopl", __NR_iopl},
#endif
#endif
#ifdef SYS_ioprio_get
#ifdef __NR_ioprio_get
	{"ioprio_get", __NR_ioprio_get},
#endif
#endif
#ifdef SYS_ioprio_set
#ifdef __NR_ioprio_set
	{"ioprio_set", __NR_ioprio_set},
#endif
#endif
#ifdef SYS_kcmp
#ifdef __NR_kcmp
	{"kcmp", __NR_kcmp},
#endif
#endif
#ifdef SYS_kexec_file_load
#ifdef __NR_kexec_file_load
	{"kexec_file_load", __NR_kexec_file_load},
#endif
#endif
#ifdef SYS_kexec_load
#ifdef __NR_kexec_load
	{"kexec_load", __NR_kexec_load},
#endif
#endif
#ifdef SYS_keyctl
#ifdef __NR_keyctl
	{"keyctl", __NR_keyctl},
#endif
#endif
#ifdef SYS_kill
#ifdef __NR_kill
	{"kill", __NR_kill},
#endif
#endif
#ifdef SYS_lchown
#ifdef __NR_lchown
	{"lchown", __NR_lchown},
#endif
#endif
#ifdef SYS_lgetxattr
#ifdef __NR_lgetxattr
	{"lgetxattr", __NR_lgetxattr},
#endif
#endif
#ifdef SYS_link
#ifdef __NR_link
	{"link", __NR_link},
#endif
#endif
#ifdef SYS_linkat
#ifdef __NR_linkat
	{"linkat", __NR_linkat},
#endif
#endif
#ifdef SYS_listen
#ifdef __NR_listen
	{"listen", __NR_listen},
#endif
#endif
#ifdef SYS_listxattr
#ifdef __NR_listxattr
	{"listxattr", __NR_listxattr},
#endif
#endif
#ifdef SYS_llistxattr
#ifdef __NR_llistxattr
	{"llistxattr", __NR_llistxattr},
#endif
#endif
#ifdef SYS_lookup_dcookie
#ifdef __NR_lookup_dcookie
	{"lookup_dcookie", __NR_lookup_dcookie},
#endif
#endif
#ifdef SYS_lremovexattr
#ifdef __NR_lremovexattr
	{"lremovexattr", __NR_lremovexattr},
#endif
#endif
#ifdef SYS_lseek
#ifdef __NR_lseek
	{"lseek", __NR_lseek},
#endif
#endif
#ifdef SYS_lsetxattr
#ifdef __NR_lsetxattr
	{"lsetxattr", __NR_lsetxattr},
#endif
#endif
#ifdef SYS_lstat
#ifdef __NR_lstat
	{"lstat", __NR_lstat},
#endif
#endif
#ifdef SYS_madvise
#ifdef __NR_madvise
	{"madvise", __NR_madvise},
#endif
#endif
#ifdef SYS_mbind
#ifdef __NR_mbind
	{"mbind", __NR_mbind},
#endif
#endif
#ifdef SYS_membarrier
#ifdef __NR_membarrier
	{"membarrier", __NR_membarrier},
#endif
#endif
#ifdef SYS_memfd_create
#ifdef __NR_memfd_create
	{"memfd_create", __NR_memfd_create},
#endif
#endif
#ifdef SYS_migrate_pages
#ifdef __NR_migrate_pages
	{"migrate_pages", __NR_migrate_pages},
#endif
#endif
#ifdef SYS_mincore
#ifdef __NR_mincore
	{"mincore", __NR_mincore},
#endif
#endif
#ifdef SYS_mkdir
#ifdef __NR_mkdir
	{"mkdir", __NR_mkdir},
#endif
#endif
#ifdef SYS_mkdirat
#ifdef __NR_mkdirat
	{"mkdirat", __NR_mkdirat},
#endif
#endif
#ifdef SYS_mknod
#ifdef __NR_mknod
	{"mknod", __NR_mknod},
#endif
#endif
#ifdef SYS_mknodat
#ifdef __NR_mknodat
	{"mknodat", __NR_mknodat},
#endif
#endif
#ifdef SYS_mlock
#ifdef __NR_mlock
	{"mlock", __NR_mlock},
#endif
#endif
#ifdef SYS_mlock2
#ifdef __NR_mlock2
	{"mlock2", __NR_mlock2},
#endif
#endif
#ifdef SYS_mlockall
#ifdef __NR_mlockall
	{"mlockall", __NR_mlockall},
#endif
#endif
#ifdef SYS_mmap
#ifdef __NR_mmap
	{"mmap", __NR_mmap},
#endif
#endif
#ifdef SYS_modify_ldt
#ifdef __NR_modify_ldt
	{"modify_ldt", __NR_modify_ldt},
#endif
#endif
#ifdef SYS_mount
#ifdef __NR_mount
	{"mount", __NR_mount},
#endif
#endif
#ifdef SYS_move_pages
#ifdef __NR_move_pages
	{"move_pages", __NR_move_pages},
#endif
#endif
#ifdef SYS_mprotect
#ifdef __NR_mprotect
	{"mprotect", __NR_mprotect},
#endif
#endif
#ifdef SYS_mq_getsetattr
#ifdef __NR_mq_getsetattr
	{"mq_getsetattr", __NR_mq_getsetattr},
#endif
#endif
#ifdef SYS_mq_notify
#ifdef __NR_mq_notify
	{"mq_notify", __NR_mq_notify},
#endif
#endif
#ifdef SYS_mq_open
#ifdef __NR_mq_open
	{"mq_open", __NR_mq_open},
#endif
#endif
#ifdef SYS_mq_timedreceive
#ifdef __NR_mq_timedreceive
	{"mq_timedreceive", __NR_mq_timedreceive},
#endif
#endif
#ifdef SYS_mq_timedsend
#ifdef __NR_mq_timedsend
	{"mq_timedsend", __NR_mq_timedsend},
#endif
#endif
#ifdef SYS_mq_unlink
#ifdef __NR_mq_unlink
	{"mq_unlink", __NR_mq_unlink},
#endif
#endif
#ifdef SYS_mremap
#ifdef __NR_mremap
	{"mremap", __NR_mremap},
#endif
#endif
#ifdef SYS_msgctl
#ifdef __NR_msgctl
	{"msgctl", __NR_msgctl},
#endif
#endif
#ifdef SYS_msgget
#ifdef __NR_msgget
	{"msgget", __NR_msgget},
#endif
#endif
#ifdef SYS_msgrcv
#ifdef __NR_msgrcv
	{"msgrcv", __NR_msgrcv},
#endif
#endif
#ifdef SYS_msgsnd
#ifdef __NR_msgsnd
	{"msgsnd", __NR_msgsnd},
#endif
#endif
#ifdef SYS_msync
#ifdef __NR_msync
	{"msync", __NR_msync},
#endif
#endif
#ifdef SYS_munlock
#ifdef __NR_munlock
	{"munlock", __NR_munlock},
#endif
#endif
#ifdef SYS_munlockall
#ifdef __NR_munlockall
	{"munlockall", __NR_munlockall},
#endif
#endif
#ifdef SYS_munmap
#ifdef __NR_munmap
	{"munmap", __NR_munmap},
#endif
#endif
#ifdef SYS_name_to_handle_at
#ifdef __NR_name_to_handle_at
	{"name_to_handle_at", __NR_name_to_handle_at},
#endif
#endif
#ifdef SYS_nanosleep
#ifdef __NR_nanosleep
	{"nanosleep", __NR_nanosleep},
#endif
#endif
#ifdef SYS_newfstatat
#ifdef __NR_newfstatat
	{"newfstatat", __NR_newfstatat},
#endif
#endif
#ifdef SYS_nfsservctl
#ifdef __NR_nfsservctl
	{"nfsservctl", __NR_nfsservctl},
#endif
#endif
#ifdef SYS_open
#ifdef __NR_open
	{"open", __NR_open},
#endif
#endif
#ifdef SYS_open_by_handle_at
#ifdef __NR_open_by_handle_at
	{"open_by_handle_at", __NR_open_by_handle_at},
#endif
#endif
#ifdef SYS_openat
#ifdef __NR_openat
	{"openat", __NR_openat},
#endif
#endif
#ifdef SYS_pause
#ifdef __NR_pause
	{"pause", __NR_pause},
#endif
#endif
#ifdef SYS_perf_event_open
#ifdef __NR_perf_event_open
	{"perf_event_open", __NR_perf_event_open},
#endif
#endif
#ifdef SYS_personality
#ifdef __NR_personality
	{"personality", __NR_personality},
#endif
#endif
#ifdef SYS_pipe
#ifdef __NR_pipe
	{"pipe", __NR_pipe},
#endif
#endif
#ifdef SYS_pipe2
#ifdef __NR_pipe2
	{"pipe2", __NR_pipe2},
#endif
#endif
#ifdef SYS_pivot_root
#ifdef __NR_pivot_root
	{"pivot_root", __NR_pivot_root},
#endif
#endif
#ifdef SYS_pkey_alloc
#ifdef __NR_pkey_alloc
	{"pkey_alloc", __NR_pkey_alloc},
#endif
#endif
#ifdef SYS_pkey_free
#ifdef __NR_pkey_free
	{"pkey_free", __NR_pkey_free},
#endif
#endif
#ifdef SYS_pkey_mprotect
#ifdef __NR_pkey_mprotect
	{"pkey_mprotect", __NR_pkey_mprotect},
#endif
#endif
#ifdef SYS_poll
#ifdef __NR_poll
	{"poll", __NR_poll},
#endif
#endif
#ifdef SYS_ppoll
#ifdef __NR_ppoll
	{"ppoll", __NR_ppoll},
#endif
#endif
#ifdef SYS_prctl
#ifdef __NR_prctl
	{"prctl", __NR_prctl},
#endif
#endif
#ifdef SYS_pread64
#ifdef __NR_pread64
	{"pread64", __NR_pread64},
#endif
#endif
#ifdef SYS_preadv
#ifdef __NR_preadv
	{"preadv", __NR_preadv},
#endif
#endif
#ifdef SYS_preadv2
#ifdef __NR_preadv2
	{"preadv2", __NR_preadv2},
#endif
#endif
#ifdef SYS_prlimit64
#ifdef __NR_prlimit64
	{"prlimit64", __NR_prlimit64},
#endif
#endif
#ifdef SYS_process_vm_readv
#ifdef __NR_process_vm_readv
	{"process_vm_readv", __NR_process_vm_readv},
#endif
#endif
#ifdef SYS_process_vm_writev
#ifdef __NR_process_vm_writev
	{"process_vm_writev", __NR_process_vm_writev},
#endif
#endif
#ifdef SYS_pselect6
#ifdef __NR_pselect6
	{"pselect6", __NR_pselect6},
#endif
#endif
#ifdef SYS_ptrace
#ifdef __NR_ptrace
	{"ptrace", __NR_ptrace},
#endif
#endif
#ifdef SYS_putpmsg
#ifdef __NR_putpmsg
	{"putpmsg", __NR_putpmsg},
#endif
#endif
#ifdef SYS_pwrite64
#ifdef __NR_pwrite64
	{"pwrite64", __NR_pwrite64},
#endif
#endif
#ifdef SYS_pwritev
#ifdef __NR_pwritev
	{"pwritev", __NR_pwritev},
#endif
#endif
#ifdef SYS_pwritev2
#ifdef __NR_pwritev2
	{"pwritev2", __NR_pwritev2},
#endif
#endif
#ifdef SYS_query_module
#ifdef __NR_query_module
	{"query_module", __NR_query_module},
#endif
#endif
#ifdef SYS_quotactl
#ifdef __NR_quotactl
	{"quotactl", __NR_quotactl},
#endif
#endif
#ifdef SYS_read
#ifdef __NR_read
	{"read", __NR_read},
#endif
#endif
#ifdef SYS_readahead
#ifdef __NR_readahead
	{"readahead", __NR_readahead},
#endif
#endif
#ifdef SYS_readlink
#ifdef __NR_readlink
	{"readlink", __NR_readlink},
#endif
#endif
#ifdef SYS_readlinkat
#ifdef __NR_readlinkat
	{"readlinkat", __NR_readlinkat},
#endif
#endif
#ifdef SYS_readv
#ifdef __NR_readv
	{"readv", __NR_readv},
#endif
#endif
#ifdef SYS_reboot
#ifdef __NR_reboot
	{"reboot", __NR_reboot},
#endif
#endif
#ifdef SYS_recvfrom
#ifdef __NR_recvfrom
	{"recvfrom", __NR_recvfrom},
#endif
#endif
#ifdef SYS_recvmmsg
#ifdef __NR_recvmmsg
	{"recvmmsg", __NR_recvmmsg},
#endif
#endif
#ifdef SYS_recvmsg
#ifdef __NR_recvmsg
	{"recvmsg", __NR_recvmsg},
#endif
#endif
#ifdef SYS_remap_file_pages
#ifdef __NR_remap_file_pages
	{"remap_file_pages", __NR_remap_file_pages},
#endif
#endif
#ifdef SYS_removexattr
#ifdef __NR_removexattr
	{"removexattr", __NR_removexattr},
#endif
#endif
#ifdef SYS_rename
#ifdef __NR_rename
	{"rename", __NR_rename},
#endif
#endif
#ifdef SYS_renameat
#ifdef __NR_renameat
	{"renameat", __NR_renameat},
#endif
#endif
#ifdef SYS_renameat2
#ifdef __NR_renameat2
	{"renameat2", __NR_renameat2},
#endif
#endif
#ifdef SYS_request_key
#ifdef __NR_request_key
	{"request_key", __NR_request_key},
#endif
#endif
#ifdef SYS_restart_syscall
#ifdef __NR_restart_syscall
	{"restart_syscall", __NR_restart_syscall},
#endif
#endif
#ifdef SYS_rmdir
#ifdef __NR_rmdir
	{"rmdir", __NR_rmdir},
#endif
#endif
#ifdef SYS_rt_sigaction
#ifdef __NR_rt_sigaction
	{"rt_sigaction", __NR_rt_sigaction},
#endif
#endif
#ifdef SYS_rt_sigpending
#ifdef __NR_rt_sigpending
	{"rt_sigpending", __NR_rt_sigpending},
#endif
#endif
#ifdef SYS_rt_sigprocmask
#ifdef __NR_rt_sigprocmask
	{"rt_sigprocmask", __NR_rt_sigprocmask},
#endif
#endif
#ifdef SYS_rt_sigqueueinfo
#ifdef __NR_rt_sigqueueinfo
	{"rt_sigqueueinfo", __NR_rt_sigqueueinfo},
#endif
#endif
#ifdef SYS_rt_sigreturn
#ifdef __NR_rt_sigreturn
	{"rt_sigreturn", __NR_rt_sigreturn},
#endif
#endif
#ifdef SYS_rt_sigsuspend
#ifdef __NR_rt_sigsuspend
	{"rt_sigsuspend", __NR_rt_sigsuspend},
#endif
#endif
#ifdef SYS_rt_sigtimedwait
#ifdef __NR_rt_sigtimedwait
	{"rt_sigtimedwait", __NR_rt_sigtimedwait},
#endif
#endif
#ifdef SYS_rt_tgsigqueueinfo
#ifdef __NR_rt_tgsigqueueinfo
	{"rt_tgsigqueueinfo", __NR_rt_tgsigqueueinfo},
#endif
#endif
#ifdef SYS_sched_get_priority_max
#ifdef __NR_sched_get_priority_max
	{"sched_get_priority_max", __NR_sched_get_priority_max},
#endif
#endif
#ifdef SYS_sched_get_priority_min
#ifdef __NR_sched_get_priority_min
	{"sched_get_priority_min", __NR_sched_get_priority_min},
#endif
#endif
#ifdef SYS_sched_getaffinity
#ifdef __NR_sched_getaffinity
	{"sched_getaffinity", __NR_sched_getaffinity},
#endif
#endif
#ifdef SYS_sched_getattr
#ifdef __NR_sched_getattr
	{"sched_getattr", __NR_sched_getattr},
#endif
#endif
#ifdef SYS_sched_getparam
#ifdef __NR_sched_getparam
	{"sched_getparam", __NR_sched_getparam},
#endif
#endif
#ifdef SYS_sched_getscheduler
#ifdef __NR_sched_getscheduler
	{"sched_getscheduler", __NR_sched_getscheduler},
#endif
#endif
#ifdef SYS_sched_rr_get_interval
#ifdef __NR_sched_rr_get_interval
	{"sched_rr_get_interval", __NR_sched_rr_get_interval},
#endif
#endif
#ifdef SYS_sched_setaffinity
#ifdef __NR_sched_setaffinity
	{"sched_setaffinity", __NR_sched_setaffinity},
#endif
#endif
#ifdef SYS_sched_setattr
#ifdef __NR_sched_setattr
	{"sched_setattr", __NR_sched_setattr},
#endif
#endif
#ifdef SYS_sched_setparam
#ifdef __NR_sched_setparam
	{"sched_setparam", __NR_sched_setparam},
#endif
#endif
#ifdef SYS_sched_setscheduler
#ifdef __NR_sched_setscheduler
	{"sched_setscheduler", __NR_sched_setscheduler},
#endif
#endif
#ifdef SYS_sched_yield
#ifdef __NR_sched_yield
	{"sched_yield", __NR_sched_yield},
#endif
#endif
#ifdef SYS_seccomp
#ifdef __NR_seccomp
	{"seccomp", __NR_seccomp},
#endif
#endif
#ifdef SYS_security
#ifdef __NR_security
	{"security", __NR_security},
#endif
#endif
#ifdef SYS_select
#ifdef __NR_select
	{"select", __NR_select},
#endif
#endif
#ifdef SYS_semctl
#ifdef __NR_semctl
	{"semctl", __NR_semctl},
#endif
#endif
#ifdef SYS_semget
#ifdef __NR_semget
	{"semget", __NR_semget},
#endif
#endif
#ifdef SYS_semop
#ifdef __NR_semop
	{"semop", __NR_semop},
#endif
#endif
#ifdef SYS_semtimedop
#ifdef __NR_semtimedop
	{"semtimedop", __NR_semtimedop},
#endif
#endif
#ifdef SYS_sendfile
#ifdef __NR_sendfile
	{"sendfile", __NR_sendfile},
#endif
#endif
#ifdef SYS_sendmmsg
#ifdef __NR_sendmmsg
	{"sendmmsg", __NR_sendmmsg},
#endif
#endif
#ifdef SYS_sendmsg
#ifdef __NR_sendmsg
	{"sendmsg", __NR_sendmsg},
#endif
#endif
#ifdef SYS_sendto
#ifdef __NR_sendto
	{"sendto", __NR_sendto},
#endif
#endif
#ifdef SYS_set_mempolicy
#ifdef __NR_set_mempolicy
	{"set_mempolicy", __NR_set_mempolicy},
#endif
#endif
#ifdef SYS_set_robust_list
#ifdef __NR_set_robust_list
	{"set_robust_list", __NR_set_robust_list},
#endif
#endif
#ifdef SYS_set_thread_area
#ifdef __NR_set_thread_area
	{"set_thread_area", __NR_set_thread_area},
#endif
#endif
#ifdef SYS_set_tid_address
#ifdef __NR_set_tid_address
	{"set_tid_address", __NR_set_tid_address},
#endif
#endif
#ifdef SYS_setdomainname
#ifdef __NR_setdomainname
	{"setdomainname", __NR_setdomainname},
#endif
#endif
#ifdef SYS_setfsgid
#ifdef __NR_setfsgid
	{"setfsgid", __NR_setfsgid},
#endif
#endif
#ifdef SYS_setfsuid
#ifdef __NR_setfsuid
	{"setfsuid", __NR_setfsuid},
#endif
#endif
#ifdef SYS_setgid
#ifdef __NR_setgid
	{"setgid", __NR_setgid},
#endif
#endif
#ifdef SYS_setgroups
#ifdef __NR_setgroups
	{"setgroups", __NR_setgroups},
#endif
#endif
#ifdef SYS_sethostname
#ifdef __NR_sethostname
	{"sethostname", __NR_sethostname},
#endif
#endif
#ifdef SYS_setitimer
#ifdef __NR_setitimer
	{"setitimer", __NR_setitimer},
#endif
#endif
#ifdef SYS_setns
#ifdef __NR_setns
	{"setns", __NR_setns},
#endif
#endif
#ifdef SYS_setpgid
#ifdef __NR_setpgid
	{"setpgid", __NR_setpgid},
#endif
#endif
#ifdef SYS_setpriority
#ifdef __NR_setpriority
	{"setpriority", __NR_setpriority},
#endif
#endif
#ifdef SYS_setregid
#ifdef __NR_setregid
	{"setregid", __NR_setregid},
#endif
#endif
#ifdef SYS_setresgid
#ifdef __NR_setresgid
	{"setresgid", __NR_setresgid},
#endif
#endif
#ifdef SYS_setresuid
#ifdef __NR_setresuid
	{"setresuid", __NR_setresuid},
#endif
#endif
#ifdef SYS_setreuid
#ifdef __NR_setreuid
	{"setreuid", __NR_setreuid},
#endif
#endif
#ifdef SYS_setrlimit
#ifdef __NR_setrlimit
	{"setrlimit", __NR_setrlimit},
#endif
#endif
#ifdef SYS_setsid
#ifdef __NR_setsid
	{"setsid", __NR_setsid},
#endif
#endif
#ifdef SYS_setsockopt
#ifdef __NR_setsockopt
	{"setsockopt", __NR_setsockopt},
#endif
#endif
#ifdef SYS_settimeofday
#ifdef __NR_settimeofday
	{"settimeofday", __NR_settimeofday},
#endif
#endif
#ifdef SYS_setuid
#ifdef __NR_setuid
	{"setuid", __NR_setuid},
#endif
#endif
#ifdef SYS_setxattr
#ifdef __NR_setxattr
	{"setxattr", __NR_setxattr},
#endif
#endif
#ifdef SYS_shmat
#ifdef __NR_shmat
	{"shmat", __NR_shmat},
#endif
#endif
#ifdef SYS_shmctl
#ifdef __NR_shmctl
	{"shmctl", __NR_shmctl},
#endif
#endif
#ifdef SYS_shmdt
#ifdef __NR_shmdt
	{"shmdt", __NR_shmdt},
#endif
#endif
#ifdef SYS_shmget
#ifdef __NR_shmget
	{"shmget", __NR_shmget},
#endif
#endif
#ifdef SYS_shutdown
#ifdef __NR_shutdown
	{"shutdown", __NR_shutdown},
#endif
#endif
#ifdef SYS_sigaltstack
#ifdef __NR_sigaltstack
	{"sigaltstack", __NR_sigaltstack},
#endif
#endif
#ifdef SYS_signalfd
#ifdef __NR_signalfd
	{"signalfd", __NR_signalfd},
#endif
#endif
#ifdef SYS_signalfd4
#ifdef __NR_signalfd4
	{"signalfd4", __NR_signalfd4},
#endif
#endif
#ifdef SYS_socket
#ifdef __NR_socket
	{"socket", __NR_socket},
#endif
#endif
#ifdef SYS_socketpair
#ifdef __NR_socketpair
	{"socketpair", __NR_socketpair},
#endif
#endif
#ifdef SYS_splice
#ifdef __NR_splice
	{"splice", __NR_splice},
#endif
#endif
#ifdef SYS_stat
#ifdef __NR_stat
	{"stat", __NR_stat},
#endif
#endif
#ifdef SYS_statfs
#ifdef __NR_statfs
	{"statfs", __NR_statfs},
#endif
#endif
#ifdef SYS_statx
#ifdef __NR_statx
	{"statx", __NR_statx},
#endif
#endif
#ifdef SYS_swapoff
#ifdef __NR_swapoff
	{"swapoff", __NR_swapoff},
#endif
#endif
#ifdef SYS_swapon
#ifdef __NR_swapon
	{"swapon", __NR_swapon},
#endif
#endif
#ifdef SYS_symlink
#ifdef __NR_symlink
	{"symlink", __NR_symlink},
#endif
#endif
#ifdef SYS_symlinkat
#ifdef __NR_symlinkat
	{"symlinkat", __NR_symlinkat},
#endif
#endif
#ifdef SYS_sync
#ifdef __NR_sync
	{"sync", __NR_sync},
#endif
#endif
#ifdef SYS_sync_file_range
#ifdef __NR_sync_file_range
	{"sync_file_range", __NR_sync_file_range},
#endif
#endif
#ifdef SYS_syncfs
#ifdef __NR_syncfs
	{"syncfs", __NR_syncfs},
#endif
#endif
#ifdef SYS_sysfs
#ifdef __NR_sysfs
	{"sysfs", __NR_sysfs},
#endif
#endif
#ifdef SYS_sysinfo
#ifdef __NR_sysinfo
	{"sysinfo", __NR_sysinfo},
#endif
#endif
#ifdef SYS_syslog
#ifdef __NR_syslog
	{"syslog", __NR_syslog},
#endif
#endif
#ifdef SYS_tee
#ifdef __NR_tee
	{"tee", __NR_tee},
#endif
#endif
#ifdef SYS_tgkill
#ifdef __NR_tgkill
	{"tgkill", __NR_tgkill},
#endif
#endif
#ifdef SYS_time
#ifdef __NR_time
	{"time", __NR_time},
#endif
#endif
#ifdef SYS_timer_create
#ifdef __NR_timer_create
	{"timer_create", __NR_timer_create},
#endif
#endif
#ifdef SYS_timer_delete
#ifdef __NR_timer_delete
	{"timer_delete", __NR_timer_delete},
#endif
#endif
#ifdef SYS_timer_getoverrun
#ifdef __NR_timer_getoverrun
	{"timer_getoverrun", __NR_timer_getoverrun},
#endif
#endif
#ifdef SYS_timer_gettime
#ifdef __NR_timer_gettime
	{"timer_gettime", __NR_timer_gettime},
#endif
#endif
#ifdef SYS_timer_settime
#ifdef __NR_timer_settime
	{"timer_settime", __NR_timer_settime},
#endif
#endif
#ifdef SYS_timerfd_create
#ifdef __NR_timerfd_create
	{"timerfd_create", __NR_timerfd_create},
#endif
#endif
#ifdef SYS_timerfd_gettime
#ifdef __NR_timerfd_gettime
	{"timerfd_gettime", __NR_timerfd_gettime},
#endif
#endif
#ifdef SYS_timerfd_settime
#ifdef __NR_timerfd_settime
	{"timerfd_settime", __NR_timerfd_settime},
#endif
#endif
#ifdef SYS_times
#ifdef __NR_times
	{"times", __NR_times},
#endif
#endif
#ifdef SYS_tkill
#ifdef __NR_tkill
	{"tkill", __NR_tkill},
#endif
#endif
#ifdef SYS_truncate
#ifdef __NR_truncate
	{"truncate", __NR_truncate},
#endif
#endif
#ifdef SYS_tuxcall
#ifdef __NR_tuxcall
	{"tuxcall", __NR_tuxcall},
#endif
#endif
#ifdef SYS_umask
#ifdef __NR_umask
	{"umask", __NR_umask},
#endif
#endif
#ifdef SYS_umount2
#ifdef __NR_umount2
	{"umount2", __NR_umount2},
#endif
#endif
#ifdef SYS_uname
#ifdef __NR_uname
	{"uname", __NR_uname},
#endif
#endif
#ifdef SYS_unlink
#ifdef __NR_unlink
	{"unlink", __NR_unlink},
#endif
#endif
#ifdef SYS_unlinkat
#ifdef __NR_unlinkat
	{"unlinkat", __NR_unlinkat},
#endif
#endif
#ifdef SYS_unshare
#ifdef __NR_unshare
	{"unshare", __NR_unshare},
#endif
#endif
#ifdef SYS_uselib
#ifdef __NR_uselib
	{"uselib", __NR_uselib},
#endif
#endif
#ifdef SYS_userfaultfd
#ifdef __NR_userfaultfd
	{"userfaultfd", __NR_userfaultfd},
#endif
#endif
#ifdef SYS_ustat
#ifdef __NR_ustat
	{"ustat", __NR_ustat},
#endif
#endif
#ifdef SYS_utime
#ifdef __NR_utime
	{"utime", __NR_utime},
#endif
#endif
#ifdef SYS_utimensat
#ifdef __NR_utimensat
	{"utimensat", __NR_utimensat},
#endif
#endif
#ifdef SYS_utimes
#ifdef __NR_utimes
	{"utimes", __NR_utimes},
#endif
#endif
#ifdef SYS_vfork
#ifdef __NR_vfork
	{"vfork", __NR_vfork},
#endif
#endif
#ifdef SYS_vhangup
#ifdef __NR_vhangup
	{"vhangup", __NR_vhangup},
#endif
#endif
#ifdef SYS_vmsplice
#ifdef __NR_vmsplice
	{"vmsplice", __NR_vmsplice},
#endif
#endif
#ifdef SYS_vserver
#ifdef __NR_vserver
	{"vserver", __NR_vserver},
#endif
#endif
#ifdef SYS_wait4
#ifdef __NR_wait4
	{"wait4", __NR_wait4},
#endif
#endif
#ifdef SYS_waitid
#ifdef __NR_waitid
	{"waitid", __NR_waitid},
#endif
#endif
#ifdef SYS_write
#ifdef __NR_write
	{"write", __NR_write},
#endif
#endif
#ifdef SYS_writev
#ifdef __NR_writev
	{"writev", __NR_writev},
#endif
#endif
#endif
//#endif
#if defined __x86_64__ && defined __ILP32__
#ifdef SYS_accept
#ifdef __NR_accept
	{"accept", __NR_accept},
#endif
#endif
#ifdef SYS_accept4
#ifdef __NR_accept4
	{"accept4", __NR_accept4},
#endif
#endif
#ifdef SYS_access
#ifdef __NR_access
	{"access", __NR_access},
#endif
#endif
#ifdef SYS_acct
#ifdef __NR_acct
	{"acct", __NR_acct},
#endif
#endif
#ifdef SYS_add_key
#ifdef __NR_add_key
	{"add_key", __NR_add_key},
#endif
#endif
#ifdef SYS_adjtimex
#ifdef __NR_adjtimex
	{"adjtimex", __NR_adjtimex},
#endif
#endif
#ifdef SYS_afs_syscall
#ifdef __NR_afs_syscall
	{"afs_syscall", __NR_afs_syscall},
#endif
#endif
#ifdef SYS_alarm
#ifdef __NR_alarm
	{"alarm", __NR_alarm},
#endif
#endif
#ifdef SYS_arch_prctl
#ifdef __NR_arch_prctl
	{"arch_prctl", __NR_arch_prctl},
#endif
#endif
#ifdef SYS_bind
#ifdef __NR_bind
	{"bind", __NR_bind},
#endif
#endif
#ifdef SYS_bpf
#ifdef __NR_bpf
	{"bpf", __NR_bpf},
#endif
#endif
#ifdef SYS_brk
#ifdef __NR_brk
	{"brk", __NR_brk},
#endif
#endif
#ifdef SYS_capget
#ifdef __NR_capget
	{"capget", __NR_capget},
#endif
#endif
#ifdef SYS_capset
#ifdef __NR_capset
	{"capset", __NR_capset},
#endif
#endif
#ifdef SYS_chdir
#ifdef __NR_chdir
	{"chdir", __NR_chdir},
#endif
#endif
#ifdef SYS_chmod
#ifdef __NR_chmod
	{"chmod", __NR_chmod},
#endif
#endif
#ifdef SYS_chown
#ifdef __NR_chown
	{"chown", __NR_chown},
#endif
#endif
#ifdef SYS_chroot
#ifdef __NR_chroot
	{"chroot", __NR_chroot},
#endif
#endif
#ifdef SYS_clock_adjtime
#ifdef __NR_clock_adjtime
	{"clock_adjtime", __NR_clock_adjtime},
#endif
#endif
#ifdef SYS_clock_getres
#ifdef __NR_clock_getres
	{"clock_getres", __NR_clock_getres},
#endif
#endif
#ifdef SYS_clock_gettime
#ifdef __NR_clock_gettime
	{"clock_gettime", __NR_clock_gettime},
#endif
#endif
#ifdef SYS_clock_nanosleep
#ifdef __NR_clock_nanosleep
	{"clock_nanosleep", __NR_clock_nanosleep},
#endif
#endif
#ifdef SYS_clock_settime
#ifdef __NR_clock_settime
	{"clock_settime", __NR_clock_settime},
#endif
#endif
#ifdef SYS_clone
#ifdef __NR_clone
	{"clone", __NR_clone},
#endif
#endif
#ifdef SYS_close
#ifdef __NR_close
	{"close", __NR_close},
#endif
#endif
#ifdef SYS_connect
#ifdef __NR_connect
	{"connect", __NR_connect},
#endif
#endif
#ifdef SYS_copy_file_range
#ifdef __NR_copy_file_range
	{"copy_file_range", __NR_copy_file_range},
#endif
#endif
#ifdef SYS_creat
#ifdef __NR_creat
	{"creat", __NR_creat},
#endif
#endif
#ifdef SYS_delete_module
#ifdef __NR_delete_module
	{"delete_module", __NR_delete_module},
#endif
#endif
#ifdef SYS_dup
#ifdef __NR_dup
	{"dup", __NR_dup},
#endif
#endif
#ifdef SYS_dup2
#ifdef __NR_dup2
	{"dup2", __NR_dup2},
#endif
#endif
#ifdef SYS_dup3
#ifdef __NR_dup3
	{"dup3", __NR_dup3},
#endif
#endif
#ifdef SYS_epoll_create
#ifdef __NR_epoll_create
	{"epoll_create", __NR_epoll_create},
#endif
#endif
#ifdef SYS_epoll_create1
#ifdef __NR_epoll_create1
	{"epoll_create1", __NR_epoll_create1},
#endif
#endif
#ifdef SYS_epoll_ctl
#ifdef __NR_epoll_ctl
	{"epoll_ctl", __NR_epoll_ctl},
#endif
#endif
#ifdef SYS_epoll_pwait
#ifdef __NR_epoll_pwait
	{"epoll_pwait", __NR_epoll_pwait},
#endif
#endif
#ifdef SYS_epoll_wait
#ifdef __NR_epoll_wait
	{"epoll_wait", __NR_epoll_wait},
#endif
#endif
#ifdef SYS_eventfd
#ifdef __NR_eventfd
	{"eventfd", __NR_eventfd},
#endif
#endif
#ifdef SYS_eventfd2
#ifdef __NR_eventfd2
	{"eventfd2", __NR_eventfd2},
#endif
#endif
#ifdef SYS_execve
#ifdef __NR_execve
	{"execve", __NR_execve},
#endif
#endif
#ifdef SYS_execveat
#ifdef __NR_execveat
	{"execveat", __NR_execveat},
#endif
#endif
#ifdef SYS_exit
#ifdef __NR_exit
	{"exit", __NR_exit},
#endif
#endif
#ifdef SYS_exit_group
#ifdef __NR_exit_group
	{"exit_group", __NR_exit_group},
#endif
#endif
#ifdef SYS_faccessat
#ifdef __NR_faccessat
	{"faccessat", __NR_faccessat},
#endif
#endif
#ifdef SYS_fadvise64
#ifdef __NR_fadvise64
	{"fadvise64", __NR_fadvise64},
#endif
#endif
#ifdef SYS_fallocate
#ifdef __NR_fallocate
	{"fallocate", __NR_fallocate},
#endif
#endif
#ifdef SYS_fanotify_init
#ifdef __NR_fanotify_init
	{"fanotify_init", __NR_fanotify_init},
#endif
#endif
#ifdef SYS_fanotify_mark
#ifdef __NR_fanotify_mark
	{"fanotify_mark", __NR_fanotify_mark},
#endif
#endif
#ifdef SYS_fchdir
#ifdef __NR_fchdir
	{"fchdir", __NR_fchdir},
#endif
#endif
#ifdef SYS_fchmod
#ifdef __NR_fchmod
	{"fchmod", __NR_fchmod},
#endif
#endif
#ifdef SYS_fchmodat
#ifdef __NR_fchmodat
	{"fchmodat", __NR_fchmodat},
#endif
#endif
#ifdef SYS_fchown
#ifdef __NR_fchown
	{"fchown", __NR_fchown},
#endif
#endif
#ifdef SYS_fchownat
#ifdef __NR_fchownat
	{"fchownat", __NR_fchownat},
#endif
#endif
#ifdef SYS_fcntl
#ifdef __NR_fcntl
	{"fcntl", __NR_fcntl},
#endif
#endif
#ifdef SYS_fdatasync
#ifdef __NR_fdatasync
	{"fdatasync", __NR_fdatasync},
#endif
#endif
#ifdef SYS_fgetxattr
#ifdef __NR_fgetxattr
	{"fgetxattr", __NR_fgetxattr},
#endif
#endif
#ifdef SYS_finit_module
#ifdef __NR_finit_module
	{"finit_module", __NR_finit_module},
#endif
#endif
#ifdef SYS_flistxattr
#ifdef __NR_flistxattr
	{"flistxattr", __NR_flistxattr},
#endif
#endif
#ifdef SYS_flock
#ifdef __NR_flock
	{"flock", __NR_flock},
#endif
#endif
#ifdef SYS_fork
#ifdef __NR_fork
	{"fork", __NR_fork},
#endif
#endif
#ifdef SYS_fremovexattr
#ifdef __NR_fremovexattr
	{"fremovexattr", __NR_fremovexattr},
#endif
#endif
#ifdef SYS_fsetxattr
#ifdef __NR_fsetxattr
	{"fsetxattr", __NR_fsetxattr},
#endif
#endif
#ifdef SYS_fstat
#ifdef __NR_fstat
	{"fstat", __NR_fstat},
#endif
#endif
#ifdef SYS_fstatfs
#ifdef __NR_fstatfs
	{"fstatfs", __NR_fstatfs},
#endif
#endif
#ifdef SYS_fsync
#ifdef __NR_fsync
	{"fsync", __NR_fsync},
#endif
#endif
#ifdef SYS_ftruncate
#ifdef __NR_ftruncate
	{"ftruncate", __NR_ftruncate},
#endif
#endif
#ifdef SYS_futex
#ifdef __NR_futex
	{"futex", __NR_futex},
#endif
#endif
#ifdef SYS_futimesat
#ifdef __NR_futimesat
	{"futimesat", __NR_futimesat},
#endif
#endif
#ifdef SYS_get_mempolicy
#ifdef __NR_get_mempolicy
	{"get_mempolicy", __NR_get_mempolicy},
#endif
#endif
#ifdef SYS_get_robust_list
#ifdef __NR_get_robust_list
	{"get_robust_list", __NR_get_robust_list},
#endif
#endif
#ifdef SYS_getcpu
#ifdef __NR_getcpu
	{"getcpu", __NR_getcpu},
#endif
#endif
#ifdef SYS_getcwd
#ifdef __NR_getcwd
	{"getcwd", __NR_getcwd},
#endif
#endif
#ifdef SYS_getdents
#ifdef __NR_getdents
	{"getdents", __NR_getdents},
#endif
#endif
#ifdef SYS_getdents64
#ifdef __NR_getdents64
	{"getdents64", __NR_getdents64},
#endif
#endif
#ifdef SYS_getegid
#ifdef __NR_getegid
	{"getegid", __NR_getegid},
#endif
#endif
#ifdef SYS_geteuid
#ifdef __NR_geteuid
	{"geteuid", __NR_geteuid},
#endif
#endif
#ifdef SYS_getgid
#ifdef __NR_getgid
	{"getgid", __NR_getgid},
#endif
#endif
#ifdef SYS_getgroups
#ifdef __NR_getgroups
	{"getgroups", __NR_getgroups},
#endif
#endif
#ifdef SYS_getitimer
#ifdef __NR_getitimer
	{"getitimer", __NR_getitimer},
#endif
#endif
#ifdef SYS_getpeername
#ifdef __NR_getpeername
	{"getpeername", __NR_getpeername},
#endif
#endif
#ifdef SYS_getpgid
#ifdef __NR_getpgid
	{"getpgid", __NR_getpgid},
#endif
#endif
#ifdef SYS_getpgrp
#ifdef __NR_getpgrp
	{"getpgrp", __NR_getpgrp},
#endif
#endif
#ifdef SYS_getpid
#ifdef __NR_getpid
	{"getpid", __NR_getpid},
#endif
#endif
#ifdef SYS_getpmsg
#ifdef __NR_getpmsg
	{"getpmsg", __NR_getpmsg},
#endif
#endif
#ifdef SYS_getppid
#ifdef __NR_getppid
	{"getppid", __NR_getppid},
#endif
#endif
#ifdef SYS_getpriority
#ifdef __NR_getpriority
	{"getpriority", __NR_getpriority},
#endif
#endif
#ifdef SYS_getrandom
#ifdef __NR_getrandom
	{"getrandom", __NR_getrandom},
#endif
#endif
#ifdef SYS_getresgid
#ifdef __NR_getresgid
	{"getresgid", __NR_getresgid},
#endif
#endif
#ifdef SYS_getresuid
#ifdef __NR_getresuid
	{"getresuid", __NR_getresuid},
#endif
#endif
#ifdef SYS_getrlimit
#ifdef __NR_getrlimit
	{"getrlimit", __NR_getrlimit},
#endif
#endif
#ifdef SYS_getrusage
#ifdef __NR_getrusage
	{"getrusage", __NR_getrusage},
#endif
#endif
#ifdef SYS_getsid
#ifdef __NR_getsid
	{"getsid", __NR_getsid},
#endif
#endif
#ifdef SYS_getsockname
#ifdef __NR_getsockname
	{"getsockname", __NR_getsockname},
#endif
#endif
#ifdef SYS_getsockopt
#ifdef __NR_getsockopt
	{"getsockopt", __NR_getsockopt},
#endif
#endif
#ifdef SYS_gettid
#ifdef __NR_gettid
	{"gettid", __NR_gettid},
#endif
#endif
#ifdef SYS_gettimeofday
#ifdef __NR_gettimeofday
	{"gettimeofday", __NR_gettimeofday},
#endif
#endif
#ifdef SYS_getuid
#ifdef __NR_getuid
	{"getuid", __NR_getuid},
#endif
#endif
#ifdef SYS_getxattr
#ifdef __NR_getxattr
	{"getxattr", __NR_getxattr},
#endif
#endif
#ifdef SYS_init_module
#ifdef __NR_init_module
	{"init_module", __NR_init_module},
#endif
#endif
#ifdef SYS_inotify_add_watch
#ifdef __NR_inotify_add_watch
	{"inotify_add_watch", __NR_inotify_add_watch},
#endif
#endif
#ifdef SYS_inotify_init
#ifdef __NR_inotify_init
	{"inotify_init", __NR_inotify_init},
#endif
#endif
#ifdef SYS_inotify_init1
#ifdef __NR_inotify_init1
	{"inotify_init1", __NR_inotify_init1},
#endif
#endif
#ifdef SYS_inotify_rm_watch
#ifdef __NR_inotify_rm_watch
	{"inotify_rm_watch", __NR_inotify_rm_watch},
#endif
#endif
#ifdef SYS_io_cancel
#ifdef __NR_io_cancel
	{"io_cancel", __NR_io_cancel},
#endif
#endif
#ifdef SYS_io_destroy
#ifdef __NR_io_destroy
	{"io_destroy", __NR_io_destroy},
#endif
#endif
#ifdef SYS_io_getevents
#ifdef __NR_io_getevents
	{"io_getevents", __NR_io_getevents},
#endif
#endif
#ifdef SYS_io_setup
#ifdef __NR_io_setup
	{"io_setup", __NR_io_setup},
#endif
#endif
#ifdef SYS_io_submit
#ifdef __NR_io_submit
	{"io_submit", __NR_io_submit},
#endif
#endif
#ifdef SYS_ioctl
#ifdef __NR_ioctl
	{"ioctl", __NR_ioctl},
#endif
#endif
#ifdef SYS_ioperm
#ifdef __NR_ioperm
	{"ioperm", __NR_ioperm},
#endif
#endif
#ifdef SYS_iopl
#ifdef __NR_iopl
	{"iopl", __NR_iopl},
#endif
#endif
#ifdef SYS_ioprio_get
#ifdef __NR_ioprio_get
	{"ioprio_get", __NR_ioprio_get},
#endif
#endif
#ifdef SYS_ioprio_set
#ifdef __NR_ioprio_set
	{"ioprio_set", __NR_ioprio_set},
#endif
#endif
#ifdef SYS_kcmp
#ifdef __NR_kcmp
	{"kcmp", __NR_kcmp},
#endif
#endif
#ifdef SYS_kexec_file_load
#ifdef __NR_kexec_file_load
	{"kexec_file_load", __NR_kexec_file_load},
#endif
#endif
#ifdef SYS_kexec_load
#ifdef __NR_kexec_load
	{"kexec_load", __NR_kexec_load},
#endif
#endif
#ifdef SYS_keyctl
#ifdef __NR_keyctl
	{"keyctl", __NR_keyctl},
#endif
#endif
#ifdef SYS_kill
#ifdef __NR_kill
	{"kill", __NR_kill},
#endif
#endif
#ifdef SYS_lchown
#ifdef __NR_lchown
	{"lchown", __NR_lchown},
#endif
#endif
#ifdef SYS_lgetxattr
#ifdef __NR_lgetxattr
	{"lgetxattr", __NR_lgetxattr},
#endif
#endif
#ifdef SYS_link
#ifdef __NR_link
	{"link", __NR_link},
#endif
#endif
#ifdef SYS_linkat
#ifdef __NR_linkat
	{"linkat", __NR_linkat},
#endif
#endif
#ifdef SYS_listen
#ifdef __NR_listen
	{"listen", __NR_listen},
#endif
#endif
#ifdef SYS_listxattr
#ifdef __NR_listxattr
	{"listxattr", __NR_listxattr},
#endif
#endif
#ifdef SYS_llistxattr
#ifdef __NR_llistxattr
	{"llistxattr", __NR_llistxattr},
#endif
#endif
#ifdef SYS_lookup_dcookie
#ifdef __NR_lookup_dcookie
	{"lookup_dcookie", __NR_lookup_dcookie},
#endif
#endif
#ifdef SYS_lremovexattr
#ifdef __NR_lremovexattr
	{"lremovexattr", __NR_lremovexattr},
#endif
#endif
#ifdef SYS_lseek
#ifdef __NR_lseek
	{"lseek", __NR_lseek},
#endif
#endif
#ifdef SYS_lsetxattr
#ifdef __NR_lsetxattr
	{"lsetxattr", __NR_lsetxattr},
#endif
#endif
#ifdef SYS_lstat
#ifdef __NR_lstat
	{"lstat", __NR_lstat},
#endif
#endif
#ifdef SYS_madvise
#ifdef __NR_madvise
	{"madvise", __NR_madvise},
#endif
#endif
#ifdef SYS_mbind
#ifdef __NR_mbind
	{"mbind", __NR_mbind},
#endif
#endif
#ifdef SYS_membarrier
#ifdef __NR_membarrier
	{"membarrier", __NR_membarrier},
#endif
#endif
#ifdef SYS_memfd_create
#ifdef __NR_memfd_create
	{"memfd_create", __NR_memfd_create},
#endif
#endif
#ifdef SYS_migrate_pages
#ifdef __NR_migrate_pages
	{"migrate_pages", __NR_migrate_pages},
#endif
#endif
#ifdef SYS_mincore
#ifdef __NR_mincore
	{"mincore", __NR_mincore},
#endif
#endif
#ifdef SYS_mkdir
#ifdef __NR_mkdir
	{"mkdir", __NR_mkdir},
#endif
#endif
#ifdef SYS_mkdirat
#ifdef __NR_mkdirat
	{"mkdirat", __NR_mkdirat},
#endif
#endif
#ifdef SYS_mknod
#ifdef __NR_mknod
	{"mknod", __NR_mknod},
#endif
#endif
#ifdef SYS_mknodat
#ifdef __NR_mknodat
	{"mknodat", __NR_mknodat},
#endif
#endif
#ifdef SYS_mlock
#ifdef __NR_mlock
	{"mlock", __NR_mlock},
#endif
#endif
#ifdef SYS_mlock2
#ifdef __NR_mlock2
	{"mlock2", __NR_mlock2},
#endif
#endif
#ifdef SYS_mlockall
#ifdef __NR_mlockall
	{"mlockall", __NR_mlockall},
#endif
#endif
#ifdef SYS_mmap
#ifdef __NR_mmap
	{"mmap", __NR_mmap},
#endif
#endif
#ifdef SYS_modify_ldt
#ifdef __NR_modify_ldt
	{"modify_ldt", __NR_modify_ldt},
#endif
#endif
#ifdef SYS_mount
#ifdef __NR_mount
	{"mount", __NR_mount},
#endif
#endif
#ifdef SYS_move_pages
#ifdef __NR_move_pages
	{"move_pages", __NR_move_pages},
#endif
#endif
#ifdef SYS_mprotect
#ifdef __NR_mprotect
	{"mprotect", __NR_mprotect},
#endif
#endif
#ifdef SYS_mq_getsetattr
#ifdef __NR_mq_getsetattr
	{"mq_getsetattr", __NR_mq_getsetattr},
#endif
#endif
#ifdef SYS_mq_notify
#ifdef __NR_mq_notify
	{"mq_notify", __NR_mq_notify},
#endif
#endif
#ifdef SYS_mq_open
#ifdef __NR_mq_open
	{"mq_open", __NR_mq_open},
#endif
#endif
#ifdef SYS_mq_timedreceive
#ifdef __NR_mq_timedreceive
	{"mq_timedreceive", __NR_mq_timedreceive},
#endif
#endif
#ifdef SYS_mq_timedsend
#ifdef __NR_mq_timedsend
	{"mq_timedsend", __NR_mq_timedsend},
#endif
#endif
#ifdef SYS_mq_unlink
#ifdef __NR_mq_unlink
	{"mq_unlink", __NR_mq_unlink},
#endif
#endif
#ifdef SYS_mremap
#ifdef __NR_mremap
	{"mremap", __NR_mremap},
#endif
#endif
#ifdef SYS_msgctl
#ifdef __NR_msgctl
	{"msgctl", __NR_msgctl},
#endif
#endif
#ifdef SYS_msgget
#ifdef __NR_msgget
	{"msgget", __NR_msgget},
#endif
#endif
#ifdef SYS_msgrcv
#ifdef __NR_msgrcv
	{"msgrcv", __NR_msgrcv},
#endif
#endif
#ifdef SYS_msgsnd
#ifdef __NR_msgsnd
	{"msgsnd", __NR_msgsnd},
#endif
#endif
#ifdef SYS_msync
#ifdef __NR_msync
	{"msync", __NR_msync},
#endif
#endif
#ifdef SYS_munlock
#ifdef __NR_munlock
	{"munlock", __NR_munlock},
#endif
#endif
#ifdef SYS_munlockall
#ifdef __NR_munlockall
	{"munlockall", __NR_munlockall},
#endif
#endif
#ifdef SYS_munmap
#ifdef __NR_munmap
	{"munmap", __NR_munmap},
#endif
#endif
#ifdef SYS_name_to_handle_at
#ifdef __NR_name_to_handle_at
	{"name_to_handle_at", __NR_name_to_handle_at},
#endif
#endif
#ifdef SYS_nanosleep
#ifdef __NR_nanosleep
	{"nanosleep", __NR_nanosleep},
#endif
#endif
#ifdef SYS_newfstatat
#ifdef __NR_newfstatat
	{"newfstatat", __NR_newfstatat},
#endif
#endif
#ifdef SYS_open
#ifdef __NR_open
	{"open", __NR_open},
#endif
#endif
#ifdef SYS_open_by_handle_at
#ifdef __NR_open_by_handle_at
	{"open_by_handle_at", __NR_open_by_handle_at},
#endif
#endif
#ifdef SYS_openat
#ifdef __NR_openat
	{"openat", __NR_openat},
#endif
#endif
#ifdef SYS_pause
#ifdef __NR_pause
	{"pause", __NR_pause},
#endif
#endif
#ifdef SYS_perf_event_open
#ifdef __NR_perf_event_open
	{"perf_event_open", __NR_perf_event_open},
#endif
#endif
#ifdef SYS_personality
#ifdef __NR_personality
	{"personality", __NR_personality},
#endif
#endif
#ifdef SYS_pipe
#ifdef __NR_pipe
	{"pipe", __NR_pipe},
#endif
#endif
#ifdef SYS_pipe2
#ifdef __NR_pipe2
	{"pipe2", __NR_pipe2},
#endif
#endif
#ifdef SYS_pivot_root
#ifdef __NR_pivot_root
	{"pivot_root", __NR_pivot_root},
#endif
#endif
#ifdef SYS_pkey_alloc
#ifdef __NR_pkey_alloc
	{"pkey_alloc", __NR_pkey_alloc},
#endif
#endif
#ifdef SYS_pkey_free
#ifdef __NR_pkey_free
	{"pkey_free", __NR_pkey_free},
#endif
#endif
#ifdef SYS_pkey_mprotect
#ifdef __NR_pkey_mprotect
	{"pkey_mprotect", __NR_pkey_mprotect},
#endif
#endif
#ifdef SYS_poll
#ifdef __NR_poll
	{"poll", __NR_poll},
#endif
#endif
#ifdef SYS_ppoll
#ifdef __NR_ppoll
	{"ppoll", __NR_ppoll},
#endif
#endif
#ifdef SYS_prctl
#ifdef __NR_prctl
	{"prctl", __NR_prctl},
#endif
#endif
#ifdef SYS_pread64
#ifdef __NR_pread64
	{"pread64", __NR_pread64},
#endif
#endif
#ifdef SYS_preadv
#ifdef __NR_preadv
	{"preadv", __NR_preadv},
#endif
#endif
#ifdef SYS_preadv2
#ifdef __NR_preadv2
	{"preadv2", __NR_preadv2},
#endif
#endif
#ifdef SYS_prlimit64
#ifdef __NR_prlimit64
	{"prlimit64", __NR_prlimit64},
#endif
#endif
#ifdef SYS_process_vm_readv
#ifdef __NR_process_vm_readv
	{"process_vm_readv", __NR_process_vm_readv},
#endif
#endif
#ifdef SYS_process_vm_writev
#ifdef __NR_process_vm_writev
	{"process_vm_writev", __NR_process_vm_writev},
#endif
#endif
#ifdef SYS_pselect6
#ifdef __NR_pselect6
	{"pselect6", __NR_pselect6},
#endif
#endif
#ifdef SYS_ptrace
#ifdef __NR_ptrace
	{"ptrace", __NR_ptrace},
#endif
#endif
#ifdef SYS_putpmsg
#ifdef __NR_putpmsg
	{"putpmsg", __NR_putpmsg},
#endif
#endif
#ifdef SYS_pwrite64
#ifdef __NR_pwrite64
	{"pwrite64", __NR_pwrite64},
#endif
#endif
#ifdef SYS_pwritev
#ifdef __NR_pwritev
	{"pwritev", __NR_pwritev},
#endif
#endif
#ifdef SYS_pwritev2
#ifdef __NR_pwritev2
	{"pwritev2", __NR_pwritev2},
#endif
#endif
#ifdef SYS_quotactl
#ifdef __NR_quotactl
	{"quotactl", __NR_quotactl},
#endif
#endif
#ifdef SYS_read
#ifdef __NR_read
	{"read", __NR_read},
#endif
#endif
#ifdef SYS_readahead
#ifdef __NR_readahead
	{"readahead", __NR_readahead},
#endif
#endif
#ifdef SYS_readlink
#ifdef __NR_readlink
	{"readlink", __NR_readlink},
#endif
#endif
#ifdef SYS_readlinkat
#ifdef __NR_readlinkat
	{"readlinkat", __NR_readlinkat},
#endif
#endif
#ifdef SYS_readv
#ifdef __NR_readv
	{"readv", __NR_readv},
#endif
#endif
#ifdef SYS_reboot
#ifdef __NR_reboot
	{"reboot", __NR_reboot},
#endif
#endif
#ifdef SYS_recvfrom
#ifdef __NR_recvfrom
	{"recvfrom", __NR_recvfrom},
#endif
#endif
#ifdef SYS_recvmmsg
#ifdef __NR_recvmmsg
	{"recvmmsg", __NR_recvmmsg},
#endif
#endif
#ifdef SYS_recvmsg
#ifdef __NR_recvmsg
	{"recvmsg", __NR_recvmsg},
#endif
#endif
#ifdef SYS_remap_file_pages
#ifdef __NR_remap_file_pages
	{"remap_file_pages", __NR_remap_file_pages},
#endif
#endif
#ifdef SYS_removexattr
#ifdef __NR_removexattr
	{"removexattr", __NR_removexattr},
#endif
#endif
#ifdef SYS_rename
#ifdef __NR_rename
	{"rename", __NR_rename},
#endif
#endif
#ifdef SYS_renameat
#ifdef __NR_renameat
	{"renameat", __NR_renameat},
#endif
#endif
#ifdef SYS_renameat2
#ifdef __NR_renameat2
	{"renameat2", __NR_renameat2},
#endif
#endif
#ifdef SYS_request_key
#ifdef __NR_request_key
	{"request_key", __NR_request_key},
#endif
#endif
#ifdef SYS_restart_syscall
#ifdef __NR_restart_syscall
	{"restart_syscall", __NR_restart_syscall},
#endif
#endif
#ifdef SYS_rmdir
#ifdef __NR_rmdir
	{"rmdir", __NR_rmdir},
#endif
#endif
#ifdef SYS_rt_sigaction
#ifdef __NR_rt_sigaction
	{"rt_sigaction", __NR_rt_sigaction},
#endif
#endif
#ifdef SYS_rt_sigpending
#ifdef __NR_rt_sigpending
	{"rt_sigpending", __NR_rt_sigpending},
#endif
#endif
#ifdef SYS_rt_sigprocmask
#ifdef __NR_rt_sigprocmask
	{"rt_sigprocmask", __NR_rt_sigprocmask},
#endif
#endif
#ifdef SYS_rt_sigqueueinfo
#ifdef __NR_rt_sigqueueinfo
	{"rt_sigqueueinfo", __NR_rt_sigqueueinfo},
#endif
#endif
#ifdef SYS_rt_sigreturn
#ifdef __NR_rt_sigreturn
	{"rt_sigreturn", __NR_rt_sigreturn},
#endif
#endif
#ifdef SYS_rt_sigsuspend
#ifdef __NR_rt_sigsuspend
	{"rt_sigsuspend", __NR_rt_sigsuspend},
#endif
#endif
#ifdef SYS_rt_sigtimedwait
#ifdef __NR_rt_sigtimedwait
	{"rt_sigtimedwait", __NR_rt_sigtimedwait},
#endif
#endif
#ifdef SYS_rt_tgsigqueueinfo
#ifdef __NR_rt_tgsigqueueinfo
	{"rt_tgsigqueueinfo", __NR_rt_tgsigqueueinfo},
#endif
#endif
#ifdef SYS_sched_get_priority_max
#ifdef __NR_sched_get_priority_max
	{"sched_get_priority_max", __NR_sched_get_priority_max},
#endif
#endif
#ifdef SYS_sched_get_priority_min
#ifdef __NR_sched_get_priority_min
	{"sched_get_priority_min", __NR_sched_get_priority_min},
#endif
#endif
#ifdef SYS_sched_getaffinity
#ifdef __NR_sched_getaffinity
	{"sched_getaffinity", __NR_sched_getaffinity},
#endif
#endif
#ifdef SYS_sched_getattr
#ifdef __NR_sched_getattr
	{"sched_getattr", __NR_sched_getattr},
#endif
#endif
#ifdef SYS_sched_getparam
#ifdef __NR_sched_getparam
	{"sched_getparam", __NR_sched_getparam},
#endif
#endif
#ifdef SYS_sched_getscheduler
#ifdef __NR_sched_getscheduler
	{"sched_getscheduler", __NR_sched_getscheduler},
#endif
#endif
#ifdef SYS_sched_rr_get_interval
#ifdef __NR_sched_rr_get_interval
	{"sched_rr_get_interval", __NR_sched_rr_get_interval},
#endif
#endif
#ifdef SYS_sched_setaffinity
#ifdef __NR_sched_setaffinity
	{"sched_setaffinity", __NR_sched_setaffinity},
#endif
#endif
#ifdef SYS_sched_setattr
#ifdef __NR_sched_setattr
	{"sched_setattr", __NR_sched_setattr},
#endif
#endif
#ifdef SYS_sched_setparam
#ifdef __NR_sched_setparam
	{"sched_setparam", __NR_sched_setparam},
#endif
#endif
#ifdef SYS_sched_setscheduler
#ifdef __NR_sched_setscheduler
	{"sched_setscheduler", __NR_sched_setscheduler},
#endif
#endif
#ifdef SYS_sched_yield
#ifdef __NR_sched_yield
	{"sched_yield", __NR_sched_yield},
#endif
#endif
#ifdef SYS_seccomp
#ifdef __NR_seccomp
	{"seccomp", __NR_seccomp},
#endif
#endif
#ifdef SYS_security
#ifdef __NR_security
	{"security", __NR_security},
#endif
#endif
#ifdef SYS_select
#ifdef __NR_select
	{"select", __NR_select},
#endif
#endif
#ifdef SYS_semctl
#ifdef __NR_semctl
	{"semctl", __NR_semctl},
#endif
#endif
#ifdef SYS_semget
#ifdef __NR_semget
	{"semget", __NR_semget},
#endif
#endif
#ifdef SYS_semop
#ifdef __NR_semop
	{"semop", __NR_semop},
#endif
#endif
#ifdef SYS_semtimedop
#ifdef __NR_semtimedop
	{"semtimedop", __NR_semtimedop},
#endif
#endif
#ifdef SYS_sendfile
#ifdef __NR_sendfile
	{"sendfile", __NR_sendfile},
#endif
#endif
#ifdef SYS_sendmmsg
#ifdef __NR_sendmmsg
	{"sendmmsg", __NR_sendmmsg},
#endif
#endif
#ifdef SYS_sendmsg
#ifdef __NR_sendmsg
	{"sendmsg", __NR_sendmsg},
#endif
#endif
#ifdef SYS_sendto
#ifdef __NR_sendto
	{"sendto", __NR_sendto},
#endif
#endif
#ifdef SYS_set_mempolicy
#ifdef __NR_set_mempolicy
	{"set_mempolicy", __NR_set_mempolicy},
#endif
#endif
#ifdef SYS_set_robust_list
#ifdef __NR_set_robust_list
	{"set_robust_list", __NR_set_robust_list},
#endif
#endif
#ifdef SYS_set_tid_address
#ifdef __NR_set_tid_address
	{"set_tid_address", __NR_set_tid_address},
#endif
#endif
#ifdef SYS_setdomainname
#ifdef __NR_setdomainname
	{"setdomainname", __NR_setdomainname},
#endif
#endif
#ifdef SYS_setfsgid
#ifdef __NR_setfsgid
	{"setfsgid", __NR_setfsgid},
#endif
#endif
#ifdef SYS_setfsuid
#ifdef __NR_setfsuid
	{"setfsuid", __NR_setfsuid},
#endif
#endif
#ifdef SYS_setgid
#ifdef __NR_setgid
	{"setgid", __NR_setgid},
#endif
#endif
#ifdef SYS_setgroups
#ifdef __NR_setgroups
	{"setgroups", __NR_setgroups},
#endif
#endif
#ifdef SYS_sethostname
#ifdef __NR_sethostname
	{"sethostname", __NR_sethostname},
#endif
#endif
#ifdef SYS_setitimer
#ifdef __NR_setitimer
	{"setitimer", __NR_setitimer},
#endif
#endif
#ifdef SYS_setns
#ifdef __NR_setns
	{"setns", __NR_setns},
#endif
#endif
#ifdef SYS_setpgid
#ifdef __NR_setpgid
	{"setpgid", __NR_setpgid},
#endif
#endif
#ifdef SYS_setpriority
#ifdef __NR_setpriority
	{"setpriority", __NR_setpriority},
#endif
#endif
#ifdef SYS_setregid
#ifdef __NR_setregid
	{"setregid", __NR_setregid},
#endif
#endif
#ifdef SYS_setresgid
#ifdef __NR_setresgid
	{"setresgid", __NR_setresgid},
#endif
#endif
#ifdef SYS_setresuid
#ifdef __NR_setresuid
	{"setresuid", __NR_setresuid},
#endif
#endif
#ifdef SYS_setreuid
#ifdef __NR_setreuid
	{"setreuid", __NR_setreuid},
#endif
#endif
#ifdef SYS_setrlimit
#ifdef __NR_setrlimit
	{"setrlimit", __NR_setrlimit},
#endif
#endif
#ifdef SYS_setsid
#ifdef __NR_setsid
	{"setsid", __NR_setsid},
#endif
#endif
#ifdef SYS_setsockopt
#ifdef __NR_setsockopt
	{"setsockopt", __NR_setsockopt},
#endif
#endif
#ifdef SYS_settimeofday
#ifdef __NR_settimeofday
	{"settimeofday", __NR_settimeofday},
#endif
#endif
#ifdef SYS_setuid
#ifdef __NR_setuid
	{"setuid", __NR_setuid},
#endif
#endif
#ifdef SYS_setxattr
#ifdef __NR_setxattr
	{"setxattr", __NR_setxattr},
#endif
#endif
#ifdef SYS_shmat
#ifdef __NR_shmat
	{"shmat", __NR_shmat},
#endif
#endif
#ifdef SYS_shmctl
#ifdef __NR_shmctl
	{"shmctl", __NR_shmctl},
#endif
#endif
#ifdef SYS_shmdt
#ifdef __NR_shmdt
	{"shmdt", __NR_shmdt},
#endif
#endif
#ifdef SYS_shmget
#ifdef __NR_shmget
	{"shmget", __NR_shmget},
#endif
#endif
#ifdef SYS_shutdown
#ifdef __NR_shutdown
	{"shutdown", __NR_shutdown},
#endif
#endif
#ifdef SYS_sigaltstack
#ifdef __NR_sigaltstack
	{"sigaltstack", __NR_sigaltstack},
#endif
#endif
#ifdef SYS_signalfd
#ifdef __NR_signalfd
	{"signalfd", __NR_signalfd},
#endif
#endif
#ifdef SYS_signalfd4
#ifdef __NR_signalfd4
	{"signalfd4", __NR_signalfd4},
#endif
#endif
#ifdef SYS_socket
#ifdef __NR_socket
	{"socket", __NR_socket},
#endif
#endif
#ifdef SYS_socketpair
#ifdef __NR_socketpair
	{"socketpair", __NR_socketpair},
#endif
#endif
#ifdef SYS_splice
#ifdef __NR_splice
	{"splice", __NR_splice},
#endif
#endif
#ifdef SYS_stat
#ifdef __NR_stat
	{"stat", __NR_stat},
#endif
#endif
#ifdef SYS_statfs
#ifdef __NR_statfs
	{"statfs", __NR_statfs},
#endif
#endif
#ifdef SYS_statx
#ifdef __NR_statx
	{"statx", __NR_statx},
#endif
#endif
#ifdef SYS_swapoff
#ifdef __NR_swapoff
	{"swapoff", __NR_swapoff},
#endif
#endif
#ifdef SYS_swapon
#ifdef __NR_swapon
	{"swapon", __NR_swapon},
#endif
#endif
#ifdef SYS_symlink
#ifdef __NR_symlink
	{"symlink", __NR_symlink},
#endif
#endif
#ifdef SYS_symlinkat
#ifdef __NR_symlinkat
	{"symlinkat", __NR_symlinkat},
#endif
#endif
#ifdef SYS_sync
#ifdef __NR_sync
	{"sync", __NR_sync},
#endif
#endif
#ifdef SYS_sync_file_range
#ifdef __NR_sync_file_range
	{"sync_file_range", __NR_sync_file_range},
#endif
#endif
#ifdef SYS_syncfs
#ifdef __NR_syncfs
	{"syncfs", __NR_syncfs},
#endif
#endif
#ifdef SYS_sysfs
#ifdef __NR_sysfs
	{"sysfs", __NR_sysfs},
#endif
#endif
#ifdef SYS_sysinfo
#ifdef __NR_sysinfo
	{"sysinfo", __NR_sysinfo},
#endif
#endif
#ifdef SYS_syslog
#ifdef __NR_syslog
	{"syslog", __NR_syslog},
#endif
#endif
#ifdef SYS_tee
#ifdef __NR_tee
	{"tee", __NR_tee},
#endif
#endif
#ifdef SYS_tgkill
#ifdef __NR_tgkill
	{"tgkill", __NR_tgkill},
#endif
#endif
#ifdef SYS_time
#ifdef __NR_time
	{"time", __NR_time},
#endif
#endif
#ifdef SYS_timer_create
#ifdef __NR_timer_create
	{"timer_create", __NR_timer_create},
#endif
#endif
#ifdef SYS_timer_delete
#ifdef __NR_timer_delete
	{"timer_delete", __NR_timer_delete},
#endif
#endif
#ifdef SYS_timer_getoverrun
#ifdef __NR_timer_getoverrun
	{"timer_getoverrun", __NR_timer_getoverrun},
#endif
#endif
#ifdef SYS_timer_gettime
#ifdef __NR_timer_gettime
	{"timer_gettime", __NR_timer_gettime},
#endif
#endif
#ifdef SYS_timer_settime
#ifdef __NR_timer_settime
	{"timer_settime", __NR_timer_settime},
#endif
#endif
#ifdef SYS_timerfd_create
#ifdef __NR_timerfd_create
	{"timerfd_create", __NR_timerfd_create},
#endif
#endif
#ifdef SYS_timerfd_gettime
#ifdef __NR_timerfd_gettime
	{"timerfd_gettime", __NR_timerfd_gettime},
#endif
#endif
#ifdef SYS_timerfd_settime
#ifdef __NR_timerfd_settime
	{"timerfd_settime", __NR_timerfd_settime},
#endif
#endif
#ifdef SYS_times
#ifdef __NR_times
	{"times", __NR_times},
#endif
#endif
#ifdef SYS_tkill
#ifdef __NR_tkill
	{"tkill", __NR_tkill},
#endif
#endif
#ifdef SYS_truncate
#ifdef __NR_truncate
	{"truncate", __NR_truncate},
#endif
#endif
#ifdef SYS_tuxcall
#ifdef __NR_tuxcall
	{"tuxcall", __NR_tuxcall},
#endif
#endif
#ifdef SYS_umask
#ifdef __NR_umask
	{"umask", __NR_umask},
#endif
#endif
#ifdef SYS_umount2
#ifdef __NR_umount2
	{"umount2", __NR_umount2},
#endif
#endif
#ifdef SYS_uname
#ifdef __NR_uname
	{"uname", __NR_uname},
#endif
#endif
#ifdef SYS_unlink
#ifdef __NR_unlink
	{"unlink", __NR_unlink},
#endif
#endif
#ifdef SYS_unlinkat
#ifdef __NR_unlinkat
	{"unlinkat", __NR_unlinkat},
#endif
#endif
#ifdef SYS_unshare
#ifdef __NR_unshare
	{"unshare", __NR_unshare},
#endif
#endif
#ifdef SYS_userfaultfd
#ifdef __NR_userfaultfd
	{"userfaultfd", __NR_userfaultfd},
#endif
#endif
#ifdef SYS_ustat
#ifdef __NR_ustat
	{"ustat", __NR_ustat},
#endif
#endif
#ifdef SYS_utime
#ifdef __NR_utime
	{"utime", __NR_utime},
#endif
#endif
#ifdef SYS_utimensat
#ifdef __NR_utimensat
	{"utimensat", __NR_utimensat},
#endif
#endif
#ifdef SYS_utimes
#ifdef __NR_utimes
	{"utimes", __NR_utimes},
#endif
#endif
#ifdef SYS_vfork
#ifdef __NR_vfork
	{"vfork", __NR_vfork},
#endif
#endif
#ifdef SYS_vhangup
#ifdef __NR_vhangup
	{"vhangup", __NR_vhangup},
#endif
#endif
#ifdef SYS_vmsplice
#ifdef __NR_vmsplice
	{"vmsplice", __NR_vmsplice},
#endif
#endif
#ifdef SYS_wait4
#ifdef __NR_wait4
	{"wait4", __NR_wait4},
#endif
#endif
#ifdef SYS_waitid
#ifdef __NR_waitid
	{"waitid", __NR_waitid},
#endif
#endif
#ifdef SYS_write
#ifdef __NR_write
	{"write", __NR_write},
#endif
#endif
#ifdef SYS_writev
#ifdef __NR_writev
	{"writev", __NR_writev},
#endif
#endif
#endif
//#endif
