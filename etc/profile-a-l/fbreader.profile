# Firejail profile for fbreader
# Description: E-book reader
# This file is overwritten after every install/update
# Persistent local customizations
include fbreader.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.FBReader
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
net none
nodvd
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

private-bin FBReader,fbreader
private-dev
private-tmp

restrict-namespaces
