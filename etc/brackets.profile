# Firejail profile for brackets
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/brackets.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Brackets
#noblacklist /opt/brackets/
#noblacklist /opt/google/

include /etc/firejail/disable-common.inc
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
protocol unix,inet,inet6
seccomp
shell none

private-dev
