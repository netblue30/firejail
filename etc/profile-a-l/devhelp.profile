# Firejail profile for devhelp
# Description: API documentation browser for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include devhelp.local
# Persistent global definitions
include globals.local


include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/devhelp
whitelist /usr/share/doc
whitelist /usr/share/gtk-doc/html
include whitelist-common.inc
include whitelist-usr-share-common.inc

apparmor
caps.drop all
#net none # makes settings immutable
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

disable-mnt
private-bin devhelp
private-cache
private-dev
private-etc @tls-ca,@x11
private-tmp

# makes settings immutable
#dbus-user none
#dbus-system none

#memory-deny-write-execute # breaks on Arch (see issue #1803)
read-only ${HOME}
restrict-namespaces
