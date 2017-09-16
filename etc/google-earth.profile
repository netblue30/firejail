# Firejail profile for google-earth
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/google-earth.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Google
noblacklist ${HOME}/.googleearth 

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/Google
mkdir ${HOME}/.googleearth
whitelist ${HOME}/.config/Google
whitelist ${HOME}/.googleearth
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
nogroups
noroot
seccomp
shell none

private-bin google-earth,sh,grep,sed,ls,dirname
private-dev
#private-etc fonts,resolv.conf,X11,alternatives,pulse

noexec ${HOME}
noexec /tmp
