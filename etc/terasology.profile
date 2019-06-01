# Firejail profile for terasology
# This file is overwritten after every install/update
# Persistent local customizations
include terasology.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.java
noblacklist ${HOME}/.local/share/terasology

# Allow java (blacklisted by disable-interpreters.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.java
mkdir ${HOME}/.local/share/terasology
whitelist ${HOME}/.java
whitelist ${HOME}/.local/share/terasology
include whitelist-common.inc

caps.drop all
ipc-namespace
net none
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
private-etc alternatives,asound.conf,ca-certificates,dbus-1,drirc,fonts,group,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,localtime,lsb-release,machine-id,mime.types,passwd,pulse,resolv.conf,ssl,java-8-openjdk,java-7-openjdk,pki,crypto-policies
private-tmp

noexec ${HOME}
