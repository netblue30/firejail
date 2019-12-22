# Firejail profile for uzbl-browser
# This file is overwritten after every install/update
# Persistent local customizations
include uzbl-browser.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/uzbl
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.local/share/uzbl

# Allow python (blacklisted by disable-interpreters.inc)
include	allow-python2.inc
include	allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.config/uzbl
mkdir ${HOME}/.gnupg
mkdir ${HOME}/.local/share/uzbl
mkdir ${HOME}/.password-store
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/uzbl
whitelist ${HOME}/.gnupg
whitelist ${HOME}/.local/share/uzbl
whitelist ${HOME}/.password-store
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
tracelog

#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
