# Firejail profile for Gitter
noblacklist ~/.config/Gitter

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
noroot
protocol unix,inet,inet6,netlink
seccomp
