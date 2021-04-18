# Firejail profile for FireDragon
# Description: Librewolf fork with enhanced KDE integration
# This file is overwritten after every install/update
# Persistent local customizations
include firedragon.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/firedragon
noblacklist ${HOME}/.firedragon

mkdir ${HOME}/.cache/firedragon
mkdir ${HOME}/.firedragon
whitelist ${HOME}/.cache/firedragon
whitelist ${HOME}/.firedragon

# Add the next lines to your firedragon.local if you want to use the migration wizard.
#noblacklist ${HOME}/.mozilla
#whitelist ${HOME}/.mozilla

# FireDragon requires a shell to launch on Arch. We can possibly remove sh though.
# Add the next line to your firedragon.local to enable private-bin.
#private-bin bash,dbus-launch,dbus-send,env,firedragon,python*,sh,which
# Add the next line to your firedragon.local to enable private-etc. Note
# that private-etc must first be enabled in firedragon-common.local.
#private-etc firedragon

# Redirect
include firefox-common.profile
