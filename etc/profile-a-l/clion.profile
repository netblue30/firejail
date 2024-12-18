# Firejail profile for CLion
# This file is overwritten after every install/update
# Persistent local customizations
include clion.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/JetBrains/CLion*
noblacklist ${HOME}/.cache/JetBrains/CLion*
noblacklist ${HOME}/.clion*
noblacklist ${HOME}/.CLion*
noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credentials
noblacklist ${HOME}/.java
noblacklist ${HOME}/.local/share/JetBrains
noblacklist ${HOME}/.tooling

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

include disable-common.inc
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

private-cache
private-dev
#private-tmp

noexec /tmp
restrict-namespaces
