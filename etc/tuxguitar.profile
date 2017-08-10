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
# net none - breaks internet for tuxguitar versions 1.3 and higher
no3d
nonewprivs
noroot
novideo
protocol unix,inet,inet6
seccomp
tracelog

private-dev
private-tmp

# noexec ${HOME} - tuxguitar versions 1.3 and higher might fail to launch
noexec /tmp
