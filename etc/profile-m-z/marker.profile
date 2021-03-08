# Firejail profile for marker
# Description: Marker is a markdown editor for Linux made with Gtk+-3.0
# This file is overwritten after every install/update
# Persistent local customizations
include marker.local
# Persistent global definitions
include globals.local

# Uncomment (or add to your marker.local) if you need internet access.
#ignore net none
#protocol unix,inet,inet6
#private-etc ca-certificates,ssl,pki,crypto-policies,nsswitch.conf,resolv.conf

noblacklist ${HOME}/.cache/marker
noblacklist ${DOCUMENTS}

include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/com.github.fabiocolacio.marker
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
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
protocol unix
seccomp
seccomp.block-secondary
shell none
tracelog

private-bin marker,python3*
private-cache
private-dev
private-etc alternatives,dconfgtk-3.0,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,pango,X11
private-tmp

dbus-user filter
dbus-user.own com.github.fabiocolacio.marker
dbus-user.talk ca.desrt.dconf
dbus-system none
