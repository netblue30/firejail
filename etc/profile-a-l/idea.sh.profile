# Firejail profile for idea.sh
# This file is overwritten after every install/update
# Persistent local customizations
include idea.sh.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.IdeaIC*
noblacklist ${HOME}/.android
noblacklist ${HOME}/.jack-server
noblacklist ${HOME}/.jack-settings
noblacklist ${HOME}/.local/share/JetBrains
noblacklist ${HOME}/.tooling

# Allows files commonly used by IDEs
include allow-common-devel.inc

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
