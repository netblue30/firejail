# Firejail profile for deluge
# Description: BitTorrent client written in Python/PyGTK
# This file is overwritten after every install/update
# Persistent local customizations
include deluge.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/deluge

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
# include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/deluge
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/deluge
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
netfilter
nodvd
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

# deluge is using python on Debian
private-bin deluge,deluge-console,deluge-gtk,deluge-web,deluged,python*,sh,uname
private-dev
#private-etc X11,alternatives,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp
