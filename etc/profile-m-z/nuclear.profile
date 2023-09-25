# Firejail profile for nuclear
# Description: Stream music from Youtube,Soundcloud,Jamendo
# This file is overwritten after every install/update
# Persistent local customizations
include nuclear.local
# Persistent global definitions
include globals.local

ignore dbus-user

noblacklist ${HOME}/.config/nuclear

include disable-shell.inc

mkdir ${HOME}/.config/nuclear
whitelist ${HOME}/.config/nuclear
whitelist /opt/nuclear

no3d

#private-bin nuclear
private-etc @tls-ca,@x11,host.conf,mime.types

# Redirect
include electron-common.profile
