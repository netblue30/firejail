# Firejail profile for transmission-gtk
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/transmission-gtk.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/transmission
noblacklist ${HOME}/.config/transmission

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/transmission
mkdir ~/.config/transmission
whitelist  ${DOWNLOADS}
whitelist ~/.cache/transmission
whitelist ~/.config/transmission
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin transmission-gtk
private-dev
private-tmp

memory-deny-write-execute
