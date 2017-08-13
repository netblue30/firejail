# Firejail profile for 0ad
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/0ad.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/0ad
noblacklist ~/.config/0ad
noblacklist ~/.local/share/0ad

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/0ad
mkdir ~/.config/0ad
mkdir ~/.local/share/0ad
whitelist ~/.cache/0ad
whitelist ~/.config/0ad
whitelist ~/.local/share/0ad
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
