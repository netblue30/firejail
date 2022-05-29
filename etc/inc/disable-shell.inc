# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-shell.local

blacklist ${PATH}/bash
blacklist ${PATH}/csh
blacklist ${PATH}/dash
blacklist ${PATH}/fish
blacklist ${PATH}/ksh
blacklist ${PATH}/mksh
blacklist ${PATH}/oksh
blacklist ${PATH}/sh
blacklist ${PATH}/tclsh
blacklist ${PATH}/tcsh
blacklist ${PATH}/zsh
blacklist /etc/profile.d
