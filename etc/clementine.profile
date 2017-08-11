# Firejail profile for clementine
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/clementine.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/Clementine

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
# Clementine makes ioprio_set system calls, which are blacklisted by default.
seccomp.drop mount,umount2,ptrace,kexec_load,kexec_file_load,name_to_handle_at,open_by_handle_at,create_module,init_module,finit_module,delete_module,iopl,ioperm,swapon,swapoff,syslog,process_vm_readv,process_vm_writev,sysfs,_sysctl,adjtimex,clock_adjtime,lookup_dcookie,perf_event_open,fanotify_init,kcmp,add_key,request_key,keyctl,uselib,acct,modify_ldt,pivot_root,io_setup,io_destroy,io_getevents,io_submit,io_cancel,remap_file_pages,mbind,get_mempolicy,set_mempolicy,migrate_pages,move_pages,vmsplice,chroot,tuxcall,reboot,mfsservctl,get_kernel_syms,bpf,clock_settime,personality,process_vm_writev,query_module,settimeofday,stime,umount,userfaultfd,ustat,vm86,vm86old
