# Firejail profile for aosp
# This file is overwritten after every install/update
# Persistent local customizations
include aosp.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.android
noblacklist ${HOME}/.bash_history
noblacklist ${HOME}/.jack-server
noblacklist ${HOME}/.jack-settings
noblacklist ${HOME}/.repo_.gitconfig.json
noblacklist ${HOME}/.repoconfig
noblacklist ${HOME}/.ssh
noblacklist ${HOME}/.tooling

# Allows files commonly used by IDEs
include allow-common-devel.inc

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

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
