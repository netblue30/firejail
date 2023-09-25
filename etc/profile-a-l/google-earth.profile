# Firejail profile for google-earth
# This file is overwritten after every install/update
# Persistent local customizations
include google-earth.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Google
noblacklist ${HOME}/.googleearth

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.config/Google
mkdir ${HOME}/.googleearth
whitelist ${HOME}/.config/Google
whitelist ${HOME}/.googleearth
whitelist /opt/google
include whitelist-common.inc

caps.drop all
ipc-namespace
netfilter
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

disable-mnt
private-bin bash,dirname,google-earth,grep,ls,sed,sh
private-dev

restrict-namespaces
