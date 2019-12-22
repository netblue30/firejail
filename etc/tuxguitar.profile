# Firejail profile for tuxguitar
# Description: Multitrack guitar tablature editor and player (gp3 to gp5)
# This file is overwritten after every install/update
# Persistent local customizations
include tuxguitar.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.tuxguitar*
noblacklist ${DOCUMENTS}
noblacklist ${MUSIC}

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

# noexec ${HOME} - tuxguitar may fail to launch
noexec /tmp
