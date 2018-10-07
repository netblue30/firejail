# Firejail profile for kino
# Description: Non-linear editor for Digital Video data
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/kino.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.kino-history
noblacklist ${HOME}/.kinorc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
notv
novideo
protocol unix
seccomp
shell none

private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
