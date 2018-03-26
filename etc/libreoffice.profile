# Firejail profile for libreoffice
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/libreoffice.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.java
noblacklist /usr/local/sbin
noblacklist ${HOME}/.config/libreoffice

# libreoffice uses java; if you don't care about java functionality,
# comment the next four lines
noblacklist ${PATH}/java
noblacklist /usr/lib/java
noblacklist /etc/java
noblacklist /usr/share/java

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-dev
private-tmp

noexec ${HOME}
noexec /tmp

join-or-start libreoffice
