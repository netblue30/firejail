# Firejail profile for 1password
# Description: 1Password is a password manager developed by AgileBits Inc.
# This file is overwritten after every install/update
# Persistent local customizations
include 1password.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/1Password

mkdir ${HOME}/.config/1Password
whitelist ${HOME}/.config/1Password

private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,localtime,machine-id,nsswitch.conf,pki,resolv.conf,ssl

# Needed for keychain things, talking to Firefox, possibly other things?  Not sure how to narrow down
ignore dbus-user none

# Redirect
include electron.profile
