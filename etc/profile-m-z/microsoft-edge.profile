# Firejail profile for Microsoft Edge
# Description: Web browser from Microsoft,stable channel
# This file is overwritten after every install/update
# Persistent local customizations
include microsoft-edge.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/microsoft-edge
noblacklist ${HOME}/.config/microsoft-edge

mkdir ${HOME}/.cache/microsoft-edge
mkdir ${HOME}/.config/microsoft-edge
whitelist ${HOME}/.cache/microsoft-edge
whitelist ${HOME}/.config/microsoft-edge

whitelist /opt/microsoft/msedge

# Redirect
include chromium-common.profile
