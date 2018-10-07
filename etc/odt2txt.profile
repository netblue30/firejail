# Firejail profile for odt2txt
# Description: Simple converter from OpenDocument Text to plain text
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/odt2txt.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${DOCUMENTS}

blacklist /tmp/.X11-unix

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

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

private-bin odt2txt
private-cache
private-dev
private-etc none
private-tmp
read-only ${HOME}
