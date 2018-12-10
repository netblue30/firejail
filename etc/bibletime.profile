# Firejail profile for bibletime
# Description: Bible study tool
# This file is overwritten after every install/update
# Persistent local customizations
include bibletime.local
# Persistent global definitions
include globals.local

blacklist ${HOME}/.bashrc

noblacklist ${HOME}/.bibletime
noblacklist ${HOME}/.sword

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist ${HOME}/.bibletime
whitelist ${HOME}/.sword
include whitelist-common.inc

caps.drop all
machine-id
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
# Breaks bibletime on Fedora and Arch
#seccomp
shell none
# Breaks bibletime on Fedora and Arch
#tracelog

# private-bin bibletime,qt5ct
private-dev
private-etc fonts,resolv.conf,sword,sword.conf,passwd,machine-id,ca-certificates,ssl,pki,crypto-policies
private-tmp
