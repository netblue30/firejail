# Firejail profile for akonadi_control
# Persistent local customizations
include akonadi_control.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/akonadi*
noblacklist ${HOME}/.config/akonadi*
noblacklist ${HOME}/.config/baloorc
noblacklist ${HOME}/.config/emaildefaults
noblacklist ${HOME}/.config/emailidentities
noblacklist ${HOME}/.config/kmail2rc
noblacklist ${HOME}/.config/mailtransports
noblacklist ${HOME}/.config/specialmailcollectionsrc
noblacklist ${HOME}/.local/share/akonadi*
noblacklist ${HOME}/.local/share/apps/korganizer
noblacklist ${HOME}/.local/share/contacts
noblacklist ${HOME}/.local/share/local-mail
noblacklist ${HOME}/.local/share/notes
noblacklist /sbin
noblacklist /tmp/akonadi-*
noblacklist /usr/sbin

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

# disabled options below are not compatible with the apparmor profile for mysqld-akonadi.
# this affects ubuntu and debian currently

# apparmor
caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
# nonewprivs
noroot
nosound
notv
nou2f
novideo
# protocol unix,inet,inet6,netlink
# seccomp.drop @cpu-emulation,@debug,@obsolete,@privileged,@resources,add_key,fanotify_init,io_cancel,io_destroy,kcmp,keyctl,name_to_handle_at,ni_syscall,open_by_handle_at,personality,process_vm_readv,ptrace,remap_file_pages,request_key,syslog,umount,userfaultfd,vmsplice
tracelog

private-dev
# private-tmp - breaks programs that depend on akonadi

