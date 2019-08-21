# Firejail profile for transmission-daemon
# Description: Fast, easy and free BitTorrent client (daemon)
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-daemon.local
# Persistent global definitions
# added by included profile
#include globals.local

whitelist /var/lib/transmission

caps.keep ipc_lock,net_bind_service,setgid,setuid,sys_chroot

#private-bin transmission-daemon
private-etc alternatives,ca-certificates,crypto-policies,nsswitch.conf,pki,resolv.conf,ssl

read-write /var/lib/transmission
writable-var-log
writable-run-user

# Redirect
include transmission-common.profile
