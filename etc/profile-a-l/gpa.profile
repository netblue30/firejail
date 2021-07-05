# Firejail profile for gpa
# Description: GNU Privacy Assistant (GPA)
# This file is overwritten after every install/update
# Persistent local customizations
include gpa.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.gnupg

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
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
shell none
tracelog

# private-bin gpa,gpg
private-dev
