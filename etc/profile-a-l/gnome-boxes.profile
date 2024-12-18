# Firejail profile for gnome-boxes
# Description: Simple GNOME application to access virtual systems
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-boxes.local
# Persistent global definitions
include globals.local

blacklist /usr/libexec

noblacklist ${HOME}/.cache/gnome-boxes
noblacklist ${HOME}/.config/gnome-boxes
noblacklist ${HOME}/.local/share/gnome-boxes
noblacklist ${RUNUSER}/libvirt

noblacklist /sbin
noblacklist /usr/sbin

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
# breaks app
#include disable-proc.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/gnome-boxes
mkdir ${HOME}/.config/gnome-boxes
mkdir ${HOME}/.local/share/gnome-boxes
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/gnome-boxes
whitelist ${HOME}/.config/gnome-boxes
whitelist ${HOME}/.local/share/gnome-boxes
whitelist ${RUNUSER}/libvirt

whitelist /run/libvirt
whitelist /usr/libexec/gnome-boxes*
whitelist /usr/share/gnome-boxes
whitelist /usr/share/libvirt
whitelist /usr/share/osinfo
whitelist /usr/share/qemu
whitelist /usr/share/seabios
whitelist /usr/share/vala*
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

dbus-user filter
dbus-user.own org.gnome.Boxes
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.Notifications
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
dbus-system none

deterministic-shutdown
# breaks app
#restrict-namespaces
