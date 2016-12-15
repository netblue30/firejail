# virtualbox profile
noblacklist ${HOME}/.VirtualBox
noblacklist ${HOME}/VirtualBox VMs
noblacklist ${HOME}/.config/VirtualBox

mkdir ~/VirtualBox VMs
whitelist ~/VirtualBox VMs
mkdir ~/.config/VirtualBox
whitelist ~/.config/VirtualBox

# noblacklist /usr/bin/virtualbox
noblacklist /usr/lib/virtualbox
noblacklist /usr/lib64/virtualbox
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter


