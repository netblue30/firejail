# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-opengl-game.local

noblacklist ${PATH}/bash
whitelist /usr/share/opengl-games-utils/opengl-game-functions.sh
private-bin basename,bash,cut,glxinfo,grep,head,sed,zenity
