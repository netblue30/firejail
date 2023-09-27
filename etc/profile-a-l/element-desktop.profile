# Firejail profile for element-desktop
# Description: All-in-one secure chat app for teams, friends and organisations
# This file is overwritten after every install/update
# Persistent local customizations
include element-desktop.local
# Persistent global definitions
# added by included profile
#include globals.local

ignore dbus-user none

noblacklist ${HOME}/.config/Element

mkdir ${HOME}/.config/Element
whitelist ${HOME}/.config/Element
whitelist /opt/Element

dbus-user filter
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets

# Redirect
include riot-desktop.profile
