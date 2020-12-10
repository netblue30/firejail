# Firejail profile for atom
# Description: A hackable text editor for the 21st Century
# This file is overwritten after every install/update
# Persistent local customizations
include atom.local
# Persistent global definitions
include globals.local

# ADD.A.NOTE.ABC.XYZ
ignore include disable-devel.inc
ignore include disable-interpreters.inc
ignore include disable-xdg.inc
ignore whitelist ${DOWNLOADS}
ignore include whitelist-common.inc
ignore apparmor

noblacklist ${HOME}/.atom
noblacklist ${HOME}/.config/Atom

# Allows files commonly used by IDEs
include allow-common-devel.inc

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

# net none
netfilter
nosound

private-cache
private-dev
private-tmp

# Redirect
include electron.profile
