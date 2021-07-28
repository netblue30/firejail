# Firejail profile for xchat
# Description: IRC client for X similar to AmIRC
# This file is overwritten after every install/update
# Persistent local customizations
include xchat.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/xchat

include disable-common.inc
include disable-devel.inc
include disable-programs.inc

caps.drop all
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

# private-bin requires perl, python*, etc.
