# display (ImageMagick tool) image viewer profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
seccomp
protocol unix
netfilter
net none
nonewprivs
noroot
nogroups
nosound
shell none
x11 xorg

private-bin display 
private-tmp
private-dev
private-etc none

