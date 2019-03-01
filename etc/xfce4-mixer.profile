# Firejail profile for xfce4-mixer
# Description: Volume control for Xfce
# This file is overwritten after every install/update
# Persistent local customizations
include xfce4-mixer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-mixer.xml

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
# nodbus
nodvd
nogroups
nonewprivs
noroot
# nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

disable-mnt
private-bin xfce4-mixer,xfconf-query
private-cache
private-dev
private-etc alternatives,asound.conf,fonts,pulse
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
