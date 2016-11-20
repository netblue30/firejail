# kate profile
noblacklist ~/.local/share/kate
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
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
netfilter
shell none
tracelog

# private-bin kate
private-tmp
private-dev
# private-etc fonts
