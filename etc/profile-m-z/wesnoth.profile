# Firejail profile for wesnoth
# Description: Fantasy turn-based strategy game
# This file is overwritten after every install/update
# Persistent local customizations
include wesnoth.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/wesnoth
nodeny  ${HOME}/.config/wesnoth
nodeny  ${HOME}/.local/share/wesnoth

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/wesnoth
mkdir ${HOME}/.config/wesnoth
mkdir ${HOME}/.local/share/wesnoth
allow  ${HOME}/.cache/wesnoth
allow  ${HOME}/.config/wesnoth
allow  ${HOME}/.local/share/wesnoth
include whitelist-common.inc

caps.drop all
nodvd
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

private-dev
private-tmp
