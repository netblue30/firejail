# Firejail profile for neovim
# Description: Nvim is open source and freely distributable
# This file is overwritten after every install/update
# Persistent local customizations
include nvim.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.vim
noblacklist ${HOME}/.vimrc
noblacklist ${HOME}/.cache/nvim
noblacklist ${HOME}/.config/nvim
noblacklist ${HOME}/.local/share/nvim

include disable-common.inc
include disable-devel.inc
include disable-programs.inc
include disable-xdg.inc

blacklist ${RUNUSER}

include whitelist-runuser-common.inc

ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
shell none
tracelog
x11 none

private-dev

dbus-user none
dbus-system none

read-only ${HOME}/.config
read-write ${HOME}/.config/nvim
read-write ${HOME}/.local/share/nvim
read-write ${HOME}/.vim
read-write ${HOME}/.vimrc
