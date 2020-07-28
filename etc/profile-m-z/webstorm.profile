# Firejail profile for WebStorm
# This file is overwritten after every install/update
# Persistent local customizations
include webstorm.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.WebStorm*
noblacklist ${HOME}/.android
noblacklist ${HOME}/.local/share/JetBrains
noblacklist ${HOME}/.ssh
noblacklist ${HOME}/.tooling

# Allows files commonly used by IDEs
include allow-common-devel.inc

noblacklist ${PATH}/node
noblacklist ${HOME}/.nvm

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
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
private-tmp
