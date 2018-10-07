# Firejail profile for leafpad
# Description: GTK+ based simple text editor
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/leafpad.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/leafpad

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

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

private-bin leafpad
private-dev
private-lib
private-tmp

noexec ${HOME}
noexec /tmp
