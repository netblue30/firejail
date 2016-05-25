# Firejail profile for Stellarium.

# Noblacklist
noblacklist ~/.stellarium
noblacklist ~/.config/stellarium

# Include
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

# Call these options
caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
tracelog

# Whitelist
mkdir ~/.stellarium
whitelist ~/.stellarium

mkdir ~/.config
mkdir ~/.config/stellarium
whitelist ~/.config/stellarium
