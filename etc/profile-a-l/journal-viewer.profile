# Firejail profile for journal-viewer
# Description: Visualize systemd logs
# This file is overwritten after every install/update
# Persistent local customizations
include journal-viewer.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/journal-viewer
noblacklist ${HOME}/.local/share/com.vmingueza.journal-viewer

mkdir ${HOME}/.cache/journal-viewer
mkdir ${HOME}/.local/share/com.vmingueza.journal-viewer
whitelist ${HOME}/.cache/journal-viewer
whitelist ${HOME}/.local/share/com.vmingueza.journal-viewer

private-bin journal-viewer
private-lib webkit2gtk-*

read-write ${HOME}/.cache/journal-viewer
read-write ${HOME}/.local/share/com.vmingueza.journal-viewer

# Redirect
include system-log-common.profile
