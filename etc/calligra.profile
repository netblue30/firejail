# Firejail profile for calligra
# Description: Extensive productivity and creative suite
# This file is overwritten after every install/update
# Persistent local customizations
include calligra.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
ipc-namespace
# net none
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none

private-bin calligra,calligraauthor,calligraconverter,calligraflow,calligraplan,calligraplanwork,calligrasheets,calligrastage,calligrawords,dbus-launch,kbuildsycoca4,kdeinit4
private-dev

# dbus-user none
# dbus-system none

# noexec ${HOME}
noexec /tmp
