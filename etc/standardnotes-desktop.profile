# Firejail profile for standardnotes-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/standardnotes-desktop.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${HOME}/Standard Notes Backups
whitelist ${HOME}/.config/Standard Notes

apparmor
caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
