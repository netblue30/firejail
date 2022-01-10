# Firejail profile for neovim
# Description: Nvim is open source and freely distributable
# Persistent local customizations
include nvim.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.vim
noblacklist ${HOME}/.cache/nvim
noblacklist ${HOME}/.local/share/nvim

include disable-common.inc
include disable-devel.inc
include disable-programs.inc
include disable-xdg.inc

blacklist ${RUNUSER}/wayland-*
blacklist ${RUNUSER}

include whitelist-runuser-common.inc

ipc-namespace
machine-id
net none
netfilter
no3d
dbus-user none
dbus-system none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp.block-secondary
shell none
tracelog
x11 none

private-dev

read-write ${HOME}/.vim
read-only ${HOME}/.config
