# Firejail profile for riot-desktop
# Description: A glossy Matrix collaboration client for the desktop
# This file is overwritten after every install/update
# Persistent local customizations
include riot-desktop.local
# Persistent global definitions
# added by included profile
#include globals.local

ignore seccomp
seccomp.drop @clock,@cpu-emulation,@debug,@module,@obsolete,@raw-io,@reboot,@resources,@swap,acct,add_key,bpf,fanotify_init,io_cancel,io_destroy,io_getevents,ioprio_set,io_setup,io_submit,kcmp,keyctl,mincore,mount,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,pivot_root,remap_file_pages,request_key,setdomainname,sethostname,syslog,umount,umount2,userfaultfd,vhangup,vmsplice

# Redirect
include riot-web.profile
