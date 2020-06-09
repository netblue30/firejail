# Firejail profile for goobox
# Description: CD player and ripper with GNOME 3 integration
# This file is overwritten after every install/update
# Persistent local customizations
include goobox.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

# private-bin goobox
private-dev
# private-etc alternatives,asound.conf,ca-certificates,crypto-policies,fonts,machine-id,pki,pulse,ssl
# private-tmp
