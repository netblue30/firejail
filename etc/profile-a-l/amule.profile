# Firejail profile for amule
# Description: Client for the eD2k and Kad networks, like eMule
# This file is overwritten after every install/update
# Persistent local customizations
include amule.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.aMule

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.aMule
whitelist ${DOWNLOADS}
whitelist ${HOME}/.aMule
include whitelist-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
# Add netlink protocol to use UPnP
protocol unix,inet,inet6
seccomp

private-bin amule
private-dev
private-tmp

