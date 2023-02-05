# Firejail profile for celluloid
# Description: Simple GTK+ frontend for mpv
# This file is overwritten after every install/update
# Persistent local customizations
include celluloid.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/celluloid
noblacklist ${HOME}/.config/gnome-mpv
noblacklist ${HOME}/.config/youtube-dl

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.config/celluloid
mkdir ${HOME}/.config/gnome-mpv
mkdir ${HOME}/.config/youtube-dl
whitelist ${HOME}/.config/celluloid
whitelist ${HOME}/.config/gnome-mpv
whitelist ${HOME}/.config/youtube-dl
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
tracelog

private-bin celluloid,env,gnome-mpv,python*,youtube-dl
private-cache
private-etc @tls-ca,@x11,libva.conf,pkcs11,selinux
private-dev
private-tmp

dbus-user filter
dbus-user.own io.github.celluloid_player.Celluloid
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.gnome.SettingsDaemon.MediaKeys
dbus-system none

read-only ${HOME}
read-write ${HOME}/.config/celluloid
restrict-namespaces
