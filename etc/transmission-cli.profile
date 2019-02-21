# Firejail profile for transmission-cli
# Description: Lightweight BitTorrent client
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-cli.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/transmission
noblacklist ${HOME}/.config/transmission

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
# machine-id breaks audio; it should work fine in setups where sound is not required
machine-id
netfilter
nodvd
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

# private-bin transmission-cli
private-dev
private-etc alternatives,ca-certificates,ssl,pki,crypto-policies
private-tmp

memory-deny-write-execute
