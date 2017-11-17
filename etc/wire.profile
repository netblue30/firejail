# Firejail profile for wire
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/wire.local
# Persistent global definitions
include /etc/firejail/globals.local

# Note: the current beta version of wire is located in /opt/Wire/wire and therefore not in PATH.
# To use wire with firejail run "firejail /opt/Wire/wire"

noblacklist ${HOME}/.config/Wire
noblacklist ${HOME}/.config/wire

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-dev
private-tmp
