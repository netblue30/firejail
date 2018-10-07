# Firejail profile for remmina
# Description: GTK+ Remote Desktop Client
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/remmina.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.remmina
noblacklist ${HOME}/.config/remmina
noblacklist ${HOME}/.local/share/remmina
noblacklist ${HOME}/.ssh

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
# seccomp.keep access,arch_prctl,brk,chmod,clock_getres,clock_gettime,clone,close,connect,dup3,eventfd2,execve,fadvise64,fallocate,fcntl,flock,fstat,fstatfs,fsync,ftruncate,futex,getdents,getegid,geteuid,getgid,getpeername,getpid,getrandom,getresgid,getresuid,getsockname,getsockopt,gettid,getuid,inotify_add_watch,inotify_init1,inotify_rm_watch,ioctl,lseek,lstat,madvise,memfd_create,mmap,mprotect,mremap,munmap,nanosleep,open,openat,pipe,pipe2,poll,prctl,prlimit64,pwrite64,read,readlink,recvfrom,recvmsg,rename,rt_sigaction,rt_sigprocmask,sendmmsg,sendmsg,sendto,set_robust_list,setsockopt,set_tid_address,shmat,shmctl,shmdt,shmget,shutdown,socket,stat,statfs,sysinfo,tgkill,uname,utimensat,write,writev
shell none

private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
