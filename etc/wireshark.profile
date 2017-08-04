# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/wireshark.local

# Firejail profile for
noblacklist ${HOME}/.config/wireshark

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

#
# The profile allows users to run wireshark as root
#
#caps.drop all
#noroot
#protocol unix,inet,inet6,netlink

#ipc-namespace
netfilter
no3d
# nogroups - breaks unprivileged wireshark usage
# nonewprivs - breaks unprivileged wireshark usage
nosound
# seccomp - breaks unprivileged wireshark usage
shell none
tracelog

#private-bin wireshark
# private-etc fonts,group,hosts,machine-id,passwd
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
