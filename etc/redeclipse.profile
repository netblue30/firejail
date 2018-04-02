# Firejail profile for redeclipse
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/redeclipse.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.redeclipse

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.redeclipse
whitelist ${HOME}/.redeclipse
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
