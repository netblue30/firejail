# Firejail profile for akonadi_control
# Persistent local customizations
include /etc/firejail/akonadi_control.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/akonadi*
noblacklist ${HOME}/.config/akonadi*
noblacklist ${HOME}/.config/baloorc
noblacklist ${HOME}/.local/share/akonadi/*
noblacklist ${HOME}/.local/share/contacts
noblacklist ${HOME}/.local/share/local-mail
noblacklist /usr/sbin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

# depending on your setup it might be possible to
# enable some of the commented options below

# apparmor
caps.drop all
ipc-namespace
no3d
netfilter
nodvd
nogroups
# nonewprivs
# noroot
nosound
notv
novideo
# protocol unix,inet,inet6
# seccomp.drop @cpu-emulation,@debug,@obsolete,@privileged,@resources,add_key,fanotify_init,io_cancel,io_destroy,kcmp,keyctl,name_to_handle_at,ni_syscall,open_by_handle_at,personality,process_vm_readv,ptrace,remap_file_pages,request_key,syslog,umount,userfaultfd,vmsplice
tracelog

private-dev
# private-tmp - breaks programs that depend on akonadi

noexec ${HOME}
noexec /tmp
