# Firejail profile for Psi+

noblacklist ${HOME}/.config/psi+
noblacklist ${HOME}/.local/share/psi+
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

whitelist ${DOWNLOADS}
mkdir ~/.config
mkdir ~/.config/psi+
whitelist ~/.config/psi+
mkdir ~/.local
mkdir ~/.local/share
mkdir ~/.local/share/psi+
whitelist ~/.local/share/psi+
mkdir ~/.cache
mkdir ~/.cache/psi+
whitelist ~/.cache/psi+

include /etc/firejail/whitelist-common.inc

caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
noroot
