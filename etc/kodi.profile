# Firejail profile for kodi
# Description: Open Source Home Theatre
# This file is overwritten after every install/update
# Persistent local customizations
include kodi.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.kodi
noblacklist ${MUSIC}
noblacklist ${PICTURES}
noblacklist ${VIDEOS}

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nogroups
nonewprivs
noroot
nou2f
protocol unix,inet,inet6,netlink
seccomp.drop _sysctl,acct,add_key,adjtimex,afs_syscall,bdflush,bpf,break,chroot,clock_adjtime,clock_settime,create_module,delete_module,fanotify_init,finit_module,ftime,get_kernel_syms,getpmsg,gtty,init_module,io_cancel,io_destroy,io_getevents,io_setup,io_submit,ioperm,iopl,ioprio_set,kcmp,kexec_file_load,kexec_load,keyctl,lock,lookup_dcookie,mbind,migrate_pages,modify_ldt,mount,move_pages,mpx,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,pciconfig_iobase,pciconfig_read,pciconfig_write,perf_event_open,personality,pivot_root,process_vm_readv,process_vm_writev,prof,profil,ptrace,putpmsg,query_module,reboot,remap_file_pages,request_key,rtas,s390_mmio_read,s390_mmio_write,s390_runtime_instr,security,set_mempolicy,setdomainname,sethostname,settimeofday,sgetmask,ssetmask,stime,stty,subpage_prot,swapoff,swapon,switch_endian,sys_debug_setcontext,sysfs,syslog,tuxcall,ulimit,umount,umount2,uselib,userfaultfd,ustat,vhangup,vm86,vm86old,vmsplice,vserver
shell none
tracelog

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
