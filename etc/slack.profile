# Firejail profile for slack
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/slack.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Slack
noblacklist ${HOME}/Downloads

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config
mkdir ${HOME}/.config/Slack
whitelist ${HOME}/.config/Slack
whitelist ${HOME}/Downloads
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
name slack
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

disable-mnt
private-bin slack,locale
private-dev
private-etc asound.conf,ca-certificates,fonts,group,passwd,pulse,resolv.conf,ssl,ld.so.conf,ld.so.cache,localtime,pki,crypto-policies,machine-id
private-tmp
