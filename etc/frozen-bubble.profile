# Firejail profile for frozen-bubble
# Description: Cool game where you pop out the bubbles
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/frozen-bubble.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.frozen-bubble

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.frozen-bubble
whitelist ${HOME}/.frozen-bubble
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,netlink
seccomp
shell none

disable-mnt
# private-bin frozen-bubble
private-dev
# private-etc none
private-tmp
