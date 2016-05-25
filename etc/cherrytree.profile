# cherrytree note taking application
noblacklist /usr/bin/python2*
noblacklist /usr/lib/python3*
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

whitelist ${HOME}/cherrytree
mkdir ~/.config
mkdir ~/.config/cherrytree
whitelist ${HOME}/.config/cherrytree/
mkdir ~/.local
mkdir ~/.local/share
whitelist ${HOME}/.local/share/

caps.drop all
seccomp
protocol unix,inet,inet6,netlink
netfilter
tracelog
nonewprivs
noroot
include /etc/firejail/whitelist-common.inc
nosound
