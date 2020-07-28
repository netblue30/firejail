# Firejail profile for apostrophe
# Description: Distraction free Markdown editor for GNU/Linux made with GTK+
# This file is overwritten after every install/update
# Persistent local customizations
include apostrophe.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/apostrophe
whitelist /usr/share/pandoc-*
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
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
shell none
tracelog

disable-mnt
private-bin apostrophe,pandoc,python3*
private-cache
private-dev
private-etc alternatives,dconf,fonts,gtk-3.0,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,pango,X11
private-tmp

dbus-user filter
dbus-user.own org.gnome.gitlab.somas.Apostrophe
dbus-user.talk ca.desrt.dconf
dbus-system none
