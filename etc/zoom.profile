# Firejail profile for zoom
# This file is overwritten after every install/update
# Persistent local customizations
include zoom.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/zoomus.conf
noblacklist ${HOME}/.zoom

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/zoom
mkfile ${HOME}/.config/zoomus.conf
mkdir ${HOME}/.zoom
whitelist ${HOME}/.cache/zoom
whitelist ${HOME}/.config/zoomus.conf
whitelist ${HOME}/.zoom
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

private-tmp
