# Firejail profile for obs
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/obs.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/obs-studio

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
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

private-bin obs
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
