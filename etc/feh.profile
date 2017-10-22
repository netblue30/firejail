# Firejail profile for feh
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/feh.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
no3d
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
private-dev
private-etc feh
private-tmp
