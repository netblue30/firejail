# Firejail profile for gnome-builder
# Description: IDE for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-builder.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cargo/config
noblacklist ${HOME}/.cargo/registry
noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credentials
noblacklist ${HOME}/.python-history
noblacklist ${HOME}/.python_history
noblacklist ${HOME}/.pythonhist

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
ipc-namespace
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
shell none

private-cache
private-dev
