# Firejail profile for claws-mail
# Description: Fast, lightweight and user-friendly GTK+2 based email client
# This file is overwritten after every install/update
# Persistent local customizations
include claws-mail.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.claws-mail
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.signature

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist /usr/share/doc
whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
include whitelist-usr-share-common.inc

caps.drop all
netfilter
no3d
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

private-cache
private-dev
#private-etc X11,alternatives,ca-certificates,certs,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mailcap,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,shadow,ssl,xdg
private-tmp

# If you want to read local mail stored in /var/mail, add the following to claws-mail.local:
# noblacklist /var/mail
# noblacklist /var/spool/mail
# writable-var
