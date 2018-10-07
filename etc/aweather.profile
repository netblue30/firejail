# Firejail profile for aweather
# Description: Advanced Weather Monitoring Program
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/aweather.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/aweather

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/aweather
whitelist ${HOME}/.config/aweather
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin aweather
private-dev
private-tmp
