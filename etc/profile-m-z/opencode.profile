# Firejail profile for opencode
# Description: The open source coding agent
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include opencode.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/opencode
noblacklist ${HOME}/.cache/opencode
noblacklist ${HOME}/.local/share/opencode
noblacklist ${HOME}/.local/state/opencode

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

# Allows files commonly used by IDEs
include allow-common-devel.inc

blacklist ${RUNUSER}
blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

whitelist ${HOME}/.config/opencode
whitelist ${HOME}/.cache/opencode
whitelist ${HOME}/.local/share/opencode
whitelist ${HOME}/.local/state/opencode

include whitelist-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-cache
private-dev
private-etc
private-tmp

dbus-user none
dbus-system none

env NO_BROWSER=true
restrict-namespaces
