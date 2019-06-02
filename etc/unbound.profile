# Firejail profile for unbound
# Description: Validating, recursive, caching DNS resolver
# This file is overwritten after every install/update
# Persistent local customizations
include unbound.local
# Persistent global definitions
include globals.local

noblacklist /sbin
noblacklist /usr/sbin

blacklist /tmp/.X11-unix

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /var/lib/unbound
whitelist /var/run

caps.keep net_admin,net_bind_service,setgid,setuid,sys_chroot,sys_resource
no3d
nodvd
nonewprivs
nosound
notv
nou2f
novideo
seccomp.drop mount,umount2,ptrace,kexec_load,kexec_file_load,open_by_handle_at,init_module,finit_module,delete_module,iopl,ioperm,swapon,swapoff,syslog,process_vm_readv,process_vm_writev,sysfs,_sysctl,adjtimex,clock_adjtime,lookup_dcookie,perf_event_open,fanotify_init,kcmp,add_key,request_key,keyctl,uselib,acct,modify_ldt,pivot_root,io_setup,io_destroy,io_getevents,io_submit,io_cancel,remap_file_pages,mbind,get_mempolicy,set_mempolicy,migrate_pages,move_pages,vmsplice,perf_event_open
writable-var

disable-mnt
private
private-dev

# mdwe can break modules/plugins
memory-deny-write-execute
