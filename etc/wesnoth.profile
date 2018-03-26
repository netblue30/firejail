# Firejail profile for wesnoth
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/wesnoth.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/wesnoth
noblacklist ${HOME}/.config/wesnoth
noblacklist ${HOME}/.local/share/wesnoth

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/wesnoth
mkdir ${HOME}/.config/wesnoth
mkdir ${HOME}/.local/share/wesnoth
whitelist ${HOME}/.cache/wesnoth
whitelist ${HOME}/.config/wesnoth
whitelist ${HOME}/.local/share/wesnoth
include /etc/firejail/whitelist-common.inc

caps.drop all
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

private-dev
private-tmp
