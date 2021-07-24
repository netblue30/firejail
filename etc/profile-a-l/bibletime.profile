# Firejail profile for bibletime
# Description: Bible study tool
# This file is overwritten after every install/update
# Persistent local customizations
include bibletime.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.bibletime
nodeny  ${HOME}/.sword
nodeny  ${HOME}/.local/share/bibletime

deny  ${HOME}/.bashrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.bibletime
mkdir ${HOME}/.sword
mkdir ${HOME}/.local/share/bibletime
allow  ${HOME}/.bibletime
allow  ${HOME}/.sword
allow  ${HOME}/.local/share/bibletime
allow  /usr/share/bibletime
allow  /usr/share/doc/bibletime
allow  /usr/share/sword
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
