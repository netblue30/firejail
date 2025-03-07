# Firejail profile for xarchiver
# Description: Lightweight desktop-independent archive manager
# This file is overwritten after every install/update
# Persistent local customizations
include xarchiver.local
# Persistent global definitions
include globals.local

ignore include disable-shell.inc
ignore x11
ignore dbus-user none

noblacklist ${HOME}/.config/xarchiver
noblacklist ${RUNUSER}

dbus-user filter
dbus-user.talk ca.desrt.dconf

# Redirect
include archiver-common.profile
