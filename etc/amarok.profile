# Firejail profile for amarok
# Description: Easy to use media player based on the KDE Platform
# This file is overwritten after every install/update
# Persistent local customizations
include amarok.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
# seccomp
shell none

# private-bin amarok
private-dev
# private-etc alternatives,asound.conf,ca-certificates,crypto-policies,machine-id,pki,pulse,ssl
private-tmp
