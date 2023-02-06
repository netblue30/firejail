# Firejail profile for terasology
# This file is overwritten after every install/update
# Persistent local customizations
include terasology.local
# Persistent global definitions
include globals.local

ignore noexec /tmp

noblacklist ${HOME}/.local/share/terasology

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.java
mkdir ${HOME}/.local/share/terasology
whitelist ${HOME}/.java
whitelist ${HOME}/.local/share/terasology
include whitelist-common.inc

caps.drop all
ipc-namespace
net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

disable-mnt
private-dev
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,dbus-1,drirc,fonts,group,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,java-7-openjdk,java-8-openjdk,ld.so.cache,ld.so.preload,localtime,lsb-release,machine-id,mime.types,passwd,pki,pulse,resolv.conf,ssl
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
