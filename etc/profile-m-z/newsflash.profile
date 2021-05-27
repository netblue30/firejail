# Firejail profile for newsflash
# Description: Modern feed reader
# This file is overwritten after every install/update
# Persistent local customizations
include newsflash.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/NewsFlashGTK
noblacklist ${HOME}/.config/news-flash
noblacklist ${HOME}/.local/share/news-flash

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/NewsFlashGTK
mkdir ${HOME}/.config/news-flash
mkdir ${HOME}/.local/share/news-flash
whitelist ${HOME}/.cache/NewsFlashGTK
whitelist ${HOME}/.config/news-flash
whitelist ${HOME}/.local/share/news-flash
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin com.gitlab.newsflash,newsflash
private-cache
private-dev
private-etc ca-certificates,crypto-policies,dconf,fonts,gtk-3.0,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,nsswitch.conf,pango,pki,resolv.conf,ssl,X11
private-tmp

dbus-user none
#dbus-user.own com.gitlab.newsflash
#dbus-user.talk org.freedesktop.Notifications
dbus-system none
