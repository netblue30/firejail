# Firejail profile for linphone
# Description: SIP softphone - graphical client
# This file is overwritten after every install/update
# Persistent local customizations
include linphone.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.linphone-history.db
noblacklist ${HOME}/.linphonerc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkfile ${HOME}/.linphone-history.db
mkfile ${HOME}/.linphonerc
whitelist ${HOME}/.linphone-history.db
whitelist ${HOME}/.linphonerc
whitelist ${DOWNLOADS}
include whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
private-tmp

