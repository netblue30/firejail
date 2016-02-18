whitelist ${HOME}/cherrytree
mkdir ~/.config
mkdir ~/.config/cherrytree
whitelist ${HOME}/.config/cherrytree/
mkdir ~/.local
mkdir ~/.local/share
whitelist ${HOME}/.local/share/
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
caps.drop all
seccomp
protocol unix,inet,inet6,netlink
netfilter
tracelog
noroot
include /etc/firejail/whitelist-common.inc
