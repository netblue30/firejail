# Firejail profile for calligra
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/calligra.local
# Persistent global definitions
include /etc/firejail/globals.local

# blacklist /run/user/*/bus

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
# net none
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix
seccomp
shell none

private-bin calligra,calligraauthor,calligraconverter,calligraflow,calligraplan,calligraplanwork,calligrasheets,calligrastage,calligrawords,dbus-launch,kbuildsycoca4,kdeinit4
private-dev

# noexec ${HOME}
noexec /tmp
