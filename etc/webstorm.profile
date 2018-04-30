# Firejail profile for WebStorm
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/webstorm.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.WebStorm*
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.java
noblacklist ${HOME}/.local/share/JetBrains
noblacklist ${HOME}/.ssh
noblacklist ${HOME}/.tooling

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
# private-tmp

noexec /tmp
