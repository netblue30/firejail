# Firejail profile for aweather
# Description: Advanced Weather Monitoring Program
# This file is overwritten after every install/update
# Persistent local customizations
include aweather.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/aweather

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

mkdir ${HOME}/.config/aweather
whitelist ${HOME}/.config/aweather
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
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
protocol unix,inet,inet6
seccomp
tracelog

private-bin aweather
private-dev
private-tmp

restrict-namespaces
