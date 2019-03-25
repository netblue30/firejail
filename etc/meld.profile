# Firejail profile for meld
# Description: Graphical tool to diff and merge files
# This file is overwritten after every install/update
# Persistent local customizations
include meld.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/meld
noblacklist ${PATH}/python*
noblacklist /usr/include/python*
noblacklist /usr/lib/python*
noblacklist /usr/local/lib/python*
noblacklist /usr/share/python*
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.subversion
noblacklist ${HOME}/.ssh

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc

include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
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

private-bin meld,python*,git,svn,hg,bzr,cvs
private-cache
private-dev
# Uncomment the next line if you don't need to compare in /etc.
# private-etc fonts,alternatives,subversion,ca-certificates,ssl,hostname,hosts,resolv.conf,pki,crypto-policies
private-tmp
