# Firejail profile for devilspie2
# Description: Window matching daemon (Lua)
# This file is overwritten after every install/update
# Persistent local customizations
include devilspie2.local
# Persistent global definitions
#include globals.local

blacklist ${HOME}/.devilspie

blacklist ${RUNUSER}/wayland-*

noblacklist ${HOME}/.config/devilspie2

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

mkdir ${HOME}/.config/devilspie2
whitelist ${HOME}/.config/devilspie2

private-bin devilspie2

# Redirect
include devilspie.profile
