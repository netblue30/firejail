# Firejail profile for virtualbox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/virtualbox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.VirtualBox
noblacklist ${HOME}/.config/VirtualBox
noblacklist ${HOME}/VirtualBox VMs
# noblacklist /usr/bin/virtualbox
noblacklist /usr/lib/virtualbox
noblacklist /usr/lib64/virtualbox

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.config/VirtualBox
mkdir ~/VirtualBox VMs
whitelist ~/.config/VirtualBox
whitelist ~/VirtualBox VMs
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
notv
