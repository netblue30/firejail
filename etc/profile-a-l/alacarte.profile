# Firejail profile for alacarte
# Description: Create desktop and menu launchers easily
# This file is overwritten after every install/update
# Persistent local customizations
include alacarte.local
# Persistent global definitions
include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-passwdmgr.inc
include disable-xdg.inc

# Whitelist your system icon directory,varies by distro
whitelist /usr/share/alacarte
whitelist /usr/share/app-info
whitelist /usr/share/desktop-directories
whitelist /usr/share/icons
whitelist /var/lib/app-info/icons
whitelist /var/lib/flatpak/exports/share/applications
whitelist /var/lib/flatpak/exports/share/icons
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
nodvd
no3d
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

disable-mnt
# private-bin alacarte,bash,python*,sh
private-cache
private-dev
private-etc alternatives,dconf,fonts,gtk-3.0,locale.alias,locale.conf,login.defs,mime.types,nsswitch.conf,passwd,pki,X11,xdg
private-tmp

dbus-user none
dbus-system none

read-write ${HOME}/.config/menus
read-write ${HOME}/.gnome/apps
read-write ${HOME}/.local/share/applications
read-write ${HOME}/.local/share/flatpak/exports
