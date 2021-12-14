# Firejail profile for teams-for-linux
# Description: Unofficial Microsoft Teams client for Linux using Electron.
# This file is overwritten after every install/update
# Persistent local customizations
include teams-for-linux.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore include disable-xdg.inc
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc

ignore noinput

ignore dbus-user none
ignore dbus-system none

noblacklist ${HOME}/.config/teams-for-linux

mkdir ${HOME}/.config/teams-for-linux
whitelist ${HOME}/.config/teams-for-linux

private-bin bash,cut,echo,egrep,electron,electron[0-9],electron[0-9][0-9],grep,head,sed,sh,teams-for-linux,tr,xdg-mime,xdg-open,zsh
private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.preload,localtime,machine-id,pki,resolv.conf,ssl

# Redirect
include electron.profile
