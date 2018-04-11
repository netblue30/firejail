# Firejail profile for firefox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/firefox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/mozilla
noblacklist ${HOME}/.mozilla
noblacklist ${HOME}/.proxychains

mkdir ${HOME}/.cache/mozilla/firefox
mkdir ${HOME}/.mozilla
mkdir ${HOME}/.proxychains
whitelist ${HOME}/.cache/mozilla/firefox
whitelist ${HOME}/.mozilla
whitelist ${HOME}/.proxychains

# firefox requires a shell to launch on Arch.
#private-bin firefox,which,sh,dbus-launch,dbus-send,env,bash
# private-etc must first be enabled in firefox-common.profile
#private-etc firefox

# Redirect
include /etc/firejail/firefox-common.profile
