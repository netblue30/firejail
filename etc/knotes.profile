# Firejail profile for knotes
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/knotes.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/akonadi*
noblacklist ${HOME}/.config/knotesrc
noblacklist ${HOME}/.local/share/akonadi/*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

noblacklist ${HOME}/.config/knotesrc
noblacklist ${HOME}/.local/share/knotes


# Redirect
include /etc/firejail/kmail.profile
