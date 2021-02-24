# Firejail profile for signal-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include signal-desktop.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc
ignore private-cache
ignore novideo

ignore noexec /tmp

noblacklist ${HOME}/.config/Signal

# These lines are needed to allow Firefox to open links
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini
read-only ${HOME}/.mozilla/firefox/profiles.ini

mkdir ${HOME}/.config/Signal
whitelist ${HOME}/.config/Signal

private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,machine-id,nsswitch.conf,pki,resolv.conf,ssl

# Redirect
include electron.profile
