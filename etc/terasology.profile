# Firejail profile for terasology
# This file is overwritten after every install/update
# Persistent local customizations
include terasology.local
# Persistent global definitions
include globals.local

private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,java.conf,java-10-openjdk,java-9-openjdk,java-8-openjdk,java-7-openjdk,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,lsb-release,machine-id,mime.types,pango,passwd,pulse,xdg
ignore noexec /tmp

noblacklist ${HOME}/.local/share/terasology

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
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
private-tmp
