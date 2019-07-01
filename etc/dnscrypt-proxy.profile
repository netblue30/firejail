# Firejail profile for dnscrypt-proxy
# Description: Tool for securing communications between a client and a DNS resolver
# This file is overwritten after every install/update
# Persistent local customizations
include dnscrypt-proxy.local
# Persistent global definitions
include globals.local

noblacklist /sbin
noblacklist /usr/sbin

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.keep ipc_lock,net_bind_service,setgid,setuid,sys_chroot
ipc-namespace
machine-id
no3d
nodbus
nodvd
nonewprivs
nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp.drop _sysctl,acct,add_key,adjtimex,clock_adjtime,delete_module,fanotify_init,finit_module,get_mempolicy,init_module,io_cancel,io_destroy,io_getevents,io_setup,io_submit,ioperm,iopl,kcmp,kexec_file_load,kexec_load,keyctl,lookup_dcookie,mbind,migrate_pages,modify_ldt,mount,move_pages,open_by_handle_at,perf_event_open,perf_event_open,pivot_root,process_vm_readv,process_vm_writev,ptrace,remap_file_pages,request_key,set_mempolicy,swapoff,swapon,sysfs,syslog,umount2,uselib,vmsplice
x11 none

disable-mnt
private
private-cache
private-dev

# mdwe can break modules/plugins
memory-deny-write-execute
