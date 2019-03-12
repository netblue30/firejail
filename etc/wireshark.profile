# Firejail profile for wireshark
# Description: Network traffic analyzer
# This file is overwritten after every install/update
# Persistent local customizations
include wireshark.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/wireshark
noblacklist ${HOME}/.wireshark
noblacklist ${DOCUMENTS}

# Wireshark can use Lua for scripting
noblacklist ${PATH}/lua*
noblacklist /usr/lib/lua
noblacklist /usr/include/lua*
noblacklist /usr/share/lua

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

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
nou2f
novideo
# protocol unix,inet,inet6,netlink
# seccomp - breaks network traffic capture for unprivileged users
shell none
tracelog

# private-bin wireshark
private-dev
# private-etc alternatives,fonts,group,hosts,machine-id,passwd,ca-certificates,ssl,pki,crypto-policies
private-tmp

