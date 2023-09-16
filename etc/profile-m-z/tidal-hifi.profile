# Firejail profile for tidal-hifi
# Description: The web version of Tidal running in electron with hifi support thanks to widevine.
# This file is overwritten after every install/update
# Persistent local customizations
include tidal-hifi.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

noblacklist ${HOME}/.config/tidal-hifi

include disable-proc.inc
include disable-shell.inc

whitelist ${HOME}/.config/tidal-hifi

caps.drop all
no3d
nonewprivs
noprinters
noroot
protocol unix,inet,inet6
seccomp !chroot
seccomp.block-secondary
tracelog

private-bin chrome-sandbox,tidal-hifi
private-etc @network,@sound,@tls-ca,@xdg
private-opt tidal-hifi

ignore dbus-user none
dbus-user filter
dbus-user.own org.mpris.MediaPlayer2.tidal-hifi
dbus-user.talk org.freedesktop.Notifications

join-or-start tidal-hifi

include electron-common.profile
