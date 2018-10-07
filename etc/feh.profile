# Firejail profile for feh
# Description: imlib2 based image viewer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/feh.local
# Persistent global definitions
include /etc/firejail/globals.local

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

private-bin feh,jpegexiforient,jpegtran
private-cache
private-dev
private-etc feh
private-tmp
