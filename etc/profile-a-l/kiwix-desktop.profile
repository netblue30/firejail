# Firejail profile for kiwix-desktop
# Description: view/manage ZIM files
# This file is overwritten after every install/update
# Persistent local customizations
include kiwix-desktop.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/kiwix
noblacklist ${HOME}/.local/share/kiwix-desktop

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/kiwix
mkdir ${HOME}/.local/share/kiwix-desktop
whitelist ${HOME}/.local/share/kiwix
whitelist ${HOME}/.local/share/kiwix-desktop
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
#no3d
nodvd
nogroups
noinput
nonewprivs
noroot
#nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp !chroot

disable-mnt
private-cache
private-dev
private-etc @tls-ca
private-tmp

dbus-user none
dbus-system none

#restrict-namespaces
