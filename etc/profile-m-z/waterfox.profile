# Firejail profile for waterfox
# This file is overwritten after every install/update
# Persistent local customizations
include waterfox.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/waterfox
nodeny  ${HOME}/.waterfox

mkdir ${HOME}/.cache/waterfox
mkdir ${HOME}/.waterfox
allow  ${HOME}/.cache/waterfox
allow  ${HOME}/.waterfox

# Add the next lines to your watefox.local if you want to use the migration wizard.
#noblacklist ${HOME}/.mozilla
#whitelist ${HOME}/.mozilla

# waterfox requires a shell to launch on Arch. We can possibly remove sh though.
# Add the next line to your waterfox.local to enable private-bin.
#private-bin bash,dbus-launch,dbus-send,env,sh,waterfox,waterfox-classic,waterfox-current,which
# Add the next line to your waterfox.local to enable private-etc. Note that private-etc must first be
# enabled in your firefox-common.local.
#private-etc waterfox

# Redirect
include firefox-common.profile
