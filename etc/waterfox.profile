# Firejail profile for waterfox
# This file is overwritten after every install/update
# Persistent local customizations
include waterfox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/mozilla
noblacklist ${HOME}/.cache/waterfox
noblacklist ${HOME}/.mozilla
noblacklist ${HOME}/.waterfox

mkdir ${HOME}/.cache/mozilla/firefox
mkdir ${HOME}/.mozilla
mkdir ${HOME}/.cache/waterfox
mkdir ${HOME}/.waterfox
whitelist ${HOME}/.cache/mozilla/firefox
whitelist ${HOME}/.cache/waterfox
whitelist ${HOME}/.mozilla
whitelist ${HOME}/.waterfox

# waterfox requires a shell to launch on Arch. We can possibly remove sh though.
#private-bin waterfox,which,sh,dbus-launch,dbus-send,env,bash
# private-etc must first be enabled in firefox-common.profile
#private-etc waterfox

# Redirect
include firefox-common.profile
