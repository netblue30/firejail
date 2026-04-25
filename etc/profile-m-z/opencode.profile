# Firejail profile for opencode
# Description: The open source coding agent
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include opencode.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/opencode
noblacklist ${HOME}/.config/opencode
noblacklist ${HOME}/.local/share/opencode
noblacklist ${HOME}/.local/state/opencode

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

# Allows files commonly used by IDEs
include allow-common-devel.inc

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

blacklist ${RUNUSER}

include disable-common.inc
include disable-proc.inc
include disable-programs.inc
include disable-x11.inc
include disable-xdg.inc

# Uncomment these if you do not want your agent to access your files, you can allow specific dirs in local customizations
# mkdir ${HOME}/.cache/opencode
# mkdir ${HOME}/.config/opencode
# mkdir ${HOME}/.local/share/opencode
# mkdir ${HOME}/.local/state/opencode
# whitelist ${HOME}/.cache/opencode
# whitelist ${HOME}/.config/git
# whitelist ${HOME}/.config/opencode
# whitelist ${HOME}/.gitconfig
# whitelist ${HOME}/.local/share/opencode
# whitelist ${HOME}/.local/state/opencode
# include whitelist-common.inc
# include whitelist-run-common.inc
# include whitelist-runuser-common.inc
# include whitelist-usr-share-common.inc
# include whitelist-var-common.inc

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
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-cache
private-dev
private-etc @network,@tls-ca
private-tmp

dbus-system none
dbus-user none

env NO_BROWSER=true
restrict-namespaces
