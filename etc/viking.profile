# Firejail profile for viking
# Description: GPS data editor, analyzer and viewer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/viking.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.viking
noblacklist ${HOME}/.viking-maps
noblacklist ${DOCUMENTS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
