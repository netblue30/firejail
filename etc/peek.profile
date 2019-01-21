# Firejail profile for peek
# This file is overwritten after every install/update
# Persistent local customizations
include peek.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/peek
noblacklist ${PICTURES}
noblacklist ${VIDEOS}

mkdir ${HOME}/.cache/peek

whitelist ${HOME}/.cache/peek
whitelist ${PICTURES}
whitelist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-common.inc

caps.drop all
net none
no3d
#nodbus breaks format picker on arch
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
# private-bin peek,convert,ffmpeg,gifski
private-dev
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
