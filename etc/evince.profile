# evince pdf reader profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nonewprivs
nogroups
noroot
nosound
protocol unix
seccomp

shell none
private-bin evince,evince-previewer,evince-thumbnailer
whitelist /tmp/.X11-unix
private-dev
