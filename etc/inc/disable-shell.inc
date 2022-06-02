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

# Note: This list should be kept in sync with the one in ../ids.config.
### shells global ###
# all
blacklist /etc/dircolors
blacklist /etc/environment
blacklist /etc/profile
blacklist /etc/profile.d
blacklist /etc/shells
blacklist /etc/skel
# bash
blacklist /etc/bash
blacklist /etc/bash.bashrc
blacklist /etc/bash_completion*
blacklist /etc/bashrc
# fish
blacklist /etc/fish
# ksh
blacklist /etc/ksh.kshrc
blacklist /etc/suid_profile
# tcsh
blacklist /etc/complete.tcsh
blacklist /etc/csh.cshrc
blacklist /etc/csh.login
blacklist /etc/csh.logout
# zsh
blacklist /etc/zlogin
blacklist /etc/zlogout
blacklist /etc/zprofile
blacklist /etc/zsh
blacklist /etc/zshenv
blacklist /etc/zshrc
