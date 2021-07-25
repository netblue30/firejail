# Firejail profile for Microsoft Edge Beta
# Description: Web browser from Microsoft,beta channel
# This file is overwritten after every install/update
# Persistent local customizations
include microsoft-edge-beta.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/microsoft-edge-beta
noblacklist ${HOME}/.config/microsoft-edge-beta

mkdir ${HOME}/.cache/microsoft-edge-beta
mkdir ${HOME}/.config/microsoft-edge-beta
whitelist ${HOME}/.cache/microsoft-edge-beta
whitelist ${HOME}/.config/microsoft-edge-beta

private-opt microsoft

# Redirect
include chromium-common.profile