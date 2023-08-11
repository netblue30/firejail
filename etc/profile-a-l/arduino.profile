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

# Allows files commonly used by IDEs
include allow-common-devel.inc

include disable-common.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
netfilter
no3d
nodvd
#nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp

private-cache
private-tmp

restrict-namespaces
