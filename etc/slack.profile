noblacklist ${HOME}/.config/Slack
noblacklist ${HOME}/Downloads

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

mkdir ${HOME}/.config
mkdir ${HOME}/.config/Slack
whitelist ${HOME}/.config/Slack
whitelist ${HOME}/Downloads

protocol unix,inet,inet6,netlink
private-dev
private-tmp
private-etc fonts,resolv.conf,ld.so.conf,ld.so.cache,localtime
name slack
blacklist /var

include /etc/firejail/whitelist-common.inc

caps.drop all
seccomp
netfilter
nonewprivs
nogroups
noroot
shell none
private-bin slack
