# Firejail profile for Microsoft Edge Dev
# Description: Web browser from Microsoft, dev channel
# This file is overwritten after every install/update
# Persistent local customizations
include microsoft-edge-dev.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/microsoft-edge-dev
noblacklist ${HOME}/.config/microsoft-edge-dev
noblacklist /opt/microsoft/msedge-dev/msedge-sandbox

mkdir ${HOME}/.cache/microsoft-edge-dev
mkdir ${HOME}/.config/microsoft-edge-dev
whitelist ${HOME}/.cache/microsoft-edge-dev
whitelist ${HOME}/.config/microsoft-edge-dev

whitelist /opt/microsoft/msedge-dev
# private-opt might break file-copy-limit, see #5307
#private-opt microsoft

# Redirect
include chromium-common.profile
