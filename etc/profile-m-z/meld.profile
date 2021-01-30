# Firejail profile for meld
# Description: Graphical tool to diff and merge files
# This file is overwritten after every install/update
# Persistent local customizations
include meld.local
# Persistent global definitions
include globals.local

# If you want to use meld as git mergetool (and maybe some other VCS integrations) you need
# to bypass firejail, you can do this by removing the symlink or calling it by its absolute path
# Removing the symlink:
#  sudo rm /usr/local/bin/meld
# Calling it by its absolute path (example for git mergetool):
#  git config --global mergetool.meld.cmd /usr/bin/meld

noblacklist ${HOME}/.config/meld
noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credentials
noblacklist ${HOME}/.local/share/meld
noblacklist ${HOME}/.subversion

# Allow python (blacklisted by disable-interpreters.inc)
# Python 2 is EOL (see #3164). Uncomment the next line (or put it into your meld.local) if you understand the risks but want python 2 support for older meld versions.
#include allow-python2.inc
include allow-python3.inc

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

# Uncomment the next line (or put it into your meld.local) if you don't need to compare files in disable-common.inc.
#include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# Uncomment the next line (or put it into your meld.local) if you don't need to compare files in disable-programs.inc.
#include disable-programs.inc
include disable-shell.inc

include whitelist-runuser-common.inc

# Uncomment the next lines (or put it into your meld.local) if you don't need to compare files in /usr/share.
#whitelist /usr/share/meld
#include whitelist-usr-share-common.inc

# Uncomment the next line (or put it into your meld.local) if you don't need to compare files in /var.
#include whitelist-var-common.inc

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
seccomp.block-secondary
shell none
tracelog

private-bin bzr,cvs,git,hg,meld,python*,svn
private-cache
private-dev
# Uncomment the next line (or put it into your meld.local) if you don't need to compare in /etc.
#private-etc alternatives,ca-certificates,crypto-policies,fonts,hostname,hosts,pki,resolv.conf,ssl,subversion
# Comment the next line (or add 'ignore private-tmp to your meld.local') if you want to use it as a difftool (#3551)
private-tmp

read-only ${HOME}/.ssh
