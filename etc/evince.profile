# evince pdf reader profile
noblacklist ~/.config/evince

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
#net none - creates some problems on some distributions
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

private-bin evince,evince-previewer,evince-thumbnailer
private-dev
private-etc fonts
# evince needs access to /tmp/mozilla* to work in firefox
# private-tmp
