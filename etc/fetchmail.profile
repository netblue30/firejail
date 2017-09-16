# Firejail profile for fetchmail
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/fetchmail.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
nogroups
noroot
nosound
seccomp

# private-bin fetchmail,procmail,bash,chmod
private-dev
# private-etc passwd,hosts,resolv.conf
