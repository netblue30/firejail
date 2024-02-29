# Firejail profile for Ledger Live desktop app
# Description: Cryptocurrency wallet by the makers of Ledger hardware wallets
# This file is overwritten after every install/update
# Persistent local customizations
include ledger-live-desktop.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Ledger Live

# Added by disable-exec.inc, breaks hardware wallet manager
ignore noexec /tmp

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/Ledger Live
whitelist ${HOME}/.config/Ledger Live
whitelist ${DOWNLOADS}
whitelist /opt/ledger-live
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
nodvd
nogroups
nonewprivs
noprinters
noroot
nosound
notv
novideo
protocol unix,inet,inet6,netlink
seccomp !chroot
tracelog

disable-mnt
private-cache
# enabling private-dev blocks USB hardware wallets, if you don't need access to
# USB devices you can add private-dev to your ledger-live-desktop.local
#private-dev
private-etc @network,@tls-ca,@x11,host.conf,rpc
private-lib
private-tmp

# app attempts to connect to dbus but seems to work fine when blocked
dbus-user none
dbus-system none
