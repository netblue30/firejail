# Firejail profile for profanity
# Description: profanity is an XMPP chat client for the terminal
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include profanity.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/profanity
noblacklist ${HOME}/.local/share/profanity

# Allow Python
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-bin profanity
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

memory-deny-write-execute
