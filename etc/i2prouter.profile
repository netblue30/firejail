# Firejail profile for I2P
# Description: A distributed anonymous network
# This file is overwritten after every install/update
# Persistent local customizations
include i2prouter.local
# Persistent global definitions
include globals.local

# Notice: default browser will not be able to automatically open, due to sandbox.
# Auto-opening default browser can be disabled in the I2P router console.
# This profile will not currently work with any Arch User Repository i2p packages,
# use the distro-independent official java installer instead

# Only needed if i2prouter binary is in home directory, java installer does this
private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,java.conf,java-10-openjdk,java-9-openjdk,java-8-openjdk,java-7-openjdk,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
ignore noexec ${HOME}

noblacklist ${HOME}/.config/i2p
noblacklist ${HOME}/.i2p
noblacklist ${HOME}/.local/share/i2p
noblacklist ${HOME}/i2p
# Only needed if wrapper is placed in /usr/sbin/, ubuntu official ppa package does this
noblacklist /usr/sbin

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/i2p
mkdir ${HOME}/.i2p
mkdir ${HOME}/.local/share/i2p
mkdir ${HOME}/i2p
whitelist ${HOME}/.config/i2p
whitelist ${HOME}/.i2p
whitelist ${HOME}/.local/share/i2p
whitelist ${HOME}/i2p
# Only needed if wrapper is placed in /usr/sbin/, ubuntu official ppa package does this
whitelist /usr/sbin/wrapper*

include whitelist-common.inc

# May break I2P if wrapper is placed in the home directory
# If using ubuntu official ppa, this should be fine to uncomment, as it puts wrapper in /usr/sbin/
#apparmor
caps.drop all
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
private-cache
private-dev
private-tmp
