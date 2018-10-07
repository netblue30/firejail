# Firejail profile for bluefish
# Description: Advanced Gtk+ text editor for web and software development
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/bluefish.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
net none
no3d
nodbus
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

private-bin bluefish
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
