# Firejail profile for corebird
# Description: Native Gtk+ Twitter client for the Linux desktop
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/corebird.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/corebird

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-bin corebird
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
