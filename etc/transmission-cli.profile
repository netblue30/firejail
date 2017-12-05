# Firejail profile for transmission-cli
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/transmission-cli.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/transmission
noblacklist ${HOME}/.config/transmission

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
machine-id
netfilter
nodvd
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

# private-bin transmission-cli
private-dev
private-etc none
private-tmp

memory-deny-write-execute
