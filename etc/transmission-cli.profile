# Firejail profile for transmission-cli
# Description: Fast, easy and free BitTorrent client (CLI tools and web client)
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
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

apparmor
caps.drop all
machine-id
netfilter
nodbus
nodvd
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp
shell none
tracelog

# private-bin transmission-cli
private-dev
private-etc alternatives,ca-certificates,crypto-policies,nsswitch.conf,pki,resolv.conf,ssl
private-lib
private-tmp

memory-deny-write-execute
