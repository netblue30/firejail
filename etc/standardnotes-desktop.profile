# Firejail profile for standardnotes-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/standardnotes-desktop.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc

whitelist ${HOME}/Standard Notes Backups
whitelist ${HOME}/.config/Standard Notes

apparmor
caps.drop all
netfilter
machine-id
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
protocol unix,inet,inet6,netlink
seccom
