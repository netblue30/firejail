# Firejail profile for I2P
# Description: A distributed anonymous network
# This file is overwritten after every install/update
# Persistent local customizations
include i2prouter.local
# Persistent global definitions
include globals.local

# Notice: default browser will most likely not be able to automatically open, due to sandbox.
# Auto-opening default browser can be disabled in the I2P router console.
# This profile will not currently work with any Arch User Repository I2P packages,
# use the distro-independent official I2P java installer instead.

# Only needed when i2prouter binary resides in home directory (official I2P java installer does so).
ignore noexec ${HOME}

noblacklist ${HOME}/.config/i2p
noblacklist ${HOME}/.i2p
noblacklist ${HOME}/.local/share/i2p
noblacklist ${HOME}/i2p
# Only needed when wrapper resides in /usr/sbin/ (Ubuntu official I2P PPA package does so).
noblacklist /usr/sbin

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
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
# Only needed when wrapper resides in /usr/sbin/ (Ubuntu official I2P PPA package does so).
whitelist /usr/sbin/wrapper*

include whitelist-common.inc

# May break I2P if wrapper resides in the home directory (official I2P java installer does so).
# When using the Ubuntu official I2P PPA it should be fine to add 'apparmor' to your i2prouter.local,
# as it places the wrapper in /usr/sbin/
#apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

disable-mnt
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dconf,group,hostname,hosts,i2p,java-10-openjdk,java-11-openjdk,java-12-openjdk,java-13-openjdk,java-8-openjdk,java-9-openjdk,java-openjdk,ld.so.cache,ld.so.preload,localtime,machine-id,nsswitch.conf,passwd,pki,resolv.conf,ssl
private-tmp
