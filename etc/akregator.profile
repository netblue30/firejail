# Firejail profile for akregator
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/akregator.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/akregatorrc
noblacklist ${HOME}/.local/share/akregator

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkfile ${HOME}/.config/akregatorrc
mkdir ${HOME}/.local/share/akregator
whitelist ${HOME}/.config/akregatorrc
whitelist ${HOME}/.local/share/akregator
include /etc/firejail/whitelist-common.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-bin akregator,akregatorstorageexporter,dbus-launch,kdeinit5,kshell5,kdeinit5_shutdown,kdeinit5_wrapper,kdeinit4,kshell4,kdeinit4_shutdown,kdeinit4_wrapper
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
