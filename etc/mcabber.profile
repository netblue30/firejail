# Firejail profile for mcabber
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mcabber.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.mcabber
noblacklist ${HOME}/.mcabberrc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
nosound
notv
novideo
protocol inet,inet6
seccomp
shell none

private-bin mcabber
private-dev
private-etc null
