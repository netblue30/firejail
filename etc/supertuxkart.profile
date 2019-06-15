# Firejail profile for supertuxkart
# Description: Free kart racing game.
# This file is overwritten after every install/update
# Persistent local customizations
include supertuxkart.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/supertuxkart
noblacklist ${HOME}/.cache/supertuxkart
noblacklist ${HOME}/.local/share/supertuxkart

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc
include disable-interpreters.inc

mkdir ${HOME}/.config/supertuxkart
mkdir ${HOME}/.cache/supertuxkart
mkdir ${HOME}/.local/share/supertuxkart
whitelist ${HOME}/.config/supertuxkart
whitelist ${HOME}/.cache/supertuxkart
whitelist ${HOME}/.local/share/supertuxkart
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin supertuxkart
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,drirc,hosts,machine-id,openal,pki,resolv.conf,selinux,ssl,system-fips,xdg
private-tmp
private-opt none
private-srv none

