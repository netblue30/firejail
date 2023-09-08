# Firejail profile for silentarmy
# This file is overwritten after every install/update
# Persistent local customizations
include silentarmy.local
# Persistent global definitions
include globals.local


include disable-common.inc
#include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-var-common.inc

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

disable-mnt
private
private-bin python*,sa-solver,silentarmy
private-dev
private-opt none
private-tmp

restrict-namespaces
