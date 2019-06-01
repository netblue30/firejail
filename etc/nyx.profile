# Firejail profile for nyx
# Description: Command-line status monitor for tor
# This file is overwritten after every install/update
# Persistent local customizations
include nyx.local
# Persistent global definitions
include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

noblacklist ${HOME}/.nyx
mkdir ${HOME}/.nyx
whitelist ${HOME}/.nyx

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin nyx,python*
private-cache
private-dev
private-etc alternatives,passwd,tor,fonts
private-opt none
private-srv none
private-tmp

