# Firejail profile for aweather.
noblacklist ~/.config/aweather
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

# Whitelist
mkdir ~/.config
mkdir ~/.config/aweather
whitelist ~/.config/aweather

caps.drop all
netfilter
nonewprivs
nogroups
noroot
nosound
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-bin aweather
private-dev
