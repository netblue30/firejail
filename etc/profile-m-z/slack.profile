# Firejail profile for slack
# This file is overwritten after every install/update
# Persistent local customizations
include slack.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore include disable-exec.inc
ignore include disable-xdg.inc
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc
ignore apparmor
ignore novideo
ignore private-tmp
ignore dbus-user none
ignore dbus-system none

noblacklist ${HOME}/.config/Slack

include allow-bin-sh.inc

include disable-shell.inc

mkdir ${HOME}/.config/Slack
whitelist ${HOME}/.config/Slack

private-bin electron,electron[0-9],electron[0-9][0-9],locale,sh,slack
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,debian_version,fedora-release,fonts,group,ld.so.cache,ld.so.conf,localtime,machine-id,os-release,passwd,pki,pulse,redhat-release,resolv.conf,ssl,system-release,system-release-cpe

# Redirect
include electron.profile
