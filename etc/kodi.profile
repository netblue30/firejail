# Firejail profile for kodi
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/kodi.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.kodi

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
