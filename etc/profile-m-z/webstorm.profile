# Firejail profile for WebStorm
# This file is overwritten after every install/update
# Persistent local customizations
include webstorm.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.WebStorm*
nodeny  ${HOME}/.android
nodeny  ${HOME}/.local/share/JetBrains
nodeny  ${HOME}/.tooling
# Allow KDE file manager to open with log directories (blacklisted by disable-programs.inc)
nodeny  ${HOME}/.config/dolphinrc

# Allows files commonly used by IDEs
include allow-common-devel.inc

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

nodeny  ${PATH}/node
nodeny  ${HOME}/.nvm

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
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
private-tmp
