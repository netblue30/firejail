# Firejail profile for wget
# Description: Retrieves files from the web
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include wget.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.wget-hsts
noblacklist ${HOME}/.wgetrc

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
x11 none

# private-bin wget
private-dev
# private-etc alternatives,ca-certificates,crypto-policie,pki,resolv.conf,ssl
# private-tmp

