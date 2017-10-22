# Firejail profile for peek
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/peek.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus

noblacklist ${HOME}/.cache/peek

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none

# private-bin breaks gif mode, mp4 and webm mode work fine however
# private-bin peek,convert,ffmpeg
private-dev
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
