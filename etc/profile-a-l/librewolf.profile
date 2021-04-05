# Firejail profile for Librewolf
# Description: Firefox fork based on privacy
# This file is overwritten after every install/update
# Persistent local customizations
include librewolf.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/librewolf
noblacklist ${HOME}/.librewolf

mkdir ${HOME}/.cache/librewolf
mkdir ${HOME}/.librewolf
whitelist ${HOME}/.cache/librewolf
whitelist ${HOME}/.librewolf

# Uncomment (or add to librewolf.local) the following lines if you want to
# use the migration wizard.
#noblacklist ${HOME}/.mozilla
#whitelist ${HOME}/.mozilla

# Uncomment or put in your librewolf.local one of the following whitelist to enable KeePassXC Plugin
# NOTE: start KeePassXC before Librewolf and keep it open to allow communication between them
#whitelist ${RUNUSER}/kpxc_server
#whitelist ${RUNUSER}/org.keepassxc.KeePassXC.BrowserServer

whitelist /usr/share/doc
whitelist /usr/share/gtk-doc/html
whitelist /usr/share/mozilla
whitelist /usr/share/webext

# librewolf requires a shell to launch on Arch.
#private-bin bash,dbus-launch,dbus-send,env,librewolf,sh,which
# Fedora use shell scripts to launch librewolf, at least this is required
#private-bin basename,bash,cat,dirname,expr,false,librewolf,getenforce,ln,mkdir,pidof,restorecon,rm,rmdir,sed,sh,tclsh,true,uname
# private-etc must first be enabled in firefox-common.profile
#private-etc librewolf

dbus-user filter
# Uncomment or put in your librewolf.local to enable native notifications.
#dbus-user.talk org.freedesktop.Notifications
# Uncomment or put in your librewolf.local to allow to inhibit screensavers
#dbus-user.talk org.freedesktop.ScreenSaver
# Uncomment or put in your librewolf.local for plasma browser integration
#dbus-user.own org.mpris.MediaPlayer2.plasma-browser-integration
#dbus-user.talk org.kde.JobViewServer
#dbus-user.talk org.kde.kuiserver
# Uncomment or put in your librewolf.local to allow screen sharing under wayland.
#whitelist ${RUNUSER}/pipewire-0
#dbus-user.talk org.freedesktop.portal.*
# Also uncomment or put in your librewolf.local if screen sharing sharing still
# does not work with the above lines (might depend on the portal
# implementation)
#ignore noroot
ignore dbus-user none

# Redirect
include firefox-common.profile
