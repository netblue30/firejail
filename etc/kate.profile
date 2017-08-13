# Firejail profile for kate
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/kate.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/katepartrc
noblacklist ~/.config/katerc
noblacklist ~/.config/kateschemarc
noblacklist ~/.config/katesyntaxhighlightingrc
noblacklist ~/.config/katevirc
noblacklist ~/.local/share/kate

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

# private-bin kate
private-dev
# private-etc fonts
private-tmp
