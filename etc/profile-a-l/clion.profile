# Firejail profile for CLion
# This file is overwritten after every install/update
# Persistent local customizations
include clion.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/git
nodeny  ${HOME}/.gitconfig
nodeny  ${HOME}/.git-credentials
nodeny  ${HOME}/.java
nodeny  ${HOME}/.local/share/JetBrains

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
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
