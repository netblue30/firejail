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

mkdir ${HOME}/.cache/transmission
mkdir ${HOME}/.config/transmission
whitelist  ${DOWNLOADS}
whitelist ${HOME}/.cache/transmission
whitelist ${HOME}/.config/transmission
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodbus
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
private-lib
private-tmp

memory-deny-write-execute
