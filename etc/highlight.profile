# Firejail profile for highlight
# Description: Universal source code to formatted text converter
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/highlight.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

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

private-bin highlight
private-cache
private-dev
# private-etc none
private-tmp
