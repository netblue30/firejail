# Firejail profile for kdeinit4
# This file is overwritten after every install/update
# Persistent local customizations
include kdeinit4.local
# Persistent global definitions
include globals.local

# use outside KDE Plasma 4

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nogroups
noinput
nonewprivs
#nosound # disabled for knotify
noroot
nou2f
novideo
notv
protocol unix,inet,inet6,netlink
seccomp

private-bin kbuildsycoca4,kded4,kdeinit4,knotify4
private-dev
private-tmp

restrict-namespaces
