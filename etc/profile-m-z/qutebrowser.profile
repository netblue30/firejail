# Firejail profile for qutebrowser
# Description: Keyboard-driven, vim-like browser based on PyQt5
# This file is overwritten after every install/update
# Persistent local customizations
include qutebrowser.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/qutebrowser
noblacklist ${HOME}/.config/qutebrowser
noblacklist ${HOME}/.local/share/qutebrowser

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.cache/qutebrowser
mkdir ${HOME}/.config/qutebrowser
mkdir ${HOME}/.local/share/qutebrowser
mkdir ${RUNUSER}/qutebrowser
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/qutebrowser
whitelist ${HOME}/.config/qutebrowser
whitelist ${HOME}/.local/share/qutebrowser
whitelist /usr/share/qutebrowser
whitelist ${RUNUSER}/qutebrowser
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
# blacklisting of chroot system calls breaks qt webengine
seccomp !chroot,!name_to_handle_at
#tracelog

disable-mnt
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.preload,localtime,machine-id,pki,pulse,resolv.conf,ssl
private-tmp

dbus-user filter
dbus-user.own org.mpris.MediaPlayer2.qutebrowser.*
dbus-user.talk org.freedesktop.Notifications
# Add the next line to your qutebrowser.local to allow screen sharing under wayland.
#dbus-user.talk org.freedesktop.portal.Desktop
# Add the next line to your qutebrowser.local if screen sharing sharing still does not work
# with the above lines (might depend on the portal implementation).
#ignore noroot
dbus-system none

#restrict-namespaces
