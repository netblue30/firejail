# Firejail profile for fritzing
# Description: Easy-to-use electronic design software
# This file is overwritten after every install/update
# Persistent local customizations
include Fritzing.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Fritzing
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
ipc-namespace
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

private-dev
private-tmp

