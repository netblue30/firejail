# Firejail profile for atom
# Description: A hackable text editor for the 21st Century
# This file is overwritten after every install/update
# Persistent local customizations
include atom.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.atom
noblacklist ${HOME}/.config/Atom
noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.cargo/config
noblacklist ${HOME}/.cargo/registry
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credentials
noblacklist ${HOME}/.pythonrc.py

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.keep sys_admin,sys_chroot
# net none
netfilter
nodbus
nodvd
nogroups
nosound
notv
nou2f
novideo
shell none

private-cache
private-dev
private-tmp
