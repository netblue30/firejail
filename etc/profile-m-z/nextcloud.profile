# Firejail profile for nextcloud
# Description: Nextcloud desktop synchronization client
# This file is overwritten after every install/update
# Persistent local customizations
include nextcloud.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/Nextcloud
noblacklist ${HOME}/.config/Nextcloud
noblacklist ${HOME}/.local/share/Nextcloud
# Add the next lines to your nextcloud.local to allow sync in more directories.
#noblacklist ${DOCUMENTS}
#noblacklist ${MUSIC}
#noblacklist ${PICTURES}
#noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/Nextcloud
mkdir ${HOME}/.config/Nextcloud
mkdir ${HOME}/.local/share/Nextcloud
whitelist ${HOME}/Nextcloud
whitelist ${HOME}/.config/Nextcloud
whitelist ${HOME}/.local/share/Nextcloud
whitelist /usr/share/nextcloud
# Add the next lines to your nextcloud.local to allow sync in more directories.
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
seccomp.block-secondary
tracelog

disable-mnt
private-bin nextcloud,nextcloud-desktop
private-cache
private-etc @tls-ca,@x11,Nextcloud,host.conf,os-release
private-dev
private-tmp

# IMPORTANT: create ~/.local/share/dbus-1/services/com.nextcloudgmbh.Nextcloud.service
# referencing the firejailed /usr/local/bin/nextcloud to keep nextcloud running sandboxed
# even when its dbus name gets activated
# see https://github.com/netblue30/firejail/wiki/Frequently-Asked-Questions#how-do-i-sandbox-applications-started-via-systemd-or-d-bus-services
dbus-user filter 
dbus-user.own com.nextcloudgmbh.Nextcloud
dbus-user.talk org.freedesktop.secrets
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
dbus-system none

restrict-namespaces
