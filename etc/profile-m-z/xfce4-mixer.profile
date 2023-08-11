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
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkfile ${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-mixer.xml
whitelist ${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-mixer.xml
whitelist /usr/share/gstreamer-*
whitelist /usr/share/xfce4
whitelist /usr/share/xfce4-mixer
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp

disable-mnt
private-bin xfce4-mixer,xfconf-query
private-cache
private-dev
private-etc
private-tmp

dbus-user filter
dbus-user.own org.xfce.xfce4-mixer
dbus-user.talk org.xfce.Xfconf
dbus-system none

#memory-deny-write-execute # breaks on Arch
restrict-namespaces
