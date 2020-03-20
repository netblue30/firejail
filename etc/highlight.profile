# Firejail profile for highlight
# Description: Universal source code to formatted text converter
# This file is overwritten after every install/update
# Persistent local customizations
include highlight.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-runuser-common.inc

caps.drop all
net none
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
protocol unix
seccomp
shell none
tracelog
x11 none

private-bin highlight
private-cache
private-dev
private-tmp
