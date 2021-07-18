# Firejail profile for darktable
# Description: Virtual lighttable and darkroom for photographers
# This file is overwritten after every install/update
# Persistent local customizations
include darktable.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/darktable
noblacklist ${HOME}/.config/darktable
noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

#private-bin darktable
private-dev
private-tmp

