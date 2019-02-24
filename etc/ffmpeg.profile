# Firejail profile for ffmpeg
# Description: Tools for transcoding, streaming and playing of multimedia files
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ffmpeg.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
no3d
nodbus
nodvd
nosound
notv
nou2f
novideo
nonewprivs
noroot
# protocol none - needs to be implemented!
seccomp
# seccomp.keep futex,write,read,munmap,fstat,mprotect,mmap,open,close,stat,lseek,brk,rt_sigaction,rt_sigprocmask,ioctl,access,select,madvise,getpid,clone,execve,fcntl,getdents,readlink,getrlimit,getrusage,statfs,getpriority,setpriority,arch_prctl,sched_getaffinity,set_tid_address,set_robust_list,getrandom
shell none
tracelog

private-bin ffmpeg
private-cache
private-dev
private-tmp

# memory-deny-write-execute - it breaks old versions of ffmpeg
noexec ${HOME}
noexec /tmp
