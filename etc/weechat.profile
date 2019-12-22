# Firejail profile for weechat
# Description: Fast, light and extensible chat client
# This file is overwritten after every install/update
# Persistent local customizations
include weechat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.weechat

include disable-common.inc
include disable-programs.inc

include whitelist-usr-share-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

# no private-bin support for various reasons:
# Plugins loaded: alias, aspell, charset, exec, fifo, guile, irc,
# logger, lua, perl, python, relay, ruby, script, tcl, trigger, xferloading plugins

#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
