# Firejail profile for mupen64plus
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mupen64plus.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/mupen64plus
noblacklist ${HOME}/.local/share/mupen64plus

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

# you'll need to manually whitelist ROM files
mkdir ${HOME}/.config/mupen64plus
mkdir ${HOME}/.local/share/mupen64plus
whitelist ${HOME}/.config/mupen64plus/
whitelist ${HOME}/.local/share/mupen64plus/
include /etc/firejail/whitelist-common.inc

caps.drop all
net none
nodvd
nonewprivs
noroot
notv
novideo
seccomp
