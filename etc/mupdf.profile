# mupdf reader profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
netfilter
shell none
tracelog

private-tmp
private-dev
private-etc fonts

# mupdf will never write anything
read-only ${HOME}

#
# Experimental:
#
#seccomp.keep access,arch_prctl,brk,clone,close,connect,execve,exit_group,fchmod,fchown,fcntl,fstat,futex,getcwd,getpeername,getrlimit,getsockname,getsockopt,lseek,lstat,mlock,mmap,mprotect,mremap,munmap,nanosleep,open,poll,prctl,read,recvfrom,recvmsg,restart_syscall,rt_sigaction,rt_sigprocmask,select,sendmsg,set_robust_list,set_tid_address,setresgid,setresuid,shmat,shmctl,shmget,shutdown,socket,stat,sysinfo,uname,unshare,wait4,write,writev
# private-bin mupdf,sh,tempfile,rm
