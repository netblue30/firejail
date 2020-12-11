# Firejail profile for zoom
# Description: Video Conferencing and Web Conferencing Service
# This file is overwritten after every install/update
# Persistent local customizations
include zoom.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore apparmor
ignore nogroups
ignore novideo
ignore dbus-user none
ignore dbus-system none

noblacklist ${HOME}/.config/zoomus.conf
noblacklist ${HOME}/.zoom

nowhitelist ${DOWNLOADS}

mkdir ${HOME}/.cache/zoom
mkfile ${HOME}/.config/zoomus.conf
mkdir ${HOME}/.zoom
whitelist ${HOME}/.cache/zoom
whitelist ${HOME}/.config/zoomus.conf
whitelist ${HOME}/.zoom

#nogroups - breaks webcam access (see #3711)

# Disable for now, see https://github.com/netblue30/firejail/issues/3726
#private-etc alternatives,ca-certificates,crypto-policies,fonts,group,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,machine-id,nsswitch.conf,pki,resolv.conf,ssl

# Redirect
include electron.profile
