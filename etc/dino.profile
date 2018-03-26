# Firejail profile for dino
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dino.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.local/share/dino

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.local/share/dino
whitelist ${HOME}/.local/share/dino
whitelist ${HOME}/Downloads
include /etc/firejail/whitelist-common.inc

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

disable-mnt
private-bin dino
private-dev
# private-etc fonts # breaks server connection
private-tmp

noexec ${HOME}
noexec /tmp
