# Firejail profile for itch
# This file is overwritten after every install/update
# Persistent local customizations
include itch.local
# Persistent global definitions
include globals.local

# itch.io has native firejail/sandboxing support bundled in
# See https://itch.io/docs/itch/using/sandbox/linux.html

noblacklist ${HOME}/.itch
noblacklist ${HOME}/.config/itch

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.itch
mkdir ${HOME}/.config/itch
whitelist ${HOME}/.itch
whitelist ${HOME}/.config/itch
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

noexec /tmp
