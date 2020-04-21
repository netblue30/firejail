# Firejail profile for vivaldi-snapshot
# This file is overwritten after every install/update
# Persistent local customizations
include vivaldi-snapshot.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/vivaldi-snapshot
noblacklist ${HOME}/.config/vivaldi-snapshot

mkdir ${HOME}/.cache/vivaldi-snapshot
mkdir ${HOME}/.config/vivaldi-snapshot
whitelist ${HOME}/.cache/vivaldi-snapshot
whitelist ${HOME}/.config/vivaldi-snapshot

# Redirect
include chromium-common.profile
