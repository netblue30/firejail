# Firejail profile for youtube-dl
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/youtube-dl.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.netrc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-dev

noexec ${HOME}
noexec /tmp
