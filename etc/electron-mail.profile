# Firejail profile for electron-mail
# Description: Unofficial desktop app for several E2E encrypted email providers
# This file is overwritten after every install/update
# Persistent local customizations
include electron-mail.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/electron-mail

whitelist ${DOWNLOADS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/electron-mail
whitelist ${HOME}/.config/electron-mail

include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
# nodbus - breaks tray functionality
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp !chroot
shell none
# tracelog - breaks on Arch

private-bin electron-mail
private-cache
private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-opt ElectronMail
private-tmp

# memory-deny-write-execute - breaks on Arch
