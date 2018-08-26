# Firejail profile for ffmpeg
# Description: Tools for transcoding, streaming and playing of multimedia files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/ffmpeg.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
net none
no3d
nodbus
nodvd
nosound
notv
novideo
nonewprivs
noroot
# protocol none - needs to be implemented!
seccomp
# seccomp.keep futex,write,read,munmap,fstat,mprotect,mmap,open,close,stat,lseek,brk,rt_sigaction,rt_sigprocmask,ioctl,access,select,madvise,getpid,clone,execve,fcntl,getdents,readlink,getrlimit,getrusage,statfs,getpriority,setpriority,arch_prctl,sched_getaffinity,set_tid_address,set_robust_list,getrandom
shell none
tracelog

private-bin ffmpeg
private-dev
private-tmp

# memory-deny-write-execute - it breaks old versions of ffmpeg
