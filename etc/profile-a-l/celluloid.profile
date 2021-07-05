# Firejail profile for celluloid
# Description: Simple GTK+ frontend for mpv
# This file is overwritten after every install/update
# Persistent local customizations
include celluloid.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/celluloid
nodeny  ${HOME}/.config/gnome-mpv
nodeny  ${HOME}/.config/youtube-dl

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

deny  /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

read-only ${DESKTOP}
mkdir ${HOME}/.config/celluloid
mkdir ${HOME}/.config/gnome-mpv
mkdir ${HOME}/.config/youtube-dl
allow  ${HOME}/.config/celluloid
allow  ${HOME}/.config/gnome-mpv
allow  ${HOME}/.config/youtube-dl
include whitelist-common.inc
include whitelist-player-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nogroups
noinput
nonewprivs
noroot
nou2f
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
shell none
tracelog

private-bin celluloid,env,gnome-mpv,python*,youtube-dl
private-cache
private-etc alternatives,ca-certificates,crypto-policies,dconf,drirc,fonts,gtk-3.0,hosts,ld.so.cache,libva.conf,localtime,machine-id,pkcs11,pki,resolv.conf,selinux,ssl,xdg
private-dev
private-tmp

dbus-user filter
dbus-user.own io.github.celluloid_player.Celluloid
dbus-user.talk org.gnome.SettingsDaemon.MediaKeys
dbus-system none

read-only ${HOME}
read-write ${HOME}/.config/celluloid
