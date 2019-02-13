# Firejail profile for snap
# Description: Install, configure, refresh and remove snap packages
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include snap.local
# Persistent global definitions
include globals.local

# Note: Snap packages have their own confinement mechanism relying on snapd and apparmor.
# As such firejail is not able to deliver any additional sandboxing for snaps. This profile does sandbox
# the snap tool which is used to interact with snap packages.
# See https://docs.snapcraft.io/ for more detailed info.

noblacklist ${HOME}/.snap
noblacklist ${HOME}/snap
noblacklist ${DOWNLOADS}

noblacklist /var/cache/snapd
noblacklist /var/lib/snapd
noblacklist /var/snap

mkdir ${HOME}/.snap
mkdir ${HOME}/snap
whitelist ${HOME}/.snap
whitelist ${HOME}/snap

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin snap
private-dev
private-etc group,passwd
private-lib snapd
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
