# Firejail profile for akregator
# Description: RSS/Atom feed aggregator
# This file is overwritten after every install/update
# Persistent local customizations
include akregator.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/akregatorrc
noblacklist ${HOME}/.local/share/akregator

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkfile ${HOME}/.config/akregatorrc
mkdir ${HOME}/.local/share/akregator
whitelist ${HOME}/.config/akregatorrc
whitelist ${HOME}/.local/share/akregator
whitelist ${HOME}/.local/share/kssl
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
# chroot syscalls are needed for setting up the built-in sandbox
seccomp.drop @clock,@cpu-emulation,@debug,@module,@obsolete,@raw-io,@reboot,@resources,@swap,acct,add_key,bpf,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,ioprio_set,kcmp,keyctl,mount,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,personality,pivot_root,process_vm_readv,ptrace,remap_file_pages,request_key,setdomainname,sethostname,syslog,umount,umount2,userfaultfd,vhangup,vmsplice
shell none

disable-mnt
private-bin akregator,akregatorstorageexporter,dbus-launch,kdeinit4,kdeinit4_shutdown,kdeinit4_wrapper,kdeinit5,kdeinit5_shutdown,kdeinit5_wrapper,kshell4,kshell5
private-dev
private-tmp

