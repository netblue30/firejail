# Firejail profile for darktable
# Description: Virtual lighttable and darkroom for photographers
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/darktable.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/darktable
noblacklist ${HOME}/.config/darktable
noblacklist ${PICTURES}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

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

#private-bin darktable
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
