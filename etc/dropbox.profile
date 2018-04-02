# Firejail profile for dropbox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dropbox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/autostart
noblacklist ${HOME}/.dropbox
noblacklist ${HOME}/.dropbox-dist

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.dropbox
mkdir ${HOME}/.dropbox-dist
mkdir ${HOME}/Dropbox
mkfile ${HOME}/.config/autostart/dropbox.desktop
whitelist ${HOME}/.config/autostart/dropbox.desktop
whitelist ${HOME}/.dropbox
whitelist ${HOME}/.dropbox-dist
whitelist ${HOME}/Dropbox
include /etc/firejail/whitelist-common.inc

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

private-dev
private-tmp

noexec /tmp
