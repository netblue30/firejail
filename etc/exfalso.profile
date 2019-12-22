# Firejail profile for exfalso
# Description: GTK audio tag editor
# This file is overwritten after every install/update
# Persistent local customizations
include exfalso.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.quodlibet
noblacklist ${MUSIC}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

whitelist ${DOWNLOADS}
whitelist ${MUSIC}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.quodlibet
whitelist ${HOME}/.quodlibet
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
netfilter
no3d
nodbus
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

private-bin exfalso,python*
private-cache
private-dev
private-etc X11,alternatives,ca-certificates,crypto-policies,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,tor,xdg
private-lib libatk-1.0.so.*,libgdk-3.so.*,libgdk_pixbuf-2.0.so.*,libgirepository-1.0.so.*,libgstreamer-1.0.so.*,libgtk-3.so.*,libgtksourceview-3.0.so.*,libpango-1.0.so.*,libpython*,libreadline.so.*,libsoup-2.4.so.*,libssl.so.1.*,python2*,python3*
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)
