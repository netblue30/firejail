# Firejail profile for teamspeak3
# Description: TeamSpeak is software for quality voice communication via the Internet
# This file is overwritten after every install/update
# Persistent local customizations
include teamspeak3.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.ts3client
noblacklist ${PATH}/openssl

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.ts3client
whitelist ${DOWNLOADS}
whitelist ${HOME}/.ts3client
include whitelist-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp !chroot

disable-mnt
private-dev
private-tmp

#restrict-namespaces
