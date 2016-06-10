# HexChat instant messaging profile
noblacklist ${HOME}/.config/hexchat
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
nonewprivs
noroot
netfilter
protocol unix,inet,inet6
seccomp

mkdir ~/.config
mkdir ~/.config/hexchat
whitelist ~/.config/hexchat
include /etc/firejail/whitelist-common.inc

# private-bin requires perl, python, etc.
