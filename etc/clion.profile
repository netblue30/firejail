# Firejail profile for CLion
# This file is overwritten after every install/update
# Persistent local customizations
include clion.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.CLion*
noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credentials
noblacklist ${HOME}/.java
noblacklist ${HOME}/.local/share/JetBrains
noblacklist ${HOME}/.ssh
noblacklist ${HOME}/.tooling

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
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

private-cache
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,java.conf,java-10-openjdk,java-9-openjdk,java-8-openjdk,java-7-openjdk,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
# private-tmp

noexec /tmp
