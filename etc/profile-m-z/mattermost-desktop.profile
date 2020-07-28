# Firejail profile for mattermost-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include mattermost-desktop.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Mattermost

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-passwdmgr.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/Mattermost
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/Mattermost
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.keep sys_admin,sys_chroot
netfilter
nodvd
nogroups
notv
nou2f
novideo
shell none

disable-mnt
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,machine-id,nsswitch.conf,pki,resolv.conf,ssl
private-tmp

# Not tested
#dbus-user filter
#dbus-user.own com.mattermost.Desktop
#dbus-user.talk org.freedesktop.Notifications
#dbus-system none
