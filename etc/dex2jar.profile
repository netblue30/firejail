# Firejail profile for dex2jar
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/dex2jar.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
no3d
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
private-dev

noexec ${HOME}
noexec /tmp
