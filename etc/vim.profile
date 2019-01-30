# Firejail profile for vim
# Description: Vi IMproved - enhanced vi editor
# This file is overwritten after every install/update
# Persistent local customizations
include vim.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.python-history
noblacklist ${HOME}/.vim
noblacklist ${HOME}/.viminfo
noblacklist ${HOME}/.vimrc

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

private-dev
