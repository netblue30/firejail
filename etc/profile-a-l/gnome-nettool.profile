# Firejail profile for gnome-nettool
# Description: Graphical interface for various networking tools
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-nettool.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/gnome-nettool
#include whitelist-common.inc # see #903
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.keep net_raw
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
# ping needs to elevate privileges, noroot and nonewprivs will kill it
#nonewprivs
#noroot
nosound
notv
nou2f
novideo
#seccomp

disable-mnt
private
private-cache
private-dev
private-lib libbind9.so.*,libcrypto.so.*,libdns.so.*,libgtk-3.so.*,libgtop*,libirs.so.*,liblua.so.*,libssh2.so.*,libssl.so.*
private-tmp

dbus-user none
dbus-system none

#restrict-namespaces
