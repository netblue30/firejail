# Firejail profile for linphone
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/linphone.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.linphone-history.db
noblacklist ${HOME}/.linphonerc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkfile ${HOME}/.linphone-history.db
mkfile ${HOME}/.linphonerc
whitelist ${HOME}/.linphone-history.db
whitelist ${HOME}/.linphonerc
whitelist ${HOME}/Downloads
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
