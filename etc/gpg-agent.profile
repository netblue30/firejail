# Firejail profile for gpg-agent
# Description: GNU privacy guard - cryptographic agent
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gpg-agent.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

noblacklist ${HOME}/.gnupg

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

# private-bin gpg-agent,gpg
private-cache
private-dev
