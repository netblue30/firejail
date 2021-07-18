# Firejail profile for Microsoft Edge Beta
# Description: Web browser from Microsoft,beta channel
# This file is overwritten after every install/update
# Persistent local customizations
include microsoft-edge-beta.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/microsoft-edge-beta
nodeny  ${HOME}/.config/microsoft-edge-beta

mkdir ${HOME}/.cache/microsoft-edge-beta
mkdir ${HOME}/.config/microsoft-edge-beta
allow  ${HOME}/.cache/microsoft-edge-beta
allow  ${HOME}/.config/microsoft-edge-beta

private-opt microsoft

# Redirect
include chromium-common.profile