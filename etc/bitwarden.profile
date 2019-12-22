# Firejail profile for bitwarden
# Description: A secure and free password manager for all of your devices
# This file is overwritten after every install/update.
# Persistent local customisations
include bitwarden.local
# Persistent global definitions
include globals.local

private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
ignore noexec /tmp

noblacklist ${HOME}/.config/Bitwarden

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/Bitwarden
whitelist ${HOME}/.config/Bitwarden
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
no3d
#nodbus - breaks appindicator (tray) functionality
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
#tracelog - breaks on Arch

private-bin bitwarden
private-cache
?HAS_APPIMAGE: ignore private-dev
private-dev
private-opt Bitwarden
private-tmp

#memory-deny-write-execute - breaks on Arch (see issue #1803)
