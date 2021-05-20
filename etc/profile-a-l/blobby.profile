# Firejail profile for blobby
# Persistent local customizations
include blobby.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.blobby

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.blobby
whitelist ${HOME}/.blobby
include whitelist-common.inc
whitelist /usr/share/blobby
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,netlink,
netfilter
seccomp
shell none
tracelog

disable-mnt
private-bin blobby,
private-lib
private-dev
private-etc hosts,group,asound.conf,alsa,machine-id,pulse,drirc,login.defs,passwd,
private-tmp

dbus-user none
dbus-system none
memory-deny-write-execute
