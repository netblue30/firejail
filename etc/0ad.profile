# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/0ad.local

# Firejail profile for 0ad.
noblacklist ~/.cache/0ad
noblacklist ~/.config/0ad
noblacklist ~/.local/share/0ad
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

# Whitelists
mkdir ~/.config/0ad
whitelist ~/.config/0ad

mkdir ~/.local/share/0ad
whitelist ~/.local/share/0ad

mkdir ~/.cache/0ad
whitelist ~/.cache/0ad

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
