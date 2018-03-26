# Firejail profile for qpdfview
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/qpdfview.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/qpdfview
noblacklist ${HOME}/.local/share/qpdfview

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
machine-id
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

private-bin qpdfview
private-dev
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
