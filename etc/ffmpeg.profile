# Firejail profile for default
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/ffmpeg.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
no3d
nodvd
nosound
notv
novideo
nonewprivs
noroot
# protocol none - needs to be implemented!
seccomp
# seccomp.keep futex,write,read,munmap,fstat,mprotect,mmap,open,close,stat,lseek,brk,rt_sigaction,rt_sigprocmask,ioctl,access,select,madvise,getpid,clone,execve,fcntl,getdents,readlink,getrlimit,getrusage,statfs,getpriority,setpriority,arch_prctl,sched_getaffinity,set_tid_address,set_robust_list,getrandom
# memory-deny-write-execute - it breaks old versions of ffmpeg
shell none
tracelog

private-tmp
private-dev
private-bin ffmpeg
include /etc/firejail/whitelist-var-common.inc
