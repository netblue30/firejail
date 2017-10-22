# Firejail profile for macrofusion
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/macrofusion.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus

noblacklist ${HOME}/.config/mfusion

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
net none
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

private-bin python*,macrofusion,env,enfuse,exiftool,align_image_stack
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
