# Firejail profile for nylas
# This file is overwritten after every install/update
# Persistent local customizations
include nylas.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Nylas Mail
noblacklist ${HOME}/.nylas-mail

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/Nylas Mail
mkdir ${HOME}/.nylas-mail
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/Nylas Mail
whitelist ${HOME}/.nylas-mail
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
