# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/baloo_file.local

# KDE Baloo file daemon profile
noblacklist ${HOME}/.kde4/share/config/baloofilerc
noblacklist ${HOME}/.kde4/share/config/baloorc
noblacklist ${HOME}/.kde/share/config/baloofilerc
noblacklist ${HOME}/.kde/share/config/baloorc
noblacklist ${HOME}/.config/baloofilerc
noblacklist ${HOME}/.local/share/baloo
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
# Baloo makes ioprio_set system calls, which are blacklisted by default.
seccomp.drop mount,umount2,ptrace,kexec_load,kexec_file_load,name_to_handle_at,open_by_handle_at,create_module,init_module,finit_module,delete_module,iopl,ioperm,swapon,swapoff,syslog,process_vm_readv,process_vm_writev,sysfs,_sysctl,adjtimex,clock_adjtime,lookup_dcookie,perf_event_open,fanotify_init,kcmp,add_key,request_key,keyctl,uselib,acct,modify_ldt,pivot_root,io_setup,io_destroy,io_getevents,io_submit,io_cancel,remap_file_pages,mbind,get_mempolicy,set_mempolicy,migrate_pages,move_pages,vmsplice,chroot,tuxcall,reboot,mfsservctl,get_kernel_syms,bpf,clock_settime,personality,process_vm_writev,query_module,settimeofday,stime,umount,userfaultfd,ustat,vm86,vm86old

blacklist /tmp/.X11-unix

private-dev
private-tmp

# Experimental: make home directory read-only and allow writing only
# to Baloo configuration files and databases
#read-only  ${HOME}
#read-write ${HOME}/.kde4/share/config/baloofilerc
#read-write ${HOME}/.kde4/share/config/baloorc
#read-write ${HOME}/.kde/share/config/baloofilerc
#read-write ${HOME}/.kde/share/config/baloorc
#read-write ${HOME}/.config/baloofilerc
#read-write ${HOME}/.local/share/baloo
#read-write ${HOME}/.local/share/akonadi/search_db
