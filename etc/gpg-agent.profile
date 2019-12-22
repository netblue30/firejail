# Firejail profile for gpg-agent
# Description: GNU privacy guard - cryptographic agent
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gpg-agent.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.gnupg

blacklist /tmp/.X11-unix

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
include whitelist-usr-share-common.inc

caps.drop all
netfilter
no3d
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
tracelog

# private-bin gpg-agent,gpg
private-cache
private-dev
#private-etc X11,alternatives,ca-certificates,crypto-policies,dbus-1,gnupg,gnupg2,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,logcheck,machine-id,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
