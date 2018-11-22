# Firejail profile for feedreader
# Description: RSS client
# This file is overwritten after every install/update
# Persistent local customizations
include feedreader.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/feedreader
noblacklist ${HOME}/.local/share/feedreader

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/feedreader
mkdir ${HOME}/.local/share/feedreader
whitelist ${HOME}/.cache/feedreader
whitelist ${HOME}/.local/share/feedreader
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
# no3d
nodvd
nogroups
nonewprivs
noroot
# nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
