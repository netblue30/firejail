# Firejail profile for ne
# Description: ne text editor
# This file is overwritten after every install/update
# Persistent local customizations
include ne.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.ne

# Allows files commonly used by IDEs
include allow-common-devel.inc

include disable-common.inc
include disable-programs.inc

include whitelist-runuser-common.inc

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

private-dev

restrict-namespaces
