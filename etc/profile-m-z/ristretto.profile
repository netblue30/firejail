# Firejail profile for ristretto
# Description: Lightweight picture-viewer for the Xfce desktop environment
# This file is overwritten after every install/update
# Persistent local customizations
include ristretto.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/ristretto
noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.steam

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

apparmor
caps.drop all
net none
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
protocol unix
seccomp
shell none

private-cache
private-dev
private-tmp

