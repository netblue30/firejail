# Firejail profile for sylpheed
# Description: Light weight e-mail client with GTK+
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/sylpheed.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.sylpheed-2.0

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

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

private-dev
private-tmp
