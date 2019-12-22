# Firejail profile for libreoffice
# Description: Office productivity suite
# This file is overwritten after every install/update
# Persistent local customizations
include libreoffice.local
# Persistent global definitions
include globals.local

noblacklist /usr/local/sbin
noblacklist ${HOME}/.config/libreoffice

# libreoffice uses java for some certain operations
# comment if you don't care about java functionality
# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

# ubuntu 18.04 comes with its own apparmor profile, but it is not in enforce mode.
# comment the next line to use the ubuntu profile instead of firejail's apparmor profile
apparmor
caps.drop all
netfilter
nodvd
nogroups
# comment nonewprivs when using the ubuntu 18.04/debian 10 apparmor profile
nonewprivs
noroot
notv
nou2f
novideo
# comment the protocol line when using the ubuntu 18.04/debian 10 apparmor profile
protocol unix,inet,inet6
# comment seccomp when using the ubuntu 18.04/debian 10 apparmor profile
seccomp
shell none
# comment tracelog when using the ubuntu 18.04/debian 10 apparmor profile
tracelog

private-dev
private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dbus-1,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
private-tmp

join-or-start libreoffice
