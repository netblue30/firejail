# Firejail profile for neovim
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/vim.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/nvim
noblacklist ${HOME}/.local/share/nvim

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp

private-dev
