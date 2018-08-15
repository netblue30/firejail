# Firejail profile for kopete
# Description: Instant messaging and chat application
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/kopete.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.kde/share/apps/kopete
noblacklist ${HOME}/.kde/share/config/kopeterc
noblacklist ${HOME}/.kde4/share/apps/kopete
noblacklist ${HOME}/.kde4/share/config/kopeterc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist /var/lib/winpopup
include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
writable-var

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
