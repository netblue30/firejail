# Firejail profile for Thunar
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/Thunar.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.local/share/Trash
noblacklist ${HOME}/.config/Thunar
noblacklist ${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
# include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
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
tracelog
