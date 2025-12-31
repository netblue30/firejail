# Firejail profile for gzdoom
# Description: OpenGL version of ZDoom
# This file is overwritten after every install/update
# Persistent local customizations
include gzdoom.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gzdoom
noblacklist ${HOME}/.local/share/games/gzdoom

blacklist /usr/libexec

mkdir ${HOME}/.config/gzdoom
mkdir ${HOME}/.local/share/games/gzdoom
whitelist ${HOME}/.config/gzdoom
whitelist ${HOME}/.local/share/games/gzdoom

private-bin bash,dash,gdb,gzdoom,sh,uname,which,xmessage

# Redirect
include gzdoom-common.profile
