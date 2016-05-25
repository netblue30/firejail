# Atril profile
noblacklist ~/.config/atril
noblacklist ~/.local/share
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
seccomp
protocol unix,inet,inet6
noroot
tracelog
netfilter
nosound
