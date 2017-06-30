# Persistent global definitions go here
include /etc/firejail/global.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/liferea.local

#######################
# profile for Liferea #
#######################
noblacklist ~/.config/liferea
mkdir ~/.config/liferea
whitelist ~/.config/liferea

noblacklist ~/.local/share/liferea
mkdir ~/.local/share/liferea
whitelist ~/.local/share/liferea

noblacklist ~/.cache/liferea
mkdir ~/.cache/liferea
whitelist ~/.cache/liferea

include /etc/firejail/whitelist-common.inc
include /etc/firejail/default.profile

nogroups
shell none
private-dev
private-tmp
