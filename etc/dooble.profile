# Firejail profile for dooble
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dooble-qt4.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist ${HOME}/.dooble

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.dooble
whitelist ${DOWNLOADS}
whitelist ${HOME}/.dooble
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
