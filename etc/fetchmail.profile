# Firejail profile for fetchmail
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/fetchmail.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.fetchmailrc
noblacklist ${HOME}/.netrc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
no3d
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

#private-bin fetchmail,procmail,bash,chmod
private-dev
