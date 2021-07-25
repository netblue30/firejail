# Firejail profile for arduino
# Description: AVR development board IDE and built-in libraries
# This file is overwritten after every install/update
# Persistent local customizations
include arduino.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.arduino15
noblacklist ${HOME}/Arduino
noblacklist ${DOCUMENTS}

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
no3d
nodvd
# nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-cache
private-tmp

