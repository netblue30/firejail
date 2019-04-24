# Firejail profile for meld
# Description: Graphical tool to diff and merge files
# This file is overwritten after every install/update
# Persistent local customizations
include meld.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/meld

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credential
noblacklist ${HOME}/.ssh
noblacklist ${HOME}/.subversion

# Uncomment the next line if you don't need to compare files in disable-common.inc.
#include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# Uncomment the next line if you don't need to compare files in disable-programs.inc.
#include disable-programs.inc

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

private-bin bzr,cvs,git,hg,meld,python*,svn
private-cache
private-dev
# Uncomment the next line if you don't need to compare in /etc.
#private-etc alternatives,ca-certificates,crypto-policies,fonts,hostname,hosts,pki,resolv.conf,ssl,subversion
private-tmp

