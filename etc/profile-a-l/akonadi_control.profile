# Firejail profile for akonadi_control
# Persistent local customizations
include akonadi_control.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/akonadi*
nodeny  ${HOME}/.config/akonadi*
nodeny  ${HOME}/.config/baloorc
nodeny  ${HOME}/.config/emaildefaults
nodeny  ${HOME}/.config/emailidentities
nodeny  ${HOME}/.config/kmail2rc
nodeny  ${HOME}/.config/mailtransports
nodeny  ${HOME}/.config/specialmailcollectionsrc
nodeny  ${HOME}/.local/share/akonadi*
nodeny  ${HOME}/.local/share/apps/korganizer
nodeny  ${HOME}/.local/share/contacts
nodeny  ${HOME}/.local/share/local-mail
nodeny  ${HOME}/.local/share/notes
nodeny  /sbin
nodeny  /tmp/akonadi-*
nodeny  /usr/sbin

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
noinput
# nonewprivs
noroot
nosound
notv
nou2f
novideo
# protocol unix,inet,inet6,netlink
# seccomp !io_destroy,!io_getevents,!io_setup,!io_submit,!ioprio_set
tracelog

private-dev
# private-tmp - breaks programs that depend on akonadi

