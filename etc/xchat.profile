# Firejail profile for xchat
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/xchat.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/xchat

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

caps.drop all
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

# private-bin requires perl, python*, etc.
