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

whitelist /usr/share/mozilla
include whitelist-usr-share-common.inc

# firefox requires a shell to launch on Arch.
#private-bin bash,dbus-launch,dbus-send,env,firefox,sh,which
# Fedora use shell scripts to launch firefox, at least this is required
#private-bin basename,bash,cat,dirname,expr,false,firefox,firefox-wayland,ln,mkdir,pidof,rm,rmdir,sed,sh,tclsh,true,uname
# private-etc must first be enabled in firefox-common.profile
#private-etc firefox

# Redirect
include firefox-common.profile
