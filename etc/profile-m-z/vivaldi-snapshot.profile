# Firejail profile for vivaldi-snapshot
# This file is overwritten after every install/update
# Persistent local customizations
include vivaldi-snapshot.local

noblacklist ${HOME}/.cache/vivaldi-snapshot
noblacklist ${HOME}/.config/vivaldi-snapshot

mkdir ${HOME}/.cache/vivaldi-snapshot
mkdir ${HOME}/.config/vivaldi-snapshot
whitelist ${HOME}/.cache/vivaldi-snapshot
whitelist ${HOME}/.config/vivaldi-snapshot

# Add the next line to your vivaldi-snapshot.local to enable private-bin.
# Note: this first needs to be enabled in vivaldi.local too.
#private-bin vivaldi-snapshot

# Redirect
include vivaldi.profile
