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
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
tracelog

private-dev
private-tmp

# noexec ${HOME} - tuxguitar may fail to launch
noexec /tmp
