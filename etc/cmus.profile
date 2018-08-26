# Firejail profile for cmus
# Description: Lightweight ncurses audio player
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/cmus.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/cmus
noblacklist ${MUSIC}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
netfilter
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-bin cmus
private-etc group,machine-id,pulse,asound.conf,ca-certificates,ssl,pki,crypto-policies
