# Firejail profile for deluge
# Description: BitTorrent client written in Python/PyGTK
# This file is overwritten after every install/update
# Persistent local customizations
include deluge.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/deluge

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include disable-common.inc
# include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/deluge
whitelist  ${DOWNLOADS}
whitelist ${HOME}/.config/deluge
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
netfilter
nodvd
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

# deluge is using python on Debian
private-bin deluge,deluge-console,deluged,deluge-gtk,deluge-web,sh,python*,uname
private-dev
private-tmp
