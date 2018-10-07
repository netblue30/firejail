# Firejail profile for teamspeak3
# Description: TeamSpeak is software for quality voice communication via the Internet
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/teamspeak3.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.ts3client
noblacklist ${PATH}/openssl

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.ts3client
whitelist ${DOWNLOADS}
whitelist ${HOME}/.ts3client
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
