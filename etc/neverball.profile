# Firejail profile for neverball
# Description: 3D floor-tilting game
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/neverball.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.neverball

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.neverball
whitelist ${HOME}/.neverball
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,netlink
seccomp
shell none

disable-mnt
private-bin neverball
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
