# Firejail profile for sdat2img
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/sdat2img.local
# Persistent global definitions
include /etc/firejail/globals.local

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
no3d
nodbus
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

private-bin sdat2img,env,python*
private-dev

noexec ${HOME}
noexec /tmp
