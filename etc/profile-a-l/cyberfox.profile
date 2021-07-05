# Firejail profile for cyberfox
# This file is overwritten after every install/update
# Persistent local customizations
include cyberfox.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.8pecxstudios
nodeny  ${HOME}/.cache/8pecxstudios

mkdir ${HOME}/.8pecxstudios
mkdir ${HOME}/.cache/8pecxstudios
allow  ${HOME}/.8pecxstudios
allow  ${HOME}/.cache/8pecxstudios

# private-bin cyberfox,dbus-launch,dbus-send,env,sh,which
# private-etc must first be enabled in firefox-common.profile
#private-etc cyberfox

# Redirect
include firefox-common.profile
