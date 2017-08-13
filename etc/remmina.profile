# Firejail profile for remmina
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/remmina.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/remmina
noblacklist ${HOME}/.local/share/remmina
noblacklist ${HOME}/.ssh

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
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
