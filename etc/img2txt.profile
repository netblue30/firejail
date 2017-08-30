# Firejail profile for img2txt
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/img2txt.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
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

# private-bin img2txt
private-dev
# private-etc none
private-tmp
