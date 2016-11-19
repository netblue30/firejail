# wire messenger profile
noblacklist ~/.config/Wire
noblacklist ~/.config/wire

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
nogroups
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none

private-tmp
private-dev

# Note: the current beta version of wire is located in /opt/Wire/wire and therefore not in PATH.
# To use wire with firejail run "firejail /opt/Wire/wire" 
