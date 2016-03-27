# Whitelist-based profile for "Battle for Wesnoth" (game).

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-terminals.inc

caps.drop all
seccomp
protocol unix,inet,inet6
noroot

private-dev

whitelist /tmp/.X11-unix

mkdir ${HOME}/.local
mkdir ${HOME}/.local/share
mkdir ${HOME}/.local/share/wesnoth
mkdir ${HOME}/.config
mkdir ${HOME}/.config/wesnoth
mkdir ${HOME}/.cache
mkdir ${HOME}/.cache/wesnoth
whitelist ${HOME}/.local/share/wesnoth
whitelist ${HOME}/.config/wesnoth
whitelist ${HOME}/.cache/wesnoth
include /etc/firejail/whitelist-common.inc
