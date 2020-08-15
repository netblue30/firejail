# Firejail profile for element-desktop
# Description: All-in-one secure chat app for teams, friends and organisations
# This file is overwritten after every install/update
# Persistent local customizations
include element-desktop.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.config/Element
noblacklist ${HOME}/.config/Element (Riot)

mkdir ${HOME}/.config/Element
mkdir ${HOME}/.config/Element (Riot)
whitelist ${HOME}/.config/Element
whitelist ${HOME}/.config/Element (Riot)
whitelist /opt/Element

private-opt Element

# Redirect
include riot-desktop.profile
