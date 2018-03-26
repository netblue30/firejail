# Firejail profile for dosbox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dosbox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.dosbox

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin dosbox
private-dev
private-tmp
