# Firejail profile for supertux2
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/supertux2.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.local/share/supertux2

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.local/share/supertux2
whitelist ${HOME}/.local/share/supertux2
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,netlink
seccomp
shell none

disable-mnt
# private-bin supertux2
private-dev
# private-etc none
private-tmp
