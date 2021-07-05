# Firejail profile for Microsoft Edge Dev
# Description: Web browser from Microsoft,dev channel
# This file is overwritten after every install/update
# Persistent local customizations
include microsoft-edge-dev.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/microsoft-edge-dev
nodeny  ${HOME}/.config/microsoft-edge-dev

mkdir ${HOME}/.cache/microsoft-edge-dev
mkdir ${HOME}/.config/microsoft-edge-dev
allow  ${HOME}/.cache/microsoft-edge-dev
allow  ${HOME}/.config/microsoft-edge-dev

private-opt microsoft

# Redirect
include chromium-common.profile
