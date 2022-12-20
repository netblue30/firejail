# Firejail profile for keepass
# Description: An easy-to-use password manager
# This file is overwritten after every install/update
# Persistent local customizations
include keepass.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/*.kdb
noblacklist ${HOME}/*.kdbx
noblacklist ${HOME}/.config/KeePass
noblacklist ${HOME}/.config/keepass
noblacklist ${HOME}/.keepass
noblacklist ${HOME}/.local/share/KeePass
noblacklist ${HOME}/.local/share/keepass
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6,netlink
seccomp

private-cache
# Note: private-dev prevents the program from seeing new devices (such as
# hardware keys) on /dev after it has already started; add "ignore private-dev"
# to keepassxc.local if this is an issue (see #4883).
private-dev
private-tmp

restrict-namespaces
