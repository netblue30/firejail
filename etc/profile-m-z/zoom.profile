# Firejail profile for zoom
# Description: Video Conferencing and Web Conferencing Service
# This file is overwritten after every install/update
# Persistent local customizations
include zoom.local
# Persistent global definitions
include globals.local

# Disabled until someone reports positive feedback.
ignore apparmor
ignore novideo
ignore dbus-user none
ignore dbus-system none

# nogroups breaks webcam access on non-systemd systems (see #3711).
# If you use such a system, add 'ignore nogroups' to your zoom.local.
#ignore nogroups

nodeny  ${HOME}/.config/zoomus.conf
nodeny  ${HOME}/.zoom

noallow  ${DOWNLOADS}

mkdir ${HOME}/.cache/zoom
mkfile ${HOME}/.config/zoomus.conf
mkdir ${HOME}/.zoom
allow  ${HOME}/.cache/zoom
allow  ${HOME}/.config/zoomus.conf
allow  ${HOME}/.zoom

# Disable for now, see https://github.com/netblue30/firejail/issues/3726
#private-etc alternatives,ca-certificates,crypto-policies,fonts,group,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,machine-id,nsswitch.conf,pki,resolv.conf,ssl

# Redirect
include electron.profile
