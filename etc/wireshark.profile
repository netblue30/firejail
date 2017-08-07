# Firejail profile for wireshark
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/wireshark.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/wireshark

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

netfilter
no3d
nosound
shell none
tracelog

# private-bin wireshark
private-dev
# private-etc fonts,group,hosts,machine-id,passwd
private-tmp

noexec ${HOME}
noexec /tmp

# CLOBBERED COMMENTS
# caps.drop all
# nogroups - breaks unprivileged wireshark usage
# nonewprivs - breaks unprivileged wireshark usage
# noroot
# protocol unix,inet,inet6,netlink
# seccomp - breaks unprivileged wireshark usage
