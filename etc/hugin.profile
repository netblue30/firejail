# Firejail profile for hugin
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/hugin.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.hugin

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
nosound
notv
novideo
protocol unix
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
