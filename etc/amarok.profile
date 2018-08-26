# Firejail profile for amarok
# Description: Easy to use media player based on the KDE Platform
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/amarok.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${MUSIC}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
# seccomp
shell none

# private-bin amarok
private-dev
# private-etc machine-id,pulse,asound.conf,ca-certificates,ssl,pki,crypto-policies
private-tmp
