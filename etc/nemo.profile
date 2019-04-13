# Firejail profile for nemo
# Description: File manager and graphical shell for Cinnamon
# This file is overwritten after every install/update
# Persistent local customizations
include nemo.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/nemo
noblacklist ${HOME}/.local/share/Trash
noblacklist ${HOME}/.local/share/nemo
noblacklist ${HOME}/.local/share/nemo-python

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc

caps.drop all
netfilter
no3d
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

