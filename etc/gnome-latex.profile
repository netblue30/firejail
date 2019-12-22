# Firejail profile for gnome-latex
# Description: LaTeX editor for the GNOME desktop
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-latex.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gnome-latex
noblacklist ${HOME}/.local/share/gnome-latex

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist /usr/share/gnome-latex
whitelist /usr/share/perl5
whitelist /usr/share/texlive
include whitelist-usr-share-common.inc
# May cause issues.
#include whitelist-var-common.inc

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

private-cache
private-dev
private-etc X11,alternatives,dbus-1,dconf,fonts,gconf,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,pango,passwd,xdg
# passwd,login.defs,firejail are a temporary workaround for #2877 and can be removed once it is fixed
