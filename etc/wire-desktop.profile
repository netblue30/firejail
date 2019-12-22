# Firejail profile for wire-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include wire-desktop.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Wire

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/Wire
whitelist ${HOME}/.config/Wire
whitelist ${DOWNLOADS}
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none

# Note: The current version of Wire is located in /opt/wire-desktop/wire-desktop, and therefore
# it is not in PATH. To use Wire with firejail, run "firejail /opt/wire-desktop/wire-desktop"

disable-mnt
private-bin bash,electron,electron4,env,sh,wire-desktop
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp
