# Firejail profile for kmail
# Description: Full featured graphical email client
# This file is overwritten after every install/update
# Persistent local customizations
include kmail.local
# Persistent global definitions
include globals.local

# kmail has problems launching akonadi in debian and ubuntu.
# one solution is to have akonadi already running when kmail is started

nodeny  ${HOME}/.cache/akonadi*
nodeny  ${HOME}/.cache/kmail2
nodeny  ${HOME}/.config/akonadi*
nodeny  ${HOME}/.config/baloorc
nodeny  ${HOME}/.config/emaildefaults
nodeny  ${HOME}/.config/emailidentities
nodeny  ${HOME}/.config/kmail2rc
nodeny  ${HOME}/.config/kmailsearchindexingrc
nodeny  ${HOME}/.config/mailtransports
nodeny  ${HOME}/.config/specialmailcollectionsrc
nodeny  ${HOME}/.gnupg
nodeny  ${HOME}/.local/share/akonadi*
nodeny  ${HOME}/.local/share/apps/korganizer
nodeny  ${HOME}/.local/share/contacts
nodeny  ${HOME}/.local/share/emailidentities
nodeny  ${HOME}/.local/share/kmail2
nodeny  ${HOME}/.local/share/kxmlgui5/kmail
nodeny  ${HOME}/.local/share/kxmlgui5/kmail2
nodeny  ${HOME}/.local/share/local-mail
nodeny  ${HOME}/.local/share/notes
nodeny  /tmp/akonadi-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

# apparmor
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
# tracelog

private-dev
# private-tmp - interrupts connection to akonadi, breaks opening of email attachments
# writable-run-user is needed for signing and encrypting emails
writable-run-user
