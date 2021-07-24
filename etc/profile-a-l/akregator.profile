# Firejail profile for akregator
# Description: RSS/Atom feed aggregator
# This file is overwritten after every install/update
# Persistent local customizations
include akregator.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/akregatorrc
nodeny  ${HOME}/.local/share/akregator
nodeny  ${HOME}/.local/share/kxmlgui5/akregator

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

mkfile ${HOME}/.config/akregatorrc
mkdir ${HOME}/.local/share/akregator
mkdir ${HOME}/.local/share/kxmlgui5/akregator
allow  ${HOME}/.config/akregatorrc
allow  ${HOME}/.local/share/akregator
allow  ${HOME}/.local/share/kssl
allow  ${HOME}/.local/share/kxmlgui5/akregator
include whitelist-common.inc
include whitelist-var-common.inc

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
protocol unix,inet,inet6,netlink
# chroot syscalls are needed for setting up the built-in sandbox
seccomp !chroot
shell none

disable-mnt
private-bin akregator,akregatorstorageexporter,dbus-launch,kdeinit4,kdeinit4_shutdown,kdeinit4_wrapper,kdeinit5,kdeinit5_shutdown,kdeinit5_wrapper,kshell4,kshell5
private-dev
private-tmp

