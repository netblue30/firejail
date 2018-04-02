# Firejail profile for xfce4-notes
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/xfce4-notes.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/xfce4/xfce4-notes.gtkrc
noblacklist ${HOME}/.config/xfce4/xfce4-notes.rc
noblacklist ${HOME}/.local/share/notes

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

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

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
