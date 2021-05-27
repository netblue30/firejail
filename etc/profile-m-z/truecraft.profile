# Firejail profile for truecraft
# This file is overwritten after every install/update
# Persistent local customizations
include truecraft.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mono
noblacklist ${HOME}/.config/truecraft

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/mono
mkdir ${HOME}/.config/truecraft
whitelist ${HOME}/.config/mono
whitelist ${HOME}/.config/truecraft
include whitelist-common.inc

caps.drop all
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-dev
private-tmp

