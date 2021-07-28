# Firejail profile for polari
# Description: Internet Relay Chat (IRC) client
# This file is overwritten after every install/update
# Persistent local customizations
include polari.local
# Persistent global definitions
include globals.local

# Allow gjs (blacklisted by disable-interpreters.inc)
include allow-gjs.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/telepathy
mkdir ${HOME}/.config/telepathy-account-widgets
mkdir ${HOME}/.local/share/Empathy
mkdir ${HOME}/.local/share/TpLogger
mkdir ${HOME}/.local/share/telepathy
mkdir ${HOME}/.purple
whitelist ${HOME}/.cache/telepathy
whitelist ${HOME}/.config/telepathy-account-widgets
whitelist ${HOME}/.local/share/Empathy
whitelist ${HOME}/.local/share/TpLogger
whitelist ${HOME}/.local/share/telepathy
whitelist ${HOME}/.purple
include whitelist-common.inc
include whitelist-runuser-common.inc

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
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-dev
private-tmp

