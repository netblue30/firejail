# VirtualBox profile

noblacklist ${HOME}/.VirtualBox
noblacklist ${HOME}/VirtualBox VMs
noblacklist ${HOME}/.config/VirtualBox
noblacklist /usr/bin/virtualbox
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all


