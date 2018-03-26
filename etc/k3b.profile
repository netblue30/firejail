# Firejail profile for k3b
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/k3b.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/k3brc
noblacklist ${HOME}/.kde/share/config/k3brc
noblacklist ${HOME}/.kde4/share/config/k3brc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
no3d
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

# private-tmp
