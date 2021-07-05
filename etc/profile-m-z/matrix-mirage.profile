# Firejail profile for matrix-mirage
# Description: Debian name for mirage binary/package
# This file is overwritten after every install/update
# Persistent local customizations
include matrix-mirage.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.cache/matrix-mirage
nodeny  ${HOME}/.config/matrix-mirage
nodeny  ${HOME}/.local/share/matrix-mirage

mkdir ${HOME}/.cache/matrix-mirage
mkdir ${HOME}/.config/matrix-mirage
mkdir ${HOME}/.local/share/matrix-mirage
allow  ${HOME}/.cache/matrix-mirage
allow  ${HOME}/.config/matrix-mirage
allow  ${HOME}/.local/share/matrix-mirage

private-bin matrix-mirage

# Redirect
include mirage.profile
