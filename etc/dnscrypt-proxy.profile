# Firejail profile for dnscrypt-proxy
# Description: Tool for securing communications between a client and a DNS resolver
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dnscrypt-proxy.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

noblacklist /sbin
noblacklist /usr/sbin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.keep ipc_lock,net_bind_service,setgid,setuid,sys_chroot
no3d
nodvd
nonewprivs
nosound
notv
novideo
seccomp.drop mount,umount2,ptrace,kexec_load,kexec_file_load,open_by_handle_at,init_module,finit_module,delete_module,iopl,ioperm,swapon,swapoff,syslog,process_vm_readv,process_vm_writev,sysfs,_sysctl,adjtimex,clock_adjtime,lookup_dcookie,perf_event_open,fanotify_init,kcmp,add_key,request_key,keyctl,uselib,acct,modify_ldt,pivot_root,io_setup,io_destroy,io_getevents,io_submit,io_cancel,remap_file_pages,mbind,get_mempolicy,set_mempolicy,migrate_pages,move_pages,vmsplice,perf_event_open

disable-mnt
private
private-cache
private-dev

# mdwe can break modules/plugins
memory-deny-write-execute
