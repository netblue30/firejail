# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/Thunar.local

# Firejail profile for thunar
noblacklist ~/.config/Thunar
noblacklist ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
noblacklist ${HOME}/.local/share/Trash

include /etc/firejail/disable-common.inc
#include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

#
# depending on your usage, you can enable some of the commands below: 
#
# private-bin program
# private-etc none
# private-dev
# private-tmp
