# Firejail profile for Librewolf
# Description: Firefox fork based on privacy
# This file is overwritten after every install/update
# Persistent local customizations
include librewolf.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/librewolf
noblacklist ${HOME}/.librewolf

mkdir ${HOME}/.cache/librewolf
mkdir ${HOME}/.librewolf
whitelist ${HOME}/.cache/librewolf
whitelist ${HOME}/.librewolf

# Add the next lines to your librewolf.local if you want to use the migration wizard.
#noblacklist ${HOME}/.mozilla
#whitelist ${HOME}/.mozilla

# librewolf requires a shell to launch on Arch. We can possibly remove sh though.
# Add the next line to your librewolf.local to enable private-bin.
#private-bin bash,dbus-launch,dbus-send,env,librewolf,python*,sh,which
# Add the next line to your librewolf.local to enable private-etc. Note
# that private-etc must first be enabled in firefox-common.local.
#private-etc librewolf

# Redirect
include firefox-common.profile
