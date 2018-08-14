# Firejail profile for emacs
# Description: GNU Emacs editor
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/emacs.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.emacs
noblacklist ${HOME}/.emacs.d

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
