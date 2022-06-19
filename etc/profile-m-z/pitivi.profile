# Firejail profile for pitivi
# Description: Non-linear audio/video editor using GStreamer
# This file is overwritten after every install/update
# Persistent local customizations
include pitivi.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/pitivi

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp

private-dev
private-tmp

