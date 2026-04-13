# Firejail profile for pi
# Description: AI agent toolkit: coding agent CLI, unified LLM API, TUI & web UI libraries, Slack bot, vLLM pods
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include pi.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.pi

# Allows files commonly used by IDEs
include allow-common-devel.inc

blacklist ${RUNUSER}

include disable-common.inc
include disable-proc.inc
include disable-programs.inc
include disable-x11.inc
include disable-xdg.inc

mkdir ${HOME}/.agents
mkdir ${HOME}/.config/git
mkdir ${HOME}/.pi
mkfile ${HOME}/.gitconfig
whitelist ${HOME}/.agents
whitelist ${HOME}/.config/git
whitelist ${HOME}/.gitconfig
whitelist ${HOME}/.pi
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
private-tmp

dbus-system none
dbus-user none

restrict-namespaces
