# Firejail profile for kmail
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/kmail.local
# Persistent global definitions
include /etc/firejail/globals.local

# kmail has problems launching akonadi in debian and ubuntu.
# one solution is to have akonadi already running when kmail is started

noblacklist ${HOME}/.cache/akonadi*
noblacklist ${HOME}/.cache/kmail2
noblacklist ${HOME}/.config/akonadi*
noblacklist ${HOME}/.config/baloorc
noblacklist ${HOME}/.config/emaildefaults
noblacklist ${HOME}/.config/emailidentities
noblacklist ${HOME}/.config/kmail2rc
noblacklist ${HOME}/.config/kmailsearchindexingrc
noblacklist ${HOME}/.config/mailtransports
noblacklist ${HOME}/.config/specialmailcollectionsrc
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.local/share/akonadi*
noblacklist ${HOME}/.local/share/apps/korganizer
noblacklist ${HOME}/.local/share/contacts
noblacklist ${HOME}/.local/share/emailidentities
noblacklist ${HOME}/.local/share/kmail2
noblacklist ${HOME}/.local/share/local-mail
noblacklist ${HOME}/.local/share/notes
noblacklist /tmp/akonadi-*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

# apparmor
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6,netlink
# we need to allow chroot, io_getevents, ioprio_set, io_setup, io_submit system calls
seccomp.drop @clock,@cpu-emulation,@debug,@module,@obsolete,@raw-io,@reboot,@resources,@swap,acct,add_key,bpf,fanotify_init,io_cancel,io_destroy,kcmp,keyctl,mount,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,personality,pivot_root,process_vm_readv,ptrace,remap_file_pages,request_key,setdomainname,sethostname,syslog,umount,umount2,userfaultfd,vhangup,vmsplice
# tracelog
# writable-run-user is needed for signing and encrypting emails
writable-run-user

private-dev
# private-tmp - interrupts connection to akonadi, breaks opening of email attachments

noexec ${HOME}
noexec /tmp
