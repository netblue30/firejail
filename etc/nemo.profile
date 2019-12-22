# Firejail profile for nemo
# Description: File manager and graphical shell for Cinnamon
# This file is overwritten after every install/update
# Persistent local customizations
include nemo.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/nemo
noblacklist ${HOME}/.local/share/Trash
noblacklist ${HOME}/.local/share/nemo
noblacklist ${HOME}/.local/share/nemo-python

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc

allusers
caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none


#private-etc Trolltech.conf,X11,alternatives,ca-certificates,crypto-policies,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
