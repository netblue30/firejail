# Firejail profile for linphone
# Description: SIP softphone - graphical client
# This file is overwritten after every install/update
# Persistent local customizations
include linphone.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.linphone-history.db
noblacklist ${HOME}/.linphonerc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkfile ${HOME}/.linphone-history.db
mkfile ${HOME}/.linphonerc
whitelist ${HOME}/.linphone-history.db
whitelist ${HOME}/.linphonerc
whitelist ${DOWNLOADS}
include whitelist-common.inc

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
shell none

disable-mnt
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

