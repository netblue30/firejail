# Firejail profile for gpicview
# Description: Lightweight image viewer
# This file is overwritten after every install/update
# Persistent local customizations
include gpicview.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gpicview

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

private-bin gpicview
private-dev
private-etc alternatives,fonts
private-lib
private-tmp
