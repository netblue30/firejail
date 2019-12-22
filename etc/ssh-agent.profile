# Firejail profile for ssh-agent
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ssh-agent.local
# Persistent global definitions
include globals.local

noblacklist /etc/ssh
noblacklist /tmp/ssh-*
noblacklist ${HOME}/.ssh

blacklist /tmp/.X11-unix

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-usr-share-common.inc

caps.drop all
netfilter
no3d
nodbus
nodvd
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

writable-run-user

#private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,group,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
