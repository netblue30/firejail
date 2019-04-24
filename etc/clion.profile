# Firejail profile for CLion
# This file is overwritten after every install/update
# Persistent local customizations
include clion.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.CLion*
noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credential
noblacklist ${HOME}/.java
noblacklist ${HOME}/.local/share/JetBrains
noblacklist ${HOME}/.ssh
noblacklist ${HOME}/.tooling

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
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

private-cache
private-dev
# private-tmp

noexec /tmp
