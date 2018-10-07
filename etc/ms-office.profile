# Firejail profile for Microsoft Office Online
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ms-office.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/ms-office-online
noblacklist ${HOME}/.jak

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin bash,fonts,env,jak,ms-office,python*,sh
private-etc resolv.conf,ca-certificates,ssl,pki,crypto-policies
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
