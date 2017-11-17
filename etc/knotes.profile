# Firejail profile for knotes
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/knotes.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/knotesrc

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
protocol unix
seccomp
shell none
tracelog

private-dev
#private-tmp - problems on kubuntu 17.04
