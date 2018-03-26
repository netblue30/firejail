# Firejail profile for caja
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/caja.local
# Persistent global definitions
include /etc/firejail/globals.local

# Caja is started by systemd on most systems. Therefore it is not firejailed by default. Since there
# is already a caja process running on MATE desktops firejail will have no effect.

noblacklist ${HOME}/.local/share/Trash
# noblacklist ${HOME}/.config/caja - disable-programs.inc is disabled, see below
# noblacklist ${HOME}/.local/share/caja-python

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
# include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix
seccomp
shell none
tracelog

# caja needs to be able to start arbitrary applications so we cannot blacklist their files
# private-bin caja
# private-dev
# private-etc fonts
# private-tmp
