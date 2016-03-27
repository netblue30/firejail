# mupen64plus profile
# manually whitelist ROM files
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-terminals.inc
mkdir ${HOME}/.local
mkdir ${HOME}/.local/share
mkdir ${HOME}/.local/share/mupen64plus
whitelist ${HOME}/.local/share/mupen64plus/
mkdir ${HOME}/.config
mkdir ${HOME}/.config/mupen64plus
whitelist ${HOME}/.config/mupen64plus/
noroot
caps.drop all
seccomp
net none
