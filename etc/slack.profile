# Firejail profile for slack
# This file is overwritten after every install/update
# Persistent local customizations
include slack.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Slack

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/Slack
whitelist ${HOME}/.config/Slack
whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-var-common.inc

caps.keep sys_chroot,sys_admin
netfilter
nodvd
nogroups
notv
nou2f
shell none

disable-mnt
private-bin locale,slack
private-cache
private-dev
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,debian_version,fedora-release,fonts,group,ld.so.cache,ld.so.conf,localtime,machine-id,os-release,passwd,pki,pulse,redhat-release,resolv.conf,ssl,system-release,system-release-cpe
