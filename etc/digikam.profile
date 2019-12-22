# Firejail profile for digikam
# Description: Digital photo management application for KDE
# This file is overwritten after every install/update
# Persistent local customizations
include digikam.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/digikam
noblacklist ${HOME}/.config/digikamrc
noblacklist ${HOME}/.kde/share/apps/digikam
noblacklist ${HOME}/.kde4/share/apps/digikam
noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
# nodbus
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

# private-dev - prevents libdc1394 loading; this lib is used to connect to a camera device
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,drirc,fonts,glvnd,hosts,host.conf,hostname,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp
