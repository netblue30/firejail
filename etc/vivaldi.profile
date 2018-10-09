# Firejail profile for vivaldi
# This file is overwritten after every install/update
# Persistent local customizations
include vivaldi.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/vivaldi
noblacklist ${HOME}/.config/vivaldi

mkdir ${HOME}/.cache/vivaldi
mkdir ${HOME}/.config/vivaldi
whitelist ${HOME}/.cache/vivaldi
whitelist ${HOME}/.config/vivaldi

# nodbus breaks vivaldi sync
ignore nodbus

# Redirect
include chromium-common.profile
