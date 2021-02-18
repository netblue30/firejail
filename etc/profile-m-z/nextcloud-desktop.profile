# Firejail profile for nextcloud-desktop
# Description: Nextcloud desktop client
# This file is overwritten after every install/update
# Persistent local customizations
include nextcloud-desktop.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
noblacklist ${HOME}/Nextcloud
noblacklist ${HOME}/.config/Nextcloud
noblacklist ${HOME}/.local/share/Nextcloud

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/Nextcloud
mkdir ${HOME}/.config/Nextcloud
mkdir ${HOME}/.local/share/Nextcloud
whitelist ${DOCUMENTS}
whitelist ${HOME}/Nextcloud
whitelist ${HOME}/.config/Nextcloud
whitelist ${HOME}/.local/share/Nextcloud
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

noexec /tmp
