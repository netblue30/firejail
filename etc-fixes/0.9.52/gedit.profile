# Firejail profile for gedit
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gedit.local
# Persistent global definitions
include /etc/firejail/globals.local

# blacklist /run/user/*/bus - makes settings immutable

noblacklist ${HOME}/.config/enchant
noblacklist ${HOME}/.config/gedit
noblacklist ${HOME}/.gitconfig

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
# net none - makes settings immutable
machine-id
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
tracelog

# private-bin gedit
private-dev
# private-etc alternatives,fonts
#private-lib gedit - disabled; problems when running "firejail gedit"; "firejail /usr/bin/gedit" works fine
private-tmp

noexec ${HOME}
noexec /tmp
