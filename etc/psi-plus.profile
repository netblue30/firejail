# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/psi-plus.local

# Firejail profile for Psi+
noblacklist ${HOME}/.config/psi+
noblacklist ${HOME}/.local/share/psi+
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

whitelist ${DOWNLOADS}
mkdir ~/.config/psi+
whitelist ~/.config/psi+
mkdir ~/.local/share/psi+
whitelist ~/.local/share/psi+

caps.drop all
netfilter
noroot
protocol unix,inet,inet6
seccomp

include /etc/firejail/whitelist-common.inc
