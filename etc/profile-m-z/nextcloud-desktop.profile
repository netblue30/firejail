# Firejail profile for nextcloud-desktop
# Description: Nextcloud desktop client
# This file is overwritten after every install/update
# Persistent local customizations
include nextcloud-desktop.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/Nextcloud
noblacklist ${HOME}/.config/Nextcloud
noblacklist ${HOME}/.local/share/Nextcloud
# Uncomment or put in your nextcloud-desktop.local to allow sync with more directories.
#noblacklist ${DOCUMENTS}
#noblacklist ${MUSIC}
#noblacklist ${PICTURES}
#noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/Nextcloud
mkdir ${HOME}/.config/Nextcloud
mkdir ${HOME}/.local/share/Nextcloud
whitelist ${HOME}/Nextcloud
whitelist ${HOME}/.config/Nextcloud
whitelist ${HOME}/.local/share/Nextcloud
# Uncomment or put in your nextcloud-desktop.local to allow sync with more directories.
#whitelist ${DOCUMENTS}
#whitelist ${MUSIC}
#whitelist ${PICTURES}
#whitelist ${VIDEOS}
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
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
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-bin nextcloud,nextcloud-desktop
private-cache
private-dev
private-tmp

dbus-user filter
dbus-user.talk org.freedesktop.secrets
dbus-system none
