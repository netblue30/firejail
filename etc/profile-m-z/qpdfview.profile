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
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
tracelog

private-bin qpdfview
private-dev
private-tmp

# needs D-Bus when started from a file manager
#dbus-user none
#dbus-system none

restrict-namespaces
