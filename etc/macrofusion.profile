# Firejail profile for macrofusion
# This file is overwritten after every install/update
# Persistent local customizations
include macrofusion.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mfusion
noblacklist ${PICTURES}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
ipc-namespace
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

private-bin python*,macrofusion,env,enfuse,exiftool,align_image_stack
private-cache
private-dev
private-tmp

