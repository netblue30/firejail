# Firejail profile for tor
# Description: Anonymizing overlay network for TCP
# This file is overwritten after every install/update
# Persistent local customizations
include tor.local
# Persistent global definitions
include globals.local

# How to use:
# Create a script called anything (e.g. mytor)
# with the following contents:

# #!/bin/bash
# TORCMD="tor --defaults-torrc /usr/share/tor/tor-service-defaults-torrc -f /etc/tor/torrc --RunAsDaemon 1"
# sudo -b daemon -f -d -- firejail --profile=/home/<username>/.config/firejail/tor.profile $TORCMD

# You'll also likely want to disable the system service (if it exists)
# Run mytor (or whatever you called the script above) whenever you want to start tor

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.keep dac_read_search,net_bind_service,setgid,setuid
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
nonewprivs
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private
private-bin bash,tor
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dbus-1,default,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,tor,xdg
private-tmp
writable-var
