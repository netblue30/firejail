# Firejail profile for firefox
# Description: Safe and easy web browser from Mozilla
# This file is overwritten after every install/update
# Persistent local customizations
include firefox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/mozilla
noblacklist ${HOME}/.mozilla

mkdir ${HOME}/.cache/mozilla/firefox
mkdir ${HOME}/.mozilla
whitelist ${HOME}/.cache/mozilla/firefox
whitelist ${HOME}/.mozilla

# firefox requires a shell to launch on Arch.
#private-bin firefox,which,sh,dbus-launch,dbus-send,env,bash
# private-etc must first be enabled in firefox-common.profile
#private-etc firefox

# Redirect
include firefox-common.profile
