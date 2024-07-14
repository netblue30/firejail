# Firejail profile for nhex
# Description: Tauri-based IRC client inspired by HexChat
# This file is overwritten after every install/update
# Persistent local customizations
include nhex.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/nhex
noblacklist ${HOME}/.local/share/dev.nhex

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/nhex
mkdir ${HOME}/.local/share/dev.nhex
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/nhex
whitelist ${HOME}/.local/share/dev.nhex
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
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
private-bin nhex
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
