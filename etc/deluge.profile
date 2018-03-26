# Firejail profile for deluge
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/deluge.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/deluge

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/deluge
whitelist  ${DOWNLOADS}
whitelist ${HOME}/.config/deluge
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
machine-id
netfilter
nodvd
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

# deluge is using python on Debian
private-bin deluge,deluge-console,deluged,deluge-gtk,deluge-web,sh,python*,uname
private-dev
private-tmp
