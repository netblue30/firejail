# Firejail profile for aria2c
# Description: Download utility that supports HTTP(S), FTP, BitTorrent and Metalink
# This file is overwritten after every install/update
# Persistent local customizations
include aria2c.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.aria2
noblacklist ${HOME}/.config/aria2
noblacklist ${HOME}/.netrc

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
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
protocol unix,inet,inet6,netlink
seccomp
shell none

# disable-mnt
# Add your custom event hook commands to 'private-bin' in your aria2c.local.
private-bin aria2c,gzip
# Add 'private-cache' to your aria2c.local if you don't use Lutris/winetricks (see issue #2772).
#private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,groups,login.defs,machine-id,nsswitch.conf,passwd,pki,resolv.conf,ssl
private-lib libreadline.so.*
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
