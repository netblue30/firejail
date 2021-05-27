# Firejail profile for dropbox
# This file is overwritten after every install/update
# Persistent local customizations
include dropbox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/autostart
noblacklist ${HOME}/.dropbox
noblacklist ${HOME}/.dropbox-dist

# Allow python3 (blacklisted by disable-interpreters.inc)
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.dropbox
mkdir ${HOME}/.dropbox-dist
mkdir ${HOME}/Dropbox
mkfile ${HOME}/.config/autostart/dropbox.desktop
whitelist ${HOME}/.config/autostart/dropbox.desktop
whitelist ${HOME}/.dropbox
whitelist ${HOME}/.dropbox-dist
whitelist ${HOME}/Dropbox
include whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

noexec /tmp
