# Firejail profile for Thunar
# Description: File Manager for Xfce
# This file is overwritten after every install/update
# Persistent local customizations
include Thunar.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/Trash
noblacklist ${HOME}/.config/Thunar
noblacklist ${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# include disable-programs.inc

allusers
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
