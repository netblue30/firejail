# Firejail profile for standardnotes-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/standardnotes-desktop.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/Standard Notes Backups
noblacklist ${HOME}/.config/Standard Notes

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/Standard Notes Backups
mkdir ${HOME}/.config/Standard Notes
whitelist ${HOME}/Standard Notes Backups
whitelist ${HOME}/.config/Standard Notes
include /etc/firejail/whitelist-var-common.inc

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
seccomp

disable-mnt
private-dev
private-tmp
private-etc ca-certificates,fonts,host.conf,hostname,hosts,resolv.conf,ssl,pki,crypto-policies,xdg

noexec ${HOME}
noexec /tmp
