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
noblacklist ${PATH}/dumpcap

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/wireshark
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
#caps.drop all
caps.keep dac_override,dac_read_search,net_admin,net_raw
netfilter
no3d
#nogroups # breaks network traffic capture for unprivileged users
noinput
#nonewprivs # breaks network traffic capture for unprivileged users
#noroot
nodvd
nosound
notv
nou2f
novideo
# commented out in case they bring in new protocols
#protocol unix,inet,inet6,netlink,packet,bluetooth
#seccomp
tracelog

#private-bin wireshark
private-cache
# private-dev prevents (some) interfaces from being shown.
# Add the below line to your wirehsark.local if you only want to inspect pcap files.
#private-dev
#private-etc alternatives,ca-certificates,crypto-policies,fonts,group,hosts,machine-id,passwd,pki,resolv.conf,ssl
private-tmp

dbus-user none
dbus-system none

#restrict-namespaces
