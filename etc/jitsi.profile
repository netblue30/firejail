# Firejail profile for jitsi
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/jitsi.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.jitsi

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-tmp
