# Firejail profile for pycharm-community
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/pycharm-community.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/snap
noblacklist ${HOME}/.PyCharmCE*
noblacklist ${HOME}/.java

# Allow access to java
noblacklist ${PATH}/java
noblacklist /usr/lib/java
noblacklist /etc/java
noblacklist /usr/share/java

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
machine-id
nodvd
nogroups
nosound
notv
novideo
shell none
tracelog

# private-etc fonts,passwd - minimal required to run but will probably break
# program!
private-dev
private-tmp

noexec /tmp
