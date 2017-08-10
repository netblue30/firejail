# Firejail profile for tuxguitar
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/tuxguitar.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.java
noblacklist ~/.tuxguitar*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
no3d
nonewprivs
noroot
novideo
protocol unix
seccomp
tracelog

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
