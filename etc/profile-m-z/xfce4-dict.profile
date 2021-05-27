# Firejail profile for xfce4-dict
# Description: Dictionary plugin for Xfce4 panel
# This file is overwritten after every install/update
# Persistent local customizations
include xfce4-dict.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/xfce4-dict

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
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

disable-mnt
private-cache
private-dev
private-tmp

