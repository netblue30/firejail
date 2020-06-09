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
# use the distro-independent official I2P java installer instead

# Only needed if i2prouter binary is in home directory, official I2P java installer does this
ignore noexec ${HOME}

noblacklist ${HOME}/.config/i2p
noblacklist ${HOME}/.i2p
noblacklist ${HOME}/.local/share/i2p
noblacklist ${HOME}/i2p
# Only needed if wrapper is placed in /usr/sbin/, ubuntu official I2P ppa package does this
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
# Only needed if wrapper is placed in /usr/sbin/, ubuntu official I2P ppa package does this
whitelist /usr/sbin/wrapper*

include whitelist-common.inc

# May break I2P if wrapper is placed in the home directory; official I2P java installer does this
# If using ubuntu official I2P ppa, this should be fine to uncomment, as it puts wrapper in /usr/sbin/
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
private-etc alternatives,ca-certificates,crypto-policies,dconf,group,hostname,hosts,i2p,java-10-openjdk,java-11-openjdk,java-12-openjdk,java-13-openjdk,java-8-openjdk,java-9-openjdk,java-openjdk,ld.so.cache,localtime,machine-id,nsswitch.conf,passwd,pki,resolv.conf,ssl
private-tmp
