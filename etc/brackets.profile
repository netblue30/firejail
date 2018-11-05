# Firejail profile for brackets
# This file is overwritten after every install/update
# Persistent local customizations
include brackets.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Brackets
#noblacklist /opt/brackets/
#noblacklist /opt/google/

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp.drop @clock,@cpu-emulation,@debug,@module,@obsolete,@reboot,@resources,@swap,acct,add_key,bpf,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,iopl,ioprio_set,kcmp,keyctl,mount,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,pciconfig_iobase,pciconfig_read,pciconfig_write,personality,pivot_root,process_vm_readv,ptrace,remap_file_pages,request_key,s390_mmio_read,s390_mmio_write,setdomainname,sethostname,syslog,umount,umount2,userfaultfd,vhangup,vmsplice
shell none

private-cache
private-dev
