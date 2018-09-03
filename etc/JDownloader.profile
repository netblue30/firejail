# Firejail profile for JDownloader
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/JDownloader.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist ${HOME}/.jd

# Allow access to java
noblacklist ${PATH}/java
noblacklist /usr/lib/java
noblacklist /etc/java
noblacklist /usr/share/java

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

mkdir ${HOME}/.jd
whitelist ${HOME}/.jd
whitelist ${DOWNLOADS}
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodbus
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

private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
