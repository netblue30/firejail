# Firejail profile for lzdoom
# Description: Legacy OpenGL version of GZDoom
# This file is overwritten after every install/update
# Persistent local customizations
include lzdoom.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/lzdoom
noblacklist ${HOME}/.local/share/games/lzdoom

blacklist /usr/libexec

mkdir ${HOME}/.config/lzdoom
mkdir ${HOME}/.local/share/games/lzdoom
whitelist ${HOME}/.config/lzdoom
whitelist ${HOME}/.local/share/games/lzdoom
whitelist /usr/local/share/games/lzdoom
whitelist /usr/share/games/lzdoom

private-bin bash,dash,gdb,lzdoom,sh,uname,which,xmessage

# Redirect
include gzdoom-common.profile
