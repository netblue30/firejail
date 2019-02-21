# Firejail profile for qpdfview
# Description: Tabbed document viewer
# This file is overwritten after every install/update
# Persistent local customizations
include qpdfview.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/qpdfview
noblacklist ${HOME}/.local/share/qpdfview
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
machine-id
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
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
