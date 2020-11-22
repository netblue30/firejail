# Firejail profile for firefox
# Description: Safe and easy web browser from Mozilla
# This file is overwritten after every install/update
# Persistent local customizations
include firefox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/mozilla
noblacklist ${HOME}/.mozilla

mkdir ${HOME}/.cache/mozilla/firefox
mkdir ${HOME}/.mozilla
whitelist ${HOME}/.cache/mozilla/firefox
whitelist ${HOME}/.mozilla

whitelist /usr/share/doc
whitelist /usr/share/firefox
# Uncomment or put in your firefox.local to enable gnome-shell search provider support
#whitelist /usr/share/gnome-shell/search-providers
whitelist /usr/share/gtk-doc/html
whitelist /usr/share/mozilla
whitelist /usr/share/webext
include whitelist-usr-share-common.inc

# firefox requires a shell to launch on Arch.
#private-bin bash,dbus-launch,dbus-send,env,firefox,sh,which
# Fedora use shell scripts to launch firefox, at least this is required
#private-bin basename,bash,cat,dirname,expr,false,firefox,firefox-wayland,getenforce,ln,mkdir,pidof,restorecon,rm,rmdir,sed,sh,tclsh,true,uname
# private-etc must first be enabled in firefox-common.profile
#private-etc firefox

dbus-user filter
dbus-user.own org.mozilla.firefox.*
dbus-user.own org.mpris.MediaPlayer2.firefox.*
# Uncomment or put in your firefox.local to enable native notifications.
#dbus-user.talk org.freedesktop.Notifications
# Uncomment or put in your firefox.local to allow to inhibit screensavers
#dbus-user.talk org.freedesktop.ScreenSaver
# Uncomment or put in your firefox.local for plasma browser integration
#dbus-user.own org.mpris.MediaPlayer2.plasma-browser-integration
#dbus-user.talk org.kde.JobViewServer
#dbus-user.talk org.kde.kuiserver
ignore dbus-user none

# Redirect
include firefox-common.profile
