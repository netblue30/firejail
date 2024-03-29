# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-opengl-game.local

# Explanation: Fedora (and maybe others) install a .desktop file that uses
# `Exec=foo-wrapper` instead of `Exec=foo`.  Each /usr/bin/foo-wrapper is a
# symlink to /usr/bin/opengl-game-wrapper.sh, which checks hardware
# acceleration and then starts the game or notifies the user that there is a
# problem.

noblacklist ${PATH}/bash
whitelist /usr/share/opengl-games-utils/opengl-game-functions.sh
private-bin basename,bash,cut,glxinfo,grep,head,sed,zenity
