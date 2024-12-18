# Firejail profile for gpa
# Description: GNU Privacy Assistant (GPA)
# This file is overwritten after every install/update
# Persistent local customizations
include gpa.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.gnupg

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

#private-bin gpa,gpg
private-dev

restrict-namespaces
