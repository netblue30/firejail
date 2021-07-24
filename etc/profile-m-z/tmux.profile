# Firejail profile for tmux
# Description: terminal multiplexer
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include tmux.local
# Persistent global definitions
include globals.local

deny  /tmp/.X11-unix
deny  ${RUNUSER}

nodeny  /tmp/tmux-*

# include disable-common.inc
# include disable-devel.inc
# include disable-exec.inc
include disable-passwdmgr.inc
# include disable-programs.inc

caps.drop all
ipc-namespace
machine-id
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
novideo
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary
shell none
tracelog

# private-cache
private-dev
# private-tmp

dbus-user none
dbus-system none
