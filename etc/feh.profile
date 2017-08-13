# Firejail profile for feh
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/feh.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
nogroups
nonewprivs
noroot
nosound
notv
protocol unix
seccomp
shell none

private-bin feh
private-dev
private-etc feh
private-tmp
nodvd
