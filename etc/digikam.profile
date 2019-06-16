# Firejail profile for digikam
# Description: Digital photo management application for KDE
# This file is overwritten after every install/update
# Persistent local customizations
include digikam.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/digikam
noblacklist ${HOME}/.config/digikamrc
noblacklist ${HOME}/.kde/share/apps/digikam
noblacklist ${HOME}/.kde4/share/apps/digikam
noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
# nodbus
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

# private-dev - prevents libdc1394 loading; this lib is used to connect to a camera device
# private-etc alternatives,ca-certificates,crypto-policies,pki,ssl
private-tmp
