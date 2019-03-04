# Firejail profile for netactview
# Description: A graphical network connections viewer similar in functionality to netstat
# This file is overwritten after every install/update
# Persistent local customizations
include netactview.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.netactview

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkfile ${HOME}/.netactview
whitelist ${HOME}/.netactview
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
seccomp
shell none

disable-mnt
private-bin netactview,netactview_polkit
private-cache
private-dev
private-etc alternatives,fonts
private-lib
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
