# Firejail profile for kmail
# Description: Full featured graphical email client
# This file is overwritten after every install/update
# Persistent local customizations
include kmail.local
# Persistent global definitions
include globals.local

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
noblacklist ${HOME}/.local/share/kxmlgui5/kmail
noblacklist ${HOME}/.local/share/kxmlgui5/kmail2
noblacklist ${HOME}/.local/share/local-mail
noblacklist ${HOME}/.local/share/notes
noblacklist ${RUNUSER}/akonadi
noblacklist /tmp/akonadi-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

include whitelist-run-common.inc
include whitelist-var-common.inc

#apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
# we need to allow chroot, io_getevents, ioprio_set, io_setup, io_submit system calls
seccomp !chroot,!io_getevents,!io_setup,!io_submit,!ioprio_set
#tracelog

private-dev
#private-tmp # interrupts connection to akonadi, breaks opening of email attachments
# writable-run-user is needed for signing and encrypting emails
writable-run-user

#restrict-namespaces
