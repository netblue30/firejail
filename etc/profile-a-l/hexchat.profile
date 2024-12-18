# Firejail profile for hexchat
# Description: IRC client for X based on X-Chat 2
# This file is overwritten after every install/update
# Persistent local customizations
include hexchat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/hexchat

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/hexchat
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/hexchat
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
#machine-id # breaks sound
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
# If you need Lua and/or Perl support, add the relevant binaries from
# allow-lua.inc/allow-perl.inc to private-bin in your hexchat.local.
private-bin hexchat,python*,sh
private-dev
#private-lib # python problems
private-tmp

dbus-user filter
dbus-user.own org.hexchat.service
dbus-system none

#memory-deny-write-execute # breaks python
restrict-namespaces
