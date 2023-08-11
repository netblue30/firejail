# Firejail profile for onionshare-gui
# Description: Share a file over Tor Hidden Services anonymously and securely
# This file is overwritten after every install/update
# Persistent local customizations
include onionshare-gui.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/onionshare

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

blacklist /sys/class/net

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.config/onionshare
mkdir ${HOME}/OnionShare
whitelist ${HOME}/.config/onionshare
whitelist ${HOME}/OnionShare
whitelist /usr/share/onionshare
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
machine-id
netfilter
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
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
#tracelog # may cause issues, see #1930

disable-mnt
private-bin onionshare,onionshare-cli,onionshare-gui,python*,tor*
private-cache
private-dev
private-tmp

dbus-user filter
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
dbus-system none

memory-deny-write-execute
restrict-namespaces
