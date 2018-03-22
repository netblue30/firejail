# Firejail profile for smplayer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/smplayer.local
# Persistent global definitions
include /etc/firejail/globals.local

# blacklist /run/user/*/bus
noblacklist ${HOME}/.config/smplayer
noblacklist ${HOME}/.mplayer

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

apparmor
caps.drop all
netfilter
# nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin smplayer,smtube,mplayer,mpv
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
