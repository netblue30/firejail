# Firejail profile for uzdoom
# Description: UZDoom is a modern, feature-rich source port for the classic game DOOM
# This file is overwritten after every install/update
# Persistent local customizations
include uzdoom.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/uzdoom
noblacklist ${HOME}/.local/share/games/uzdoom

blacklist /usr/libexec

mkdir ${HOME}/.config/uzdoom
mkdir ${HOME}/.local/share/games/uzdoom
whitelist ${HOME}/.config/uzdoom
whitelist ${HOME}/.local/share/games/uzdoom
whitelist /usr/local/share/games/uzdoom
whitelist /usr/share/games/uzdoom

private-bin bash,dash,gdb,sh,uname,uzdoom,which,xmessage

# Redirect
include gzdoom-common.profile
