# Firejail profile for itch
# This file is overwritten after every install/update
# Persistent local customizations
include itch.local
# Persistent global definitions
include globals.local

# itch.io has native firejail/sandboxing support bundled in
# See https://itch.io/docs/itch/using/sandbox/linux.html

noblacklist ${HOME}/.itch
noblacklist ${HOME}/.config/itch

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.itch
mkdir ${HOME}/.config/itch
whitelist ${HOME}/.itch
whitelist ${HOME}/.config/itch
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp

private-dev
private-tmp

noexec /tmp
restrict-namespaces
