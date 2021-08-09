# Firejail profile for bibletime
# Description: Bible study tool
# This file is overwritten after every install/update
# Persistent local customizations
include bibletime.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.bibletime
noblacklist ${HOME}/.sword
noblacklist ${HOME}/.local/share/bibletime

blacklist ${HOME}/.bashrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.bibletime
mkdir ${HOME}/.sword
mkdir ${HOME}/.local/share/bibletime
whitelist ${HOME}/.bibletime
whitelist ${HOME}/.sword
whitelist ${HOME}/.local/share/bibletime
whitelist /usr/share/bibletime
whitelist /usr/share/doc/bibletime
whitelist /usr/share/sword
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
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
protocol unix,inet,inet6,netlink
seccomp !chroot
shell none

disable-mnt
# private-bin bibletime,qt5ct
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,login.defs,machine-id,passwd,pki,resolv.conf,ssl,sword,sword.conf
private-tmp

dbus-user none
dbus-system none
