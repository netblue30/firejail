# Firejail profile for vim
# Description: Vi IMproved - enhanced vi editor
# This file is overwritten after every install/update
# Persistent local customizations
include vim.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.vim
noblacklist ${HOME}/.viminfo
noblacklist ${HOME}/.vimrc

# Allows files commonly used by IDEs
include allow-common-devel.inc

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
