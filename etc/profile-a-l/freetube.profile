# Firejail profile for freetube
# Description: Youtube client with local subscription feature
# This file is overwritten after every install/update
# Persistent local customizations
include freetube.local
# Persistent global definitions
include globals.local

ignore dbus-user none

noblacklist ${HOME}/.config/FreeTube

include allow-bin-sh.inc

include disable-shell.inc

mkdir ${HOME}/.config/FreeTube
whitelist ${HOME}/.config/FreeTube

private-bin electron,electron[0-9],electron[0-9][0-9],freetube,sh
private-etc @tls-ca,@x11,host.conf,mime.types

dbus-user filter
dbus-user.own org.mpris.MediaPlayer2.chromium.*
dbus-user.own org.mpris.MediaPlayer2.freetube

# Redirect
include electron.profile
