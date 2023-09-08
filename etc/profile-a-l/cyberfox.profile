# Firejail profile for cyberfox
# This file is overwritten after every install/update
# Persistent local customizations
include cyberfox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.8pecxstudios
noblacklist ${HOME}/.cache/8pecxstudios

mkdir ${HOME}/.8pecxstudios
mkdir ${HOME}/.cache/8pecxstudios
whitelist ${HOME}/.8pecxstudios
whitelist ${HOME}/.cache/8pecxstudios
whitelist /usr/share/8pecxstudios
whitelist /usr/share/cyberfox

#private-bin cyberfox,dbus-launch,dbus-send,env,sh,which
# private-etc must first be enabled in firefox-common.profile
#private-etc cyberfox

# Redirect
include firefox-common.profile
