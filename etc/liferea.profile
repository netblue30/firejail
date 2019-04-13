# Firejail profile for liferea
# Description: Feed/news/podcast client with plugin support
# This file is overwritten after every install/update
# Persistent local customizations
include liferea.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/liferea
noblacklist ${HOME}/.config/liferea
noblacklist ${HOME}/.local/share/liferea

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/liferea
mkdir ${HOME}/.config/liferea
mkdir ${HOME}/.local/share/liferea
whitelist ${HOME}/.cache/liferea
whitelist ${HOME}/.config/liferea
whitelist ${HOME}/.local/share/liferea
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

