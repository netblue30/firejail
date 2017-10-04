# Firejail profile for gnome-2048
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-2048.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.local/share/gnome-2048

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

mkdir ${HOME}/.local/share/gnome-2048
whitelist ${HOME}/.local/share/gnome-2048
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
