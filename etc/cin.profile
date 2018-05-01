# Firejail profile for cin
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/cin.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.bcast5

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
net none
nodbus
nodvd
#nogroups
nonewprivs
notv
noroot
protocol unix

# if an 1-1.2% gap per thread hurts you, comment seccomp
seccomp
shell none

#private-bin cin,ffmpeg
private-dev

noexec ${HOME}
noexec /tmp
