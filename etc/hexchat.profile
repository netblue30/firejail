# HexChat instant messaging profile
# Currently in testing (may not work for all users)
noblacklist ${HOME}/.config/hexchat
#noblacklist /usr/lib/python2*
#noblacklist /usr/lib/python3*
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none
tracelog

mkdir ~/.config/hexchat
whitelist ~/.config/hexchat
include /etc/firejail/whitelist-common.inc

private-bin hexchat
#debug note: private-bin requires perl, python, etc on some systems
private-dev
private-tmp
