# Firejail profile for transgui
# Description: Cross-platform Transmission BitTorrent client
# This file is overwritten after every install/update
# Persistent local customizations
include transgui.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/transgui

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/transgui
whitelist ${HOME}/.config/transgui
whitelist ${DOWNLOADS}
whitelist /usr/share/transgui
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
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

private-bin geoiplookup,geoiplookup6,transgui
private-cache
private-dev
private-etc @network,@tls-ca,@x11
private-lib libGeoIP.so*,libX11.so.*,libgdk_pixbuf-2.0.so.*,libgthread-2.0.so.*,libgtk-x11-2.0.so.*
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
