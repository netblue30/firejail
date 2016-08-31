# Firejail profile for 0ad.
noblacklist ~/.cache/0ad
noblacklist ~/.config/0ad
noblacklist ~/.local/share/0ad
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

# Whitelists
mkdir ~/.cache/0ad
whitelist ~/.cache/0ad

mkdir ~/.config/0ad
whitelist ~/.config/0ad

mkdir ~/.local/share/0ad
whitelist ~/.local/share/0ad

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-dev
private-tmp
