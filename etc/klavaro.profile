# Firejail profile for klavaro
# Description: Yet another touch typing tutor
# This file is overwritten after every install/update
# Persistent local customizations
include klavaro.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/klavaro
noblacklist ${HOME}/.local/share/klavaro

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/klavaro
mkdir ${HOME}/.config/klavaro
whitelist ${HOME}/.local/share/klavaro
whitelist ${HOME}/.config/klavaro
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-bin klavaro,tclsh,tclsh*,bash
private-cache
private-dev
private-etc alternatives,fonts
private-tmp
private-opt none
private-srv none

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
