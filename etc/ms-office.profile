# Firejail profile for Microsoft Office Online
# This file is overwritten after every install/update
# Persistent local customizations
include ms-office.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/ms-office-online
noblacklist ${HOME}/.jak

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin bash,fonts,env,jak,ms-office,python*,sh
private-etc alternatives,resolv.conf,ca-certificates,ssl,pki,crypto-policies
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
