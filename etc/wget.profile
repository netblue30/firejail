# Firejail profile for wget
# Description: Retrieves files from the web
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/wget.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

noblacklist ${HOME}/.wgetrc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

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

# private-bin wget
private-dev
# private-etc resolv.conf,ca-certificates,ssl,pki,crypto-policies
# private-tmp

noexec ${HOME}
noexec /tmp
