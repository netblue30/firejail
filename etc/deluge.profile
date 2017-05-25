# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/deluge.local

# deluge bittorrent client profile
noblacklist ${HOME}/.config/deluge

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
# deluge is using python on Debian
#include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

mkdir ${HOME}/.config/deluge
whitelist ${HOME}/.config/deluge
whitelist  ${DOWNLOADS}
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp

shell none
#private-bin deluge,sh,python,uname
private-dev
private-tmp
