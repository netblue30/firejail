# Firejail profile for mupdf
# Description: Lightweight PDF viewer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mupdf.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${DOCUMENTS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
machine-id
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
# seccomp.keep access,arch_prctl,brk,clone,close,connect,execve,exit_group,fchmod,fchown,fcntl,fstat,futex,getcwd,getpeername,getrlimit,getsockname,getsockopt,lseek,lstat,mlock,mmap,mprotect,mremap,munmap,nanosleep,open,poll,prctl,read,recvfrom,recvmsg,restart_syscall,rt_sigaction,rt_sigprocmask,select,sendmsg,set_robust_list,set_tid_address,setresgid,setresuid,shmat,shmctl,shmget,shutdown,socket,stat,sysinfo,uname,unshare,wait4,write,writev
shell none
tracelog

# private-bin mupdf,sh,tempfile,rm
private-dev
private-etc fonts
private-tmp

# mupdf will never write anything
read-only ${HOME}
