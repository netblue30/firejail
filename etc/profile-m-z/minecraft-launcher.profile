# Firejail profile for minecraft-launcher
# Description: Official Minecraft launcher from Mojang
# This file is overwritten after every install/update
# Persistent local customizations
include minecraft-launcher.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

noblacklist ${HOME}/.minecraft

include allow-java.inc
include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.minecraft
whitelist ${HOME}/.minecraft
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-bin minecraft-launcher,java,java-config
private-cache
private-dev
# private-etc alternatives,asound.conf,ca-certificates,crypto-policies,fonts,group,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,localtime,machine-id,mime.types,nvidia,passwd,pki,pulse,resolv.conf,services,selinux,ssl,xdg,X11
private-opt minecraft-launcher
private-tmp

dbus-user none
dbus-system none