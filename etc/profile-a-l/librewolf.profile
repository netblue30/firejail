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

# Uncomment (or add to librewolf.local) the following lines if you want to
# use the migration wizard.
#noblacklist ${HOME}/.mozilla
#whitelist ${HOME}/.mozilla

whitelist /usr/share/doc
whitelist /usr/share/gnome-shell/search-providers/firefox-search-provider.ini
whitelist /usr/share/gtk-doc/html
whitelist /usr/share/mozilla
whitelist /usr/share/webext

# librewolf requires a shell to launch on Arch. We can possibly remove sh though.
#private-bin bash,dbus-launch,dbus-send,env,librewolf,python*,sh,which
# private-etc must first be enabled in firefox-common.profile
#private-etc librewolf

# Redirect
include firefox-common.profile
