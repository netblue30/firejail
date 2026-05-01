# Firejail profile for pi
# Description: AI agent toolkit: coding agent CLI, unified LLM API, TUI & web UI libraries, Slack bot, vLLM pods
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include pi.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.agents
noblacklist ${HOME}/.pi

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

# Add the following lines to pi.local to enable whitelisting in `${HOME}`.
#mkdir ${HOME}/.agents
#mkdir ${HOME}/.pi
#whitelist ${HOME}/.agents
#whitelist ${HOME}/.config/git
#whitelist ${HOME}/.gitconfig
#whitelist ${HOME}/.pi
#include whitelist-common.inc

whitelist ${RUNUSER}/openssh_agent
include whitelist-run-common.inc
#include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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

dbus-user none
dbus-system none

restrict-namespaces
