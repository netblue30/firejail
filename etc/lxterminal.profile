# Firejail profile for lxterminal
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/lxterminal.local
# Persistent global definitions
include /etc/firejail/globals.local


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
# noroot - somehow this breaks on Debian Jessie!
nodvd
notv
protocol unix,inet,inet6
seccomp
