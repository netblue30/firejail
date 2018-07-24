# Firejail profile for dex2jar
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/dex2jar.local
# Persistent global definitions
include /etc/firejail/globals.local

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

private-bin dex2jar,java,sh,bash,expr,dirname,ls,uname,grep
private-cache
private-dev

noexec ${HOME}
noexec /tmp
