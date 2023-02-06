# Firejail profile for quodlibet
# Description: Music player and music library manager
# This file is overwritten after every install/update
# Persistent local customizations
include quodlibet.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/quodlibet
noblacklist ${HOME}/.config/quodlibet
noblacklist ${HOME}/.quodlibet
noblacklist ${MUSIC}

include allow-bin-sh.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/quodlibet
mkdir ${HOME}/.config/quodlibet
mkdir ${HOME}/.quodlibet

whitelist ${HOME}/.cache/quodlibet
whitelist ${HOME}/.config/quodlibet
whitelist ${HOME}/.quodlibet
whitelist ${DOWNLOADS}
whitelist ${MUSIC}
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

private-bin exfalso,operon,python*,quodlibet,sh
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dconf,fonts,gtk-3.0,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,passwd,pki,pulse,resolv.conf,ssl
private-tmp

dbus-system none

restrict-namespaces
