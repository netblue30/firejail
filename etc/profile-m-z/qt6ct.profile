# Firejail profile for qt6ct
# Description: Qt6 Configuration Utility
# This file is overwritten after every install/update
# Persistent local customizations
include qt6ct.local
# Persistent global definitions
include globals.local

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/qt6ct
mkdir ${HOME}/.local/share/qt6ct
whitelist ${HOME}/.config/qt6ct
whitelist ${HOME}/.local/share/qt6ct

include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin qt6ct
private-cache
private-dev
private-etc dbus-1,machine-id
private-tmp

dbus-user filter
dbus-user.talk org.freedesktop.portal.Desktop
dbus-user.talk org.freedesktop.portal.Settings
dbus-system none

memory-deny-write-execute
read-only ${HOME}
read-write ${HOME}/.config/qt6ct
read-write ${HOME}/.local/share/qt6ct
restrict-namespaces
