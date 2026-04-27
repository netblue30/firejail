# Firejail profile for gemini
# Description: An open-source AI agent that brings the power of Gemini directly into your terminal
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gemini.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.gemini

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
# whitelist ${HOME}/.gemini
# whitelist ${HOME}/.config/git
# whitelist ${HOME}/.gitconfig

# Add the following lines to gemini.local to enable whitelisting in `${HOME}`.
#whitelist ${HOME}/.config/git
#whitelist ${HOME}/.gemini
#whitelist ${HOME}/.git-credential-cache
#whitelist ${HOME}/.git-credentials
#whitelist ${HOME}/.gitconfig
#include whitelist-common.inc
#include whitelist-run-common.inc
#include whitelist-runuser-common.inc
#include whitelist-usr-share-common.inc
#include whitelist-var-common.inc

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
