# Firejail profile for session-messenger
# Description: Encrypted messenger
# This file is overwritten after every install/update
# Persistent local customizations
include session-messenger.local
# Persistent global definitions
include globals.local

blacklist /usr/libexec

noblacklist ${HOME}/.config/Session

ignore noexec /tmp

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/Session
whitelist ${HOME}/.config/Session
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
?HAS_APPIMAGE: ignore noinput
noinput
nonewprivs
noprinters
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp !chroot
seccomp.block-secondary
#tracelog # breaks on Arch

disable-mnt
private-bin sh,tor
private-cache
?HAS_APPIMAGE: ignore private-dev
private-dev
private-etc @network,@tls-ca,@x11
private-lib
private-tmp

dbus-user none
dbus-system none

read-only ${HOME}
read-write ${DOWNLOADS}
read-write ${HOME}/.config/Session
restrict-namespaces
