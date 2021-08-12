# Firejail profile for nitroshare
# Description: Network File Transfer Application
# This file is overwritten after every install/update
# Persistent local customizations
include nitroshare.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Nathan Osman
noblacklist ${HOME}/.config/NitroShare

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
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
shell none

disable-mnt
private-bin awk,grep,nitroshare,nitroshare-cli,nitroshare-nmh,nitroshare-send,nitroshare-ui
private-cache
private-dev
private-etc alternatives,ca-certificates,dconf,fonts,hostname,hosts,ld.so.cache,machine-id,nsswitch.conf,ssl
# private-lib libnitroshare.so.*,libqhttpengine.so.*,libqmdnsengine.so.*,nitroshare
private-tmp

# dbus-user none
# dbus-system none

# memory-deny-write-execute
