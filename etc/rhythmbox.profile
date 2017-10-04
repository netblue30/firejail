# Firejail profile for rhythmbox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/rhythmbox.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
# no3d
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin rhythmbox
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
