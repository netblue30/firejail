# Firejail profile for zeal
# Description: Offline API documentation browser
# This file is overwritten after every install/update
# Persistent local customizations
include zeal.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/Zeal
noblacklist ${HOME}/.config/Zeal
noblacklist ${HOME}/.local/share/Zeal

# sh is needed to allow Firefox to open links
include allow-bin-sh.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# The lines below are needed to find the default Firefox profile name, to allow
# opening links in an existing instance of Firefox (note that it still fails if
# there isn't a Firefox instance running with the default profile; see #5352)
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini

mkdir ${HOME}/.cache/Zeal
mkdir ${HOME}/.config/Zeal
mkdir ${HOME}/.local/share/Zeal
whitelist ${HOME}/.cache/Zeal
whitelist ${HOME}/.config/Zeal
whitelist ${HOME}/.local/share/Zeal
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin zeal
private-cache
private-dev
private-etc @tls-ca,@x11,host.conf,mime.types,rpc,services
private-tmp

dbus-user filter
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
# Allow D-Bus communication with Firefox for opening links
dbus-user.talk org.mozilla.*
dbus-system none

#memory-deny-write-execute # breaks on Arch
restrict-namespaces
