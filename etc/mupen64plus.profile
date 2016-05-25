# mupen64plus profile
# manually whitelist ROM files
noblacklist ${HOME}/.config/mupen64plus
noblacklist ${HOME}/.local/share/mupen64plus

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

mkdir ${HOME}/.local
mkdir ${HOME}/.local/share
mkdir ${HOME}/.local/share/mupen64plus
whitelist ${HOME}/.local/share/mupen64plus/
mkdir ${HOME}/.config
mkdir ${HOME}/.config/mupen64plus
whitelist ${HOME}/.config/mupen64plus/

nonewprivs
noroot
caps.drop all
seccomp
net none
