# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/gedit.local

# gedit profile

# when gedit is started via gnome-shell, firejail is not applied because systemd will start it

noblacklist ~/.config/gedit

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
#include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
#ipc-namespace
netfilter
net none
no3d
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

# private-bin gedit
private-dev
# private-etc fonts
private-tmp

noexec ${HOME}
noexec ${HOME}/.local/share
noexec /tmp
