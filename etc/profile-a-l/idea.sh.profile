# Firejail profile for idea.sh
# This file is overwritten after every install/update
# Persistent local customizations
include idea.sh.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.IdeaIC*
nodeny  ${HOME}/.android
nodeny  ${HOME}/.jack-server
nodeny  ${HOME}/.jack-settings
nodeny  ${HOME}/.local/share/JetBrains
nodeny  ${HOME}/.tooling

# Allows files commonly used by IDEs
include allow-common-devel.inc

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
