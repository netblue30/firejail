# Firejail profile for sinal-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/signal-desktop.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/Signal

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.config/Signal
whitelist ${DOWNLOADS}
whitelist ~/.config/Signal
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
