# Firejail profile for redeclipse
# Description: Free, casual arena shooter
# This file is overwritten after every install/update
# Persistent local customizations
include redeclipse.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.redeclipse

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.redeclipse
whitelist ${HOME}/.redeclipse
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
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

disable-mnt
private-dev
private-tmp

