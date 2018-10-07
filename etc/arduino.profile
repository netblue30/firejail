# Firejail profile for arduino
# Description: AVR development board IDE and built-in libraries
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/arduino.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.arduino15
noblacklist ${HOME}/.java
noblacklist ${HOME}/Arduino
noblacklist ${DOCUMENTS}

# Allow access to java
noblacklist ${PATH}/java
noblacklist /usr/lib/java
noblacklist /etc/java
noblacklist /usr/share/java

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

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

private-cache
private-tmp

noexec ${HOME}
noexec /tmp
