# Firejail profile for 0ad.
noblacklist ~/.config/0ad
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

# Call these options
caps.drop all
seccomp
protocol unix,inet,inet6,netlink
netfilter
tracelog
noroot
nonewprivs

# Whitelists
noblacklist ~/.cache/0ad
mkdir ~/.cache
mkdir ~/.cache/0ad
whitelist ~/.cache/0ad

mkdir ~/.config
mkdir ~/.config/0ad
whitelist ~/.config/0ad

noblacklist ~/.local/share/0ad
mkdir ~/.local
mkdir ~/.local/share
mkdir ~/.local/share/0ad
whitelist ~/.local/share/0ad
