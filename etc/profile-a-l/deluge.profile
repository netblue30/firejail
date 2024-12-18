# Firejail profile for deluge
# Description: BitTorrent client written in Python/PyGTK
# This file is overwritten after every install/update
# Persistent local customizations
include deluge.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/deluge

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
#include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.config/deluge
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/deluge
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodvd
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp

# deluge is using python on Debian
private-bin deluge,deluge-console,deluge-gtk,deluge-web,deluged,python*,sh,uname
private-dev
private-tmp

restrict-namespaces
