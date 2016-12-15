# Firejail profile for Stellarium.
noblacklist ~/.stellarium
noblacklist ~/.config/stellarium
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

# Whitelist
mkdir ~/.stellarium
whitelist ~/.stellarium
mkdir ~/.config/stellarium
whitelist ~/.config/stellarium

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-bin stellarium
private-dev
private-tmp
