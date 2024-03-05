# Firejail profile for virt-manager
# Description: Manage virtual machines
# This file is overwritten after every install/update
# Persistent local customizations
include virt-manager.local
# Persistent global definitions
include globals.local

blacklist /usr/libexec

noblacklist ${HOME}/.cache/virt-manager
noblacklist ${RUNUSER}/libvirt

noblacklist /sbin
noblacklist /usr/sbin

# Allow python 3 (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
# breaks app
#include disable-proc.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/virt-manager
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/virt-manager
whitelist ${RUNUSER}/libvirt
whitelist /run/libvirt

whitelist /usr/share/libvirt
whitelist /usr/share/osinfo
whitelist /usr/share/qemu
whitelist /usr/share/seabios
whitelist /usr/share/virt-manager
# /usr/share/misc/usb.ids is a symlink to /var/lib/usbutils/usb.ids on Ubuntu 22.04
whitelist /var/lib/usbutils/usb.ids
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# breaks app
#apparmor
# For host-only network sys_admin is needed.
# See https://github.com/netblue30/firejail/issues/2868#issuecomment-518647630
caps.keep net_raw,sys_nice
#caps.keep net_raw,sys_admin
netfilter
nodvd
notv
tracelog

private-cache
private-etc @network,@sound,@tls-ca,@x11
private-tmp
writable-var

dbus-user filter
dbus-user.own org.virt-manager.virt-manager
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.Notifications
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
dbus-system none

# breaks app
#deterministic-shutdown
# breaks app
#restrict-namespaces
