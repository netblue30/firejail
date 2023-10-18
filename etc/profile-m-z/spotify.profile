# Firejail profile for spotify
# This file is overwritten after every install/update
# Persistent local customizations
include spotify.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/spotify
noblacklist ${HOME}/.config/spotify
noblacklist ${HOME}/.config/spotify-adblock
noblacklist ${HOME}/.local/share/spotify

blacklist ${HOME}/.bashrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc

mkdir ${HOME}/.cache/spotify
mkdir ${HOME}/.config/spotify
mkdir ${HOME}/.local/share/spotify
whitelist ${HOME}/.cache/spotify
whitelist ${HOME}/.config/spotify
whitelist ${HOME}/.config/spotify-adblock
whitelist ${HOME}/.local/share/spotify
whitelist /opt/spotify
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
tracelog

disable-mnt
private-bin bash,cat,dirname,find,grep,head,rm,sh,spotify,tclsh,touch,zenity
private-dev
# If you want to see album covers or want to use the radio, add 'ignore private-etc' to your spotify.local.
private-etc @tls-ca,host.conf,spotify-adblock
private-srv none
private-tmp

dbus-user filter
dbus-user.own org.mpris.MediaPlayer2.spotify
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.mpris.MediaPlayer2.Player
dbus-system none

restrict-namespaces
