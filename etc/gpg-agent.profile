# Firejail profile for gpg-agent
# Description: GNU privacy guard - cryptographic agent
# This file is overwritten after every install/update
# Persistent local customizations
include gpg-agent.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.gnupg

blacklist /tmp/.X11-unix

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

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
tracelog

# private-bin gpg-agent,gpg
private-cache
private-dev
