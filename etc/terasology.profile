# Firejail profile for terasology
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/default.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus

noblacklist ${HOME}/.java
noblacklist ${HOME}/.local/share/terasology

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.java
mkdir ${HOME}/.local/share/terasology
whitelist ${HOME}/.java
whitelist ${HOME}/.local/share/terasology
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
net none
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
private-etc asound.conf,ca-certificates,dbus-1,drirc,fonts,group,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,localtime,lsb-release,machine-id,mime.types,passwd,pulse,resolv.conf,ssl,java-8-openjdk,java-7-openjdk
private-tmp

noexec ${HOME}
