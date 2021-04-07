# Firejail profile for transmission-daemon
# Description: Fast, easy and free BitTorrent client (daemon)
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include transmission-daemon.local
# Persistent global definitions
include globals.local

ignore caps.drop all

mkdir ${HOME}/.config/transmission-daemon
whitelist ${HOME}/.config/transmission-daemon
whitelist /var/lib/transmission

caps.keep ipc_lock,net_bind_service,setgid,setuid,sys_chroot
protocol packet

private-bin transmission-daemon
private-etc alternatives,ca-certificates,crypto-policies,nsswitch.conf,pki,resolv.conf,ssl

read-write /var/lib/transmission
writable-var-log
writable-run-user

# Redirect
include transmission-common.profile
