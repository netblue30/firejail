# Firejail profile for aweather.
noblacklist ~/.config/aweather
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

# Whitelist
mkdir ~/.config/aweather
whitelist ~/.config/aweather

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin aweather
private-dev
private-tmp
