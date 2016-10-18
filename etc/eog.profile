# eog (gnome image viewer) profile

noblacklist ~/.config/eog

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
nogroups
protocol unix
seccomp
shell none

private-bin eog
private-dev
private-etc fonts
private-tmp

