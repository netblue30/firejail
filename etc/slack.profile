# Firejail profile for Slack
noblacklist ${HOME}/.config/Slack
noblacklist ${HOME}/Downloads

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

blacklist /var

caps.drop all
name slack
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none

private-bin slack
private-dev
private-etc fonts,resolv.conf,ld.so.conf,ld.so.cache,localtime
private-tmp

mkdir ${HOME}/.config
mkdir ${HOME}/.config/Slack
whitelist ${HOME}/.config/Slack
whitelist ${HOME}/Downloads
include /etc/firejail/whitelist-common.inc
