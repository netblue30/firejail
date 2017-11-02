# Firejail profile for digikam
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/digikam.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/digikam
noblacklist ${HOME}/.config/digikamrc
noblacklist ${HOME}/.kde/share/apps/digikam
noblacklist ${HOME}/.kde4/share/apps/digikam

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
# seccomp.keep fallocate,getrusage,openat,access,arch_prctl,bind,brk,chdir,chmod,clock_getres,clone,close,connect,dup2,dup3,eventfd2,execve,fadvise64,fcntl,fdatasync,flock,fstat,fstatfs,ftruncate,futex,getcwd,getdents,getegid,geteuid,getgid,getpeername,getpgrp,getpid,getppid,getrandom,getresgid,getresuid,getrlimit,getsockname,getsockopt,gettid,getuid,inotify_add_watch,inotify_init,inotify_init1,inotify_rm_watch,ioctl,lseek,lstat,madvise,mbind,memfd_create,mkdir,mmap,mprotect,msync,munmap,nanosleep,open,pipe,pipe2,poll,ppoll,prctl,pread64,pwrite64,read,readlink,readlinkat,recvfrom,recvmsg,rename,rt_sigaction,rt_sigprocmask,rt_sigreturn,sched_getaffinity,sched_getparam,sched_get_priority_max,sched_get_priority_min,sched_getscheduler,sched_setscheduler,sched_yield,sendmsg,sendto,setgid,setresgid,setresuid,set_robust_list,setsid,setsockopt,set_tid_address,setuid,shmat,shmctl,shmdt,shmget,shutdown,socket,stat,statfs,sysinfo,timerfd_create,umask,uname,unlink,wait4,waitid,write,writev,fchmod,fchown,unshare,exit,exit_group
shell none

# private-bin program
# private-dev - prevents libdc1394 loading; this lib is used to connect to a camera device
# private-etc none
private-tmp

noexec ${HOME}
noexec /tmp
