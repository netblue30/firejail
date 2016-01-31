# mupen64plus profile
# manually whitelist ROM files
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
whitelist ${HOME}/.local/share/mupen64plus/
whitelist ${HOME}/.config/mupen64plus/
noroot
caps.drop all
seccomp
net none
