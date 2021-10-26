# Firejail profile for electron-mail
# Description: Unofficial desktop app for several E2E encrypted email providers
# This file is overwritten after every install/update
# Persistent local customizations
include electron-mail.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/electron-mail

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/electron-mail
whitelist ${HOME}/.config/electron-mail
whitelist ${DOWNLOADS}

include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp !chroot
shell none
# tracelog - breaks on Arch

private-bin electron-mail
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,nsswitch.conf,pki,resolv.conf,selinux,ssl,xdg
private-opt ElectronMail
private-tmp

# breaks tray functionality
# dbus-user none
dbus-system none

# memory-deny-write-execute - breaks on Arch
