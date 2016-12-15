# lxterminal (LXDE) profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
protocol unix,inet,inet6
seccomp
#noroot - somehow this breaks on Debian Jessie!
