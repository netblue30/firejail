# Firejail profile for steam
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/steam.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.Steam
noblacklist ${HOME}/.Steampath
noblacklist ${HOME}/.Steampid
noblacklist ${HOME}/.java
noblacklist ${HOME}/.local/share/Steam
noblacklist ${HOME}/.local/share/steam
noblacklist ${HOME}/.steam
noblacklist ${HOME}/.steampath
noblacklist ${HOME}/.steampid
# with >=llvm-4 mesa drivers need llvm stuff
noblacklist /usr/lib/llvm*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
notv
# novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
# tracelog disabled as it breaks integrated browser
# tracelog

private-dev
private-tmp
