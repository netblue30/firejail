# Firejail profile for google-earth
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/google-earth.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Google
noblacklist ${HOME}/.googleearth/Cache/
noblacklist ${HOME}/.googleearth/Temp/
noblacklist ${HOME}/.googleearth/myplaces.backup.kml
noblacklist ${HOME}/.googleearth/myplaces.kml

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

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
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-bin google-earth,sh,bash,grep,sed,ls,dirname
private-dev

noexec ${HOME}
noexec /tmp
