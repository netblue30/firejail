# Firejail profile for syncthing
# This file is overwritten after every install/update
# Persistent local customizations
include syncthing.local
# Persistent global definitions
include globals.local

# NOTE: this assumes a ~/Sync directory to be shared.


# Allow python3 (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.local/state/syncthing
noblacklist ${HOME}/.local/state/syncthing
whitelist ${HOME}/.local/state/syncthing

mkdir ${HOME}/Sync
whitelist ${HOME}/Sync

include whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

private-dev
private-tmp

#noexec /tmp
#restrict-namespaces
