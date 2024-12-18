# Firejail profile for xreader
# Description: Document viewer for files like PDF and Postscript. X-Apps Project.
# This file is overwritten after every install/update
# Persistent local customizations
include xreader.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/xreader
noblacklist ${HOME}/.config/xreader
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

# Breaks xreader on Mint 18.3
#include whitelist-var-common.inc

#apparmor
caps.drop all
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
tracelog

private-bin xreader,xreader-previewer,xreader-thumbnailer
private-dev
private-etc
private-tmp

memory-deny-write-execute
restrict-namespaces
