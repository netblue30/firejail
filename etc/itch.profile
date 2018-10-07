# Firejail profile for itch
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/itch.local
# Persistent global definitions
include /etc/firejail/globals.local

# itch.io has native firejail/sandboxing support bundled in
# See https://itch.io/docs/itch/using/sandbox/linux.html

noblacklist ${HOME}/.config/itch

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/itch
whitelist ${HOME}/.config/itch
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
private-tmp

noexec /tmp
