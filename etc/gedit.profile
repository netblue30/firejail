# Firejail profile for gedit
# Description: Official text editor of the GNOME desktop environment
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gedit.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/enchant
noblacklist ${HOME}/.config/gedit
noblacklist ${HOME}/.gitconfig

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
# include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

# apparmor - makes settings immutable
caps.drop all
machine-id
# net none - makes settings immutable
no3d
# nodbus - makes settings immutable
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

# private-bin gedit
private-dev
# private-etc fonts
private-lib /usr/bin/gedit,libtinfo.so.*,libreadline.so.*,gedit,libgspell-1.so.*,gconv,aspell
private-tmp

noexec ${HOME}
noexec /tmp
