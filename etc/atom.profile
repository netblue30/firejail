# Firejail profile for atom
# Description: A hackable text editor for the 21st Century
# This file is overwritten after every install/update
# Persistent local customizations
include atom.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.atom
noblacklist ${HOME}/.config/Atom
# allow rust
noblacklist ${HOME}/.cargo/config
noblacklist ${HOME}/.cargo/registry
# allow git config files
noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credentials
# allow python dev files
noblacklist ${HOME}/.python-history
noblacklist ${HOME}/.python_history
noblacklist ${HOME}/.pythonhist

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
# net none
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-cache
private-dev
private-tmp
