# Firejail profile for elinks
# Description: Text WWW browser (X11)
# This file is overwritten after every install/update
# Persistent local customizations
include xlinks.local
# Persistent global definitions
# include globals.local

noblacklist ${HOME}/.links

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.links
whitelist ${HOME}/.links
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
netfilter
no3d
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
tracelog

disable-mnt
private-cache
private-dev
private-tmp

memory-deny-write-execute
