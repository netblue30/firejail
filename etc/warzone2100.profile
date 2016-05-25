# Firejail profile for warzone2100
# Currently supports warzone2100-3.1
noblacklist ~/.warzone2100-3.1
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
mkdir ~/.warzone2100-3.1
whitelist ~/.warzone2100-3.1
