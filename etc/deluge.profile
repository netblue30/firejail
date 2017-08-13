# Firejail profile for deluge
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/deluge.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/deluge

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/deluge
whitelist  ${DOWNLOADS}
whitelist ${HOME}/.config/deluge
include /etc/firejail/whitelist-common.inc

caps.drop all
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
# private-bin deluge,sh,python,uname
private-dev
private-tmp
