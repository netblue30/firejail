# Firejail profile for xlinks
# Description: Text WWW browser (X11)
# This file is overwritten after every install/update
# Persistent local customizations
include xlinks.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.links

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# you may want to noblacklist files/directories blacklisted in
# disable-programs.inc and used as associated programs
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.links
whitelist ${HOME}/.links
whitelist ${DOWNLOADS}
include whitelist-var-common.inc

caps.drop all
ipc-namespace
# comment machine-id (or put 'ignore machine-id' in your links.local) if you want
# to allow access only to user-configured associated media player
machine-id
netfilter
# comment no3d (or put 'ignore no3d' in your links.local) if you want
# to allow access only to user-configured associated media player
no3d
nodvd
nogroups
nonewprivs
noroot
# comment nosound (or put 'ignore nosound' in your links.local) if you want
# to allow access only to user-configured associated media player
nosound
notv
nou2f
# uncomment novideo if you want to allow access only to user-configured
# associated video player
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
# if you want to use user-configured programs add 'private-bin PROGRAM1,PROGRAM2' to your links.local
# or append 'PROGRAM1,PROGRAM2' to this private-bin line
private-bin xlinks,sh
private-cache
private-dev
private-tmp

memory-deny-write-execute
