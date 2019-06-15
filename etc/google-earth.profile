# Firejail profile for google-earth
# This file is overwritten after every install/update
# Persistent local customizations
include google-earth.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Google
noblacklist ${HOME}/.googleearth/Cache/
noblacklist ${HOME}/.googleearth/Temp/
noblacklist ${HOME}/.googleearth/myplaces.backup.kml
noblacklist ${HOME}/.googleearth/myplaces.kml

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/Google
mkdir ${HOME}/.googleearth/Cache/
mkdir ${HOME}/.googleearth/Temp/
mkfile ${HOME}/.googleearth/myplaces.backup.kml
mkfile ${HOME}/.googleearth/myplaces.kml
whitelist ${HOME}/.config/Google
whitelist ${HOME}/.googleearth/Cache/
whitelist ${HOME}/.googleearth/Temp/
whitelist ${HOME}/.googleearth/myplaces.backup.kml
whitelist ${HOME}/.googleearth/myplaces.kml
include whitelist-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin bash,dirname,google-earth,grep,ls,sed,sh
private-dev
private-opt google

