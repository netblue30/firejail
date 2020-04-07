# Firejail profile for peek
# This file is overwritten after every install/update
# Persistent local customizations
include peek.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/peek
noblacklist ${PICTURES}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
net none
no3d
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

# private-bin breaks gif mode, mp4 and webm mode work fine however
# private-bin convert,ffmpeg,peek
private-dev
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
