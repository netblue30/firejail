# Firejail profile for knotes
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/knotes.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/akonadi*
noblacklist ${HOME}/.config/knotesrc
noblacklist ${HOME}/.local/share/akonadi*
noblacklist /tmp/akonadi-*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

private-dev
# private-tmp - interrupts connection to akonadi

noexec ${HOME}
noexec /tmp
