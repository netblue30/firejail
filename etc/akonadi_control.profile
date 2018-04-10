# Firejail profile for akonadi_control
# Persistent local customizations
include /etc/firejail/akonadi_control.local
# Persistent global definitions
include /etc/firejail/globals.local

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
noblacklist /tmp/akonadi-*
noblacklist /usr/sbin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

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
novideo
# protocol unix,inet,inet6
# seccomp.drop @cpu-emulation,@debug,@obsolete,@privileged,@resources,add_key,fanotify_init,io_cancel,io_destroy,kcmp,keyctl,name_to_handle_at,ni_syscall,open_by_handle_at,personality,process_vm_readv,ptrace,remap_file_pages,request_key,syslog,umount,userfaultfd,vmsplice
tracelog

private-dev
# private-tmp - breaks programs that depend on akonadi

noexec ${HOME}
noexec /tmp
