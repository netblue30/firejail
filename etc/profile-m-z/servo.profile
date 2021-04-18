# Firejail profile for servo
# Description: The Servo Browser Engine
# This file is overwritten after every install/update
# Persistent local customizations
include servo.local
# Persistent global definitions
include globals.local

# Servo is usually installed inside $HOME
ignore noexec ${HOME}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

# Add the next lines to your servo.local to turn this into a whitelisting profile.
# You will need to add a whitelist for the directory where servo is installed.
#whitelist ${DOWNLOADS}
#include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin servo,sh
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
