# Firejail profile for gnome-contacts
# Description: Contacts manager for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gnome-contacts.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${DOCUMENTS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6,netlink
seccomp

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
