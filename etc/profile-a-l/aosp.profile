# Firejail profile for aosp
# This file is overwritten after every install/update
# Persistent local customizations
include aosp.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.android
nodeny  ${HOME}/.bash_history
nodeny  ${HOME}/.jack-server
nodeny  ${HOME}/.jack-settings
nodeny  ${HOME}/.repo_.gitconfig.json
nodeny  ${HOME}/.repoconfig
nodeny  ${HOME}/.tooling

# Allows files commonly used by IDEs
include allow-common-devel.inc

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

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
