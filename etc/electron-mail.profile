# Firejail profile for electron-mail
# Description: Unofficial desktop app for several E2E encrypted email providers
# This file is overwritten after every install/update
# Persistent local customizations
include electron-mail.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/electron-mail

whitelist ${DOWNLOADS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/electron-mail
whitelist ${HOME}/.config/electron-mail

include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
# nodbus - breaks tray functionality
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp.drop @clock,@cpu-emulation,@debug,@module,@obsolete,@raw-io,@reboot,@resources,@swap,acct,add_key,bpf,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,ioprio_set,kcmp,keyctl,mount,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,personality,pivot_root,process_vm_readv,ptrace,remap_file_pages,request_key,setdomainname,sethostname,syslog,umount,umount2,userfaultfd,vhangup,vmsplice
shell none
# tracelog - breaks on Arch

private-bin electron-mail
private-cache
private-dev
private-etc alternatives,fonts
private-opt ElectronMail
private-tmp

# memory-deny-write-execute - breaks on Arch
