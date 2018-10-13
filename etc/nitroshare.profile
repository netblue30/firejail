# Firejail profile for nitroshare
# Description: Network File Transfer Application
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/nitroshare.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Nathan Osman
noblacklist ${HOME}/.config/NitroShare

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
no3d
# nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-bin awk,grep,nitroshare,nitroshare-cli,nitroshare-nmh,nitroshare-send,nitroshare-ui
private-cache
private-dev
private-etc ca-certificates,dconf,fonts,hostname,hosts,ld.so.cache,machine-id,nsswitch.conf,ssl
# private-lib libnitroshare.so.*,libqhttpengine.so.*,libqmdnsengine.so.*,nitroshare
private-tmp

# memory-deny-write-execute
noexec ${HOME}
noexec /tmp
