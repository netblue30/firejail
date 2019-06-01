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
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix
seccomp
shell none

private-dev
private-tmp

