# Firejail profile for falkon
# Description: Lightweight web browser based on Qt WebEngine
# This file is overwritten after every install/update
# Persistent local customizations
include falkon.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/falkon
noblacklist ${HOME}/.config/falkon

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/falkon
mkdir ${HOME}/.config/falkon
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/falkon
whitelist ${HOME}/.config/falkon
whitelist /usr/share/falkon
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
# blacklisting of chroot system calls breaks falkon
seccomp !chroot
#tracelog

disable-mnt
#private-bin falkon
private-cache
private-dev
private-etc @tls-ca,@x11,adobe,mailcap,mime.types
private-tmp

#dbus-user filter
#dbus-user.own org.kde.Falkon
dbus-system none

#restrict-namespaces
