# Firejail profile for gnome-documents
# Description: Document manager for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-documents.local
# Persistent global definitions
include globals.local

# when gjs apps are started via gnome-shell, firejail is not applied because systemd will start them

noblacklist ${HOME}/.config/libreoffice
noblacklist ${DOCUMENTS}

# Allow gjs (blacklisted by disable-interpreters.inc)
include allow-gjs.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
no3d
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

private-cache
private-dev
private-tmp

restrict-namespaces
