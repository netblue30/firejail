# Firejail profile for linphone
# Description: SIP softphone - graphical client
# This file is overwritten after every install/update
# Persistent local customizations
include linphone.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/linphone
noblacklist ${HOME}/.linphone-history.db
noblacklist ${HOME}/.linphonerc
noblacklist ${HOME}/.local/share/linphone

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

# linphone 4.0 (released 2017-06-26) moved config and database files to respect
# freedesktop standards. For backward compatibility we continue to whitelist
# ${HOME}/.linphone-history.db and ${HOME}/.linphonerc but no longer mkfile.
mkdir ${HOME}/.config/linphone
mkdir ${HOME}/.local/share/linphone
whitelist ${HOME}/.config/linphone
whitelist ${HOME}/.linphone-history.db
whitelist ${HOME}/.linphonerc
whitelist ${HOME}/.local/share/linphone
whitelist ${DOWNLOADS}
include whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

disable-mnt
private-dev
private-tmp

restrict-namespaces
