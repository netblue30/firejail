# Firejail profile for wireshark
# Description: Network traffic analyzer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/wireshark.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/wireshark
noblacklist ${HOME}/.wireshark
noblacklist ${DOCUMENTS}

# Wireshark can use Lua for scripting
noblacklist ${PATH}/lua*
noblacklist /usr/lib/lua
noblacklist /usr/include/lua*
noblacklist /usr/share/lua

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

apparmor
# caps.drop all
caps.keep dac_override,net_admin,net_raw
netfilter
no3d
# nogroups - breaks network traffic capture for unprivileged users
# nonewprivs - breaks network traffic capture for unprivileged users
# noroot
nodvd
nosound
notv
novideo
# protocol unix,inet,inet6,netlink
# seccomp - breaks network traffic capture for unprivileged users
shell none
tracelog

# private-bin wireshark
private-dev
# private-etc fonts,group,hosts,machine-id,passwd,ca-certificates,ssl,pki,crypto-policies
private-tmp

noexec ${HOME}
noexec /tmp
