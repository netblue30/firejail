# Firejail profile for singularity
# Description: Simulation game about playing as an artificial intelligence
# This file is overwritten after every install/update
# Persistent local customizations
include singularity.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/singularity
noblacklist ${HOME}/.local/share/singularity

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/singularity
mkdir ${HOME}/.local/share/singularity
whitelist ${HOME}/.config/singularity
whitelist ${HOME}/.local/share/singularity
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
net none
#no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
#nosound
notv
nou2f
novideo
seccomp
seccomp.block-secondary
tracelog

disable-mnt
#private-bin dirname,git,python*,singularity,sh
private-cache
private-dev
private-etc @games,@x11
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
