# Firejail profile for mupen64plus
# Description: Nintendo64 Emulator
# This file is overwritten after every install/update
# Persistent local customizations
include mupen64plus.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mupen64plus
noblacklist ${HOME}/.local/share/mupen64plus

include disable-common.inc
include disable-devel.inc
include disable-passwdmgr.inc
include disable-passwdmgr.inc
include disable-programs.inc

# you'll need to manually whitelist ROM files
mkdir ${HOME}/.config/mupen64plus
mkdir ${HOME}/.local/share/mupen64plus
whitelist ${HOME}/.config/mupen64plus
whitelist ${HOME}/.local/share/mupen64plus
include whitelist-common.inc

caps.drop all
net none
nodbus
nodvd
nonewprivs
noroot
notv
novideo
seccomp
