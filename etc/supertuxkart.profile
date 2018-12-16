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

apparmor
caps.drop all
ipc-namespace
netfilter
nodbus
noautopulse
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
private-dev
private-etc resolv.conf,ca-certificates,ssl,hosts,machine-id,xdg,openal,crypto-policies,pki,drirc,system-fips,selinux,
private-tmp
private-cache
private-opt none
private-srv none

noexec ${HOME}
noexec /tmp
