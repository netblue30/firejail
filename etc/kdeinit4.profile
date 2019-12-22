# Firejail profile for kdeinit4
# This file is overwritten after every install/update
# Persistent local customizations
include kdeinit4.local
# Persistent global definitions
include globals.local

# use outside KDE Plasma 4

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
# nosound - disabled for knotify
noroot
nou2f
novideo
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin kbuildsycoca4,kded4,kdeinit4,knotify4
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dbus-1,fonts,hosts,host.conf,hostname,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

