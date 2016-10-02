# feh image viewer profile
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

private-bin feh
whitelist /tmp/.X11-unix
private-dev
private-etc feh
