# Firejail profile for tuir
# Description: Browse Reddit from your terminal (rtv fork)
# This file is overwritten after every install/update
# Persistent local customizations
include tuir.local
# Persistent global definitions
#include globals.local

ignore mkdir ${HOME}/.config/rtv
ignore mkdir ${HOME}/.local/share/rtv

noblacklist ${HOME}/.config/tuir
noblacklist ${HOME}/.local/share/tuir

mkdir ${HOME}/.config/tuir
mkdir ${HOME}/.local/share/tuir
whitelist ${HOME}/.config/tuir
whitelist ${HOME}/.local/share/tuir

private-bin tuir

# Redirect
include rtv.profile
