" Vim syntax file
" Language: Firejail security sandbox profile
" URL: https://github.com/netblue30/firejail

if exists("b:current_syntax")
  finish
endif


syn iskeyword @,48-57,_,.,-


syn keyword fjTodo TODO FIXME XXX NOTE contained
syn match fjComment "#.*$" contains=fjTodo

"TODO: highlight "dangerous" capabilities differently, as is done in apparmor.vim?
syn keyword fjCapability audit_control audit_read audit_write block_suspend chown dac_override dac_read_search fowner fsetid ipc_lock ipc_owner kill lease linux_immutable mac_admin mac_override mknod net_admin net_bind_service net_broadcast net_raw setgid setfcap setpcap setuid sys_admin sys_boot sys_chroot sys_module sys_nice sys_pacct sys_ptrace sys_rawio sys_resource sys_time sys_tty_config syslog wake_alarm nextgroup=fjCapabilityList contained
syn match fjCapabilityList /,/ nextgroup=fjCapability contained

syn keyword fjProtocol unix inet inet6 netlink packet nextgroup=fjProtocolList contained
syn match fjProtocolList /,/ nextgroup=fjProtocol contained

" Syscalls grabbed from: src/include/syscall.h
" Generate list with: rg -o '"([^"]+)' -r '$1' src/include/syscall.h | sort -u | tr $'\n' ' '
syn keyword fjSyscall _llseek _newselect _sysctl accept accept4 access acct add_key adjtimex afs_syscall alarm arch_prctl bdflush bind bpf break brk capget capset chdir chmod chown chown32 chroot clock_adjtime clock_getres clock_gettime clock_nanosleep clock_settime clone close connect copy_file_range creat create_module delete_module dup dup2 dup3 epoll_create epoll_create1 epoll_ctl epoll_ctl_old epoll_pwait epoll_wait epoll_wait_old eventfd eventfd2 execve execveat exit exit_group faccessat fadvise64 fadvise64_64 fallocate fanotify_init fanotify_mark fchdir fchmod fchmodat fchown fchown32 fchownat fcntl fcntl64 fdatasync fgetxattr finit_module flistxattr flock fork fremovexattr fsetxattr fstat fstat64 fstatat64 fstatfs fstatfs64 fsync ftime ftruncate ftruncate64 futex futimesat get_kernel_syms get_mempolicy get_robust_list get_thread_area getcpu getcwd getdents getdents64 getegid getegid32 geteuid geteuid32 getgid getgid32 getgroups getgroups32 getitimer getpeername getpgid getpgrp getpid getpmsg getppid getpriority getrandom getresgid getresgid32 getresuid getresuid32 getrlimit getrusage getsid getsockname getsockopt gettid gettimeofday getuid getuid32 getxattr gtty idle init_module inotify_add_watch inotify_init inotify_init1 inotify_rm_watch io_cancel io_destroy io_getevents io_setup io_submit ioctl ioperm iopl ioprio_get ioprio_set ipc kcmp kexec_file_load kexec_load keyctl kill lchown lchown32 lgetxattr link linkat listen listxattr llistxattr lock lookup_dcookie lremovexattr lseek lsetxattr lstat lstat64 madvise mbind membarrier memfd_create migrate_pages mincore mkdir mkdirat mknod mknodat mlock mlock2 mlockall mmap mmap2 modify_ldt mount move_pages mprotect mpx mq_getsetattr mq_notify mq_open mq_timedreceive mq_timedsend mq_unlink mremap msgctl msgget msgrcv msgsnd msync munlock munlockall munmap name_to_handle_at nanosleep newfstatat nfsservctl nice oldfstat oldlstat oldolduname oldstat olduname open open_by_handle_at openat pause perf_event_open personality pipe pipe2 pivot_root pkey_alloc pkey_free pkey_mprotect poll ppoll prctl pread64 preadv preadv2 prlimit64 process_vm_readv process_vm_writev prof profil pselect6 ptrace putpmsg pwrite64 pwritev pwritev2 query_module quotactl read readahead readdir readlink readlinkat readv reboot recvfrom recvmmsg recvmsg remap_file_pages removexattr rename renameat renameat2 request_key restart_syscall rmdir rt_sigaction rt_sigpending rt_sigprocmask rt_sigqueueinfo rt_sigreturn rt_sigsuspend rt_sigtimedwait rt_tgsigqueueinfo sched_get_priority_max sched_get_priority_min sched_getaffinity sched_getattr sched_getparam sched_getscheduler sched_rr_get_interval sched_setaffinity sched_setattr sched_setparam sched_setscheduler sched_yield seccomp security select semctl semget semop semtimedop sendfile sendfile64 sendmmsg sendmsg sendto set_mempolicy set_robust_list set_thread_area set_tid_address setdomainname setfsgid setfsgid32 setfsuid setfsuid32 setgid setgid32 setgroups setgroups32 sethostname setitimer setns setpgid setpriority setregid setregid32 setresgid setresgid32 setresuid setresuid32 setreuid setreuid32 setrlimit setsid setsockopt settimeofday setuid setuid32 setxattr sgetmask shmat shmctl shmdt shmget shutdown sigaction sigaltstack signal signalfd signalfd4 sigpending sigprocmask sigreturn sigsuspend socket socketcall socketpair splice ssetmask stat stat64 statfs statfs64 statx stime stty swapoff swapon symlink symlinkat sync sync_file_range syncfs sysfs sysinfo syslog tee tgkill time timer_create timer_delete timer_getoverrun timer_gettime timer_settime timerfd_create timerfd_gettime timerfd_settime times tkill truncate truncate64 tuxcall ugetrlimit ulimit umask umount umount2 uname unlink unlinkat unshare uselib userfaultfd ustat utime utimensat utimes vfork vhangup vm86 vm86old vmsplice vserver wait4 waitid waitpid write writev nextgroup=fjSyscallErrno contained
" Syscall groups grabbed from: src/fseccomp/syscall.c
" Generate list with: rg -o '"@([^",]+)' -r '$1' src/fseccomp/syscall.c | sort -u | tr $'\n' '|'
syn match fjSyscall /\v\@(clock|cpu-emulation|debug|default|default-keep|default-nodebuggers|module|obsolete|privileged|raw-io|reboot|resources|swap)>/ nextgroup=fjSyscallErrno contained
syn match fjSyscall /\$[0-9]\+/ nextgroup=fjSyscallErrno contained
" Errnos grabbed from: src/fseccomp/errno.c
" Generate list with: rg -o '"(E[^"]+)' -r '$1' src/fseccomp/errno.c | sort -u | tr $'\n' '|'
syn match fjSyscallErrno /\v(:(E2BIG|EACCES|EADDRINUSE|EADDRNOTAVAIL|EADV|EAFNOSUPPORT|EAGAIN|EALREADY|EBADE|EBADF|EBADFD|EBADMSG|EBADR|EBADRQC|EBADSLT|EBFONT|EBUSY|ECANCELED|ECHILD|ECHRNG|ECOMM|ECONNABORTED|ECONNREFUSED|ECONNRESET|EDEADLK|EDEADLOCK|EDESTADDRREQ|EDOM|EDOTDOT|EDQUOT|EEXIST|EFAULT|EFBIG|EHOSTDOWN|EHOSTUNREACH|EHWPOISON|EIDRM|EILSEQ|EINPROGRESS|EINTR|EINVAL|EIO|EISCONN|EISDIR|EISNAM|EKEYEXPIRED|EKEYREJECTED|EKEYREVOKED|EL2HLT|EL2NSYNC|EL3HLT|EL3RST|ELIBACC|ELIBBAD|ELIBEXEC|ELIBMAX|ELIBSCN|ELNRNG|ELOOP|EMEDIUMTYPE|EMFILE|EMLINK|EMSGSIZE|EMULTIHOP|ENAMETOOLONG|ENAVAIL|ENETDOWN|ENETRESET|ENETUNREACH|ENFILE|ENOANO|ENOATTR|ENOBUFS|ENOCSI|ENODATA|ENODEV|ENOENT|ENOEXEC|ENOKEY|ENOLCK|ENOLINK|ENOMEDIUM|ENOMEM|ENOMSG|ENONET|ENOPKG|ENOPROTOOPT|ENOSPC|ENOSR|ENOSTR|ENOSYS|ENOTBLK|ENOTCONN|ENOTDIR|ENOTEMPTY|ENOTNAM|ENOTRECOVERABLE|ENOTSOCK|ENOTSUP|ENOTTY|ENOTUNIQ|ENXIO|EOPNOTSUPP|EOVERFLOW|EOWNERDEAD|EPERM|EPFNOSUPPORT|EPIPE|EPROTO|EPROTONOSUPPORT|EPROTOTYPE|ERANGE|EREMCHG|EREMOTE|EREMOTEIO|ERESTART|ERFKILL|EROFS|ESHUTDOWN|ESOCKTNOSUPPORT|ESPIPE|ESRCH|ESRMNT|ESTALE|ESTRPIPE|ETIME|ETIMEDOUT|ETOOMANYREFS|ETXTBSY|EUCLEAN|EUNATCH|EUSERS|EWOULDBLOCK|EXDEV|EXFULL)>)?/ nextgroup=fjSyscallList contained
syn match fjSyscallList /,/ nextgroup=fjSyscall contained

syn keyword fjX11Sandbox none xephyr xorg xpra xvfb contained

syn match fjEnvVar "[A-Za-z0-9_]\+=" contained
syn match fjRmenvVar "[A-Za-z0-9_]\+" contained

syn keyword fjAll all contained
syn keyword fjNone none contained
syn keyword fjLo lo contained

" Variable names grabbed from: src/firejail/macros.c
" Generate list with: rg -o '\$\{([^}]+)\}' -r '$1' src/firejail/macros.c | sort -u | tr $'\n' '|'
syn match fjVar /\v\$\{(CFG|DESKTOP|DOCUMENTS|DOWNLOADS|HOME|MUSIC|PATH|PICTURES|RUNUSER|VIDEOS)}/

" Commands grabbed from: src/firejail/profile.c
" Generate list with: { rg -o 'strn?cmp\(ptr, "([^"]+) "' -r '$1' src/firejail/profile.c; echo private-lib; } | grep -vEx '(include|ignore|caps\.drop|caps\.keep|protocol|seccomp|seccomp\.drop|seccomp\.keep|env|rmenv|net|ip)' | sort -u | tr $'\n' '|' # private-lib is special-cased in the code and doesn't match the regex; grep-ed patterns are handled later with 'syn match nextgroup=' directives (except for include which is special-cased as a fjCommandNoCond keyword)
syn match fjCommand /\v(bind|blacklist|blacklist-nolog|cgroup|cpu|defaultgw|dns|hostname|hosts-file|ip6|iprange|join-or-start|mac|mkdir|mkfile|mtu|name|netfilter|netfilter6|netmask|nice|noblacklist|noexec|nowhitelist|overlay-named|private|private-bin|private-etc|private-home|private-lib|private-opt|private-srv|read-only|read-write|rlimit-as|rlimit-cpu|rlimit-fsize|rlimit-nofile|rlimit-nproc|rlimit-sigpending|timeout|tmpfs|veth-name|whitelist|xephyr-screen) / skipwhite contained
" Generate list with: rg -o 'strn?cmp\(ptr, "([^ "]*[^ ])"' -r '$1' src/firejail/profile.c | grep -vEx '(include|rlimit|quiet)' | sed -e 's/\./\\./' | sort -u | tr $'\n' '|' # include/rlimit are false positives, quiet is special-cased below
syn match fjCommand /\v(allusers|apparmor|caps|disable-mnt|ipc-namespace|keep-dev-shm|keep-var-tmp|machine-id|memory-deny-write-execute|netfilter|no3d|noautopulse|nodbus|nodvd|nogroups|nonewprivs|noroot|nosound|notv|nou2f|novideo|overlay|overlay-tmpfs|private|private-cache|private-dev|private-lib|private-tmp|seccomp|seccomp\.block-secondary|tracelog|writable-etc|writable-run-user|writable-var|writable-var-log|x11)$/ contained
syn match fjCommand /ignore / nextgroup=fjCommand,fjCommandNoCond skipwhite contained
syn match fjCommand /caps\.drop / nextgroup=fjCapability,fjAll skipwhite contained
syn match fjCommand /caps\.keep / nextgroup=fjCapability skipwhite contained
syn match fjCommand /protocol / nextgroup=fjProtocol skipwhite contained
syn match fjCommand /\vseccomp(\.drop|\.keep)? / nextgroup=fjSyscall skipwhite contained
syn match fjCommand /x11 / nextgroup=fjX11Sandbox skipwhite contained
syn match fjCommand /env / nextgroup=fjEnvVar skipwhite contained
syn match fjCommand /rmenv / nextgroup=fjRmenvVar skipwhite contained
syn match fjCommand /shell / nextgroup=fjNone skipwhite contained
syn match fjCommand /net / nextgroup=fjNone,fjLo skipwhite contained
syn match fjCommand /ip / nextgroup=fjNone skipwhite contained
" Commands that can't be inside a ?CONDITIONAL: statement
syn match fjCommandNoCond /include / skipwhite contained
syn match fjCommandNoCond /quiet$/ contained

" Conditionals grabbed from: src/firejail/profile.c
" Generate list with: awk -- 'BEGIN {process=0;} /^Cond conditionals\[\] = \{$/ {process=1;} /\t*\{"[^"]+".*/ { if (process) {print gensub(/^\t*\{"([^"]+)".*$/, "\\1", 1);} } /^\t\{ NULL, NULL \}$/ {process=0;}' src/firejail/profile.c | sort -u | tr $'\n' '|'
syn match fjConditional /\v\?(BROWSER_ALLOW_DRM|BROWSER_DISABLE_U2F|HAS_APPIMAGE|HAS_NODBUS) ?:/ nextgroup=fjCommand skipwhite contained

" A line is either a command, a conditional or a comment
syn match fjStatement /^/ nextgroup=fjCommand,fjCommandNoCond,fjConditional,fjComment

hi def link fjTodo Todo
hi def link fjComment Comment
hi def link fjCommand Statement
hi def link fjCommandNoCond Statement
hi def link fjConditional Macro
hi def link fjVar Identifier
hi def link fjCapability Type
hi def link fjProtocol Type
hi def link fjSyscall Type
hi def link fjSyscallErrno Constant
hi def link fjX11Sandbox Type
hi def link fjEnvVar Type
hi def link fjRmenvVar Type
hi def link fjAll Type
hi def link fjNone Type
hi def link fjLo Type


let b:current_syntax = "firejail"
