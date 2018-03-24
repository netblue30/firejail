# Firejail profile for blender
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/blender.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/blender

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
