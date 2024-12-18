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

private-etc @tls-ca

# Needed for keychain things, talking to Firefox, possibly other things?
ignore dbus-user none

# Redirect
include electron-common.profile
