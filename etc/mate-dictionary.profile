# Firejail profile for mate-dictionary
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mate-dictionary.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/mate/mate-dictionary

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${HOME}/.config/mate/mate-dictionary
whitelist ${HOME}/.config/gtk-3.0
whitelist ${HOME}/.fonts
whitelist ${HOME}/.icons
whitelist ${HOME}/.themes

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
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin mate-dictionary
private-etc fonts,resolv.conf,ca-certificates,ssl,pki,crypto-policies
private-opt mate-dictionary
private-dev
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
