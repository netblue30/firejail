# Firejail profile for liferea
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/liferea.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/liferea
noblacklist ~/.config/liferea
noblacklist ~/.local/share/liferea

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/liferea
mkdir ~/.config/liferea
mkdir ~/.local/share/liferea
whitelist ~/.cache/liferea
whitelist ~/.config/liferea
whitelist ~/.local/share/liferea
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
# no3d
nodvd
nogroups
nonewprivs
noroot
# nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
