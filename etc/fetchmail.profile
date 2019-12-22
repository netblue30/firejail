# Firejail profile for fetchmail
# Description: SSL enabled POP3, APOP, IMAP mail gatherer/forwarder
# This file is overwritten after every install/update
# Persistent local customizations
include fetchmail.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.fetchmailrc
noblacklist ${HOME}/.netrc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

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

#private-bin bash,chmod,fetchmail,procmail
private-dev
#private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dbus-1,dconf,default,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,logcheck,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,ppp,protocols,resolv.conf,resolvconf,rpc,services,ssl,xdg
