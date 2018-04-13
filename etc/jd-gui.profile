# Firejail profile for jd-gui
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/jd-gui.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/jd-gui.cfg
noblacklist ${HOME}/.java

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

caps.drop all
net none
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none

private-bin jd-gui,sh,bash
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
