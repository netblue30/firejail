# Firejail profile for Mozilla Firefox (Iceweasel in Debian)
noblacklist ${HOME}/.mozilla
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
caps.drop all

#seccomp.drop @clock,@cpu-emulation,@debug,@module,@obsolete,@raw-io,@reboot,@resources,@swap,acct,add_key,bpf,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,ioprio_set,kcmp,keyctl,mount,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,personality,pivot_root,process_vm_readv,ptrace,remap_file_pages,request_key,setdomainname,sethostname,syslog,umount,umount2,userfaultfd,vhangup,vmsplice
seccomp.drop adjtimex,clock_adjtime,clock_settime,settimeofday,stime,modify_ldt,subpage_prot,switch_endian,vm86,vm86old,lookup_dcookie,perf_event_open,process_vm_writev,rtas,s390_runtime_instr,sys_debug_setcontext,delete_module,finit_module,init_module,_sysctl,afs_syscall,bdflush,break,create_module,ftime,get_kernel_syms,getpmsg,gtty,lock,mpx,prof,profil,putpmsg,query_module,security,sgetmask,ssetmask,stty,sysfs,tuxcall,ulimit,uselib,ustat,vserver,ioperm,iopl,pciconfig_iobase,pciconfig_read,pciconfig_write,s390_pci_mmio_read,s390_pci_mmio_write,kexec_load,kexec_file_load,reboot,set_mempolicy,migrate_pages,move_pages,mbind,swapon,swapoff,acct,add_key,bpf,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,ioprio_set,kcmp,keyctl,mount,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,personality,pivot_root,process_vm_readv,ptrace,remap_file_pages,request_key,setdomainname,sethostname,syslog,umount,umount2,userfaultfd,vhangup,vmsplice

protocol unix,inet,inet6,netlink
netfilter
# tracelog
noroot
whitelist ${DOWNLOADS}
whitelist ${HOME}/.mozilla
whitelist ${HOME}/.cache/mozilla/firefox
whitelist ${HOME}/dwhelper
whitelist ${HOME}/.zotero
whitelist ${HOME}/.lastpass
whitelist ${HOME}/.vimperatorrc
whitelist ${HOME}/.vimperator
whitelist ${HOME}/.pentadactylrc
whitelist ${HOME}/.pentadactyl
whitelist ${HOME}/.keysnail.js
whitelist ${HOME}/.config/gnome-mplayer
whitelist ${HOME}/.cache/gnome-mplayer/plugin
include /etc/firejail/whitelist-common.inc

# experimental features
#private-etc alternatives,passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,gtk-2.0,pango,fonts,iceweasel,firefox,adobe,mime.types,mailcap,asound.conf,pulse
