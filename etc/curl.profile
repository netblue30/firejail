# Firejail profile for curl
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/curl.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

noblacklist ${HOME}/.curlrc

include /etc/firejail/disable-common.inc
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

# private-bin curl
private-dev
# private-etc resolv.conf
private-tmp

noexec ${HOME}
noexec /tmp
