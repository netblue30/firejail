# Firejail profile for gpredict.

# Noblacklist
noblacklist ~/.config/Gpredict

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
mkdir ~/.config
mkdir ~/.config/Gpredict
whitelist ~/.config/Gpredict
