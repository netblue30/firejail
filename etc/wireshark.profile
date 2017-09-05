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

caps.keep dac_override,net_admin,net_raw
netfilter
no3d
# nogroups - breaks unprivileged wireshark usage
# nonewprivs - breaks unprivileged wireshark usage
# noroot
nodvd
nosound
notv
novideo
# protocol unix,inet,inet6,netlink
# seccomp - breaks unprivileged wireshark usage
shell none
tracelog

# private-bin wireshark
private-dev
# private-etc fonts,group,hosts,machine-id,passwd
private-tmp

noexec ${HOME}
noexec /tmp
