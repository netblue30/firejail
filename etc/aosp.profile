# Firejail profile for aosp
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/aosp.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist ${HOME}/.android
noblacklist ${HOME}/.bash_history
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.gradle
noblacklist ${HOME}/.jack-server
noblacklist ${HOME}/.jack-settings
noblacklist ${HOME}/.java
noblacklist ${HOME}/.repo_.gitconfig.json
noblacklist ${HOME}/.repoconfig
noblacklist ${HOME}/.ssh
noblacklist ${HOME}/.tooling

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
#seccomp
shell none

private-tmp
