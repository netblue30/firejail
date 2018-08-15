# Firejail profile for goobox
# Description: CD player and ripper with GNOME 3 integration
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/goobox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${MUSIC}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

# private-bin goobox
private-dev
# private-etc fonts,machine-id,pulse,asound.conf,ca-certificates,ssl,pki,crypto-policies
# private-tmp
