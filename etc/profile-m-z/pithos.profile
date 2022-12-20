# Firejail profile for pithos
# Description: Pandora Radio client for the GNOME desktop
# This file is overwritten after every install/update
# Persistent local customizations
include pithos.local
# Persistent global definitions
include globals.local

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

disable-mnt
private-bin env,pithos,python*
private-dev
private-tmp

restrict-namespaces
