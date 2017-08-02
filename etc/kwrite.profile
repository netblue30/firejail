# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/kwrite.local

# kate profile
noblacklist ~/.local/share/kwrite
noblacklist ~/.config/katerc
noblacklist ~/.config/katepartrc
noblacklist ~/.config/kateschemarc
noblacklist ~/.config/katesyntaxhighlightingrc
noblacklist ~/.config/katevirc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
#include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
#nosound - KWrite is using ALSA!
protocol unix
seccomp
shell none
tracelog

# private-bin kwrite
private-tmp
private-dev
# private-etc fonts
