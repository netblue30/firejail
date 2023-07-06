# Firejail profile for shortwave
# Description: Listen to internet radio
# This file is overwritten after every install/update
# Persistent local customizations
include shortwave.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/Shortwave
noblacklist ${HOME}/.local/share/Shortwave

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/Shortwave
mkdir ${HOME}/.local/share/Shortwave
whitelist ${HOME}/.cache/Shortwave
whitelist ${HOME}/.local/share/Shortwave
whitelist /usr/share/shortwave
include whitelist-common.inc
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
novideo
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-bin shortwave
private-cache
private-dev
private-etc @tls-ca,@x11,gconf,host.conf,mime.types
private-tmp

restrict-namespaces
