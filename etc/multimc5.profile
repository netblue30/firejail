# Firejail profile for multimc5
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/multimc5.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.java
noblacklist ${HOME}/.local/share/multimc5
noblacklist ${HOME}/.multimc5

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.local/share/multimc5
mkdir ${HOME}/.multimc5
whitelist ${HOME}/.local/share/multimc5
whitelist ${HOME}/.multimc5
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
# seccomp
shell none

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
