# Firejail profile for profanity
# Description: profanity is an XMPP-OTR chat client for the terminal
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include unzip.local
# Persistent global definitions
include globals.local

ignore net none

include disable-common.inc
include disable-devel.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/profanity
mkdir ${HOME}/.local/share/profanity
noblacklist ${HOME}/.config/profanity
noblacklist ${HOME}/.local/share/profanity

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none

private-bin profanity
private-cache
private-dev
private-tmp
private-etc alternatives,localtime,mime.types,resolv.conf,ssl

memory-deny-write-execute
noexec ${HOME}
noexec /tmp

