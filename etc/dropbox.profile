# Firejail profile for dropbox
# This file is overwritten after every install/update
# Persistent local customizations
include dropbox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/autostart
noblacklist ${HOME}/.dropbox
noblacklist ${HOME}/.dropbox-dist

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.dropbox
mkdir ${HOME}/.dropbox-dist
mkdir ${HOME}/Dropbox
mkfile ${HOME}/.config/autostart/dropbox.desktop
whitelist ${HOME}/.config/autostart/dropbox.desktop
whitelist ${HOME}/.dropbox
whitelist ${HOME}/.dropbox-dist
whitelist ${HOME}/Dropbox
include whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
#private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

noexec /tmp
