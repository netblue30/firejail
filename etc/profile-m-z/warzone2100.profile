# Firejail profile for warzone2100
# Description: 3D real time strategy game
# This file is overwritten after every install/update
# Persistent local customizations
include warzone2100.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.warzone2100-3.*
noblacklist ${HOME}/.local/share/warzone2100-3.*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
#include disable-shell.inc - problems on Debian 11

mkdir ${HOME}/.warzone2100-3.1
mkdir ${HOME}/.warzone2100-3.2
whitelist ${HOME}/.local/share/warzone2100-3.3.0 # config dir moved under .local/share
whitelist ${HOME}/.warzone2100-3.1
whitelist ${HOME}/.warzone2100-3.2
whitelist /usr/share/games
whitelist /usr/share/gdm
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
protocol unix,inet,inet6,netlink
seccomp
tracelog

disable-mnt
private-bin bash,dash,sh,warzone2100,which
private-dev
private-etc GUI,GAMES
private-tmp

restrict-namespaces
