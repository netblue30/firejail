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

# Add one of the following whitelist options to your firefox.local to enable KeePassXC Plugin support.
# NOTE: start KeePassXC before Firefox and keep it open to allow communication between them.
#whitelist ${RUNUSER}/kpxc_server
#whitelist ${RUNUSER}/org.keepassxc.KeePassXC.BrowserServer

whitelist /usr/share/doc
whitelist /usr/share/firefox
whitelist /usr/share/gnome-shell/search-providers/firefox-search-provider.ini
whitelist /usr/share/gtk-doc/html
whitelist /usr/share/mozilla
whitelist /usr/share/webext
include whitelist-usr-share-common.inc

# firefox requires a shell to launch on Arch - add the next line to your firefox.local to enable private-bin.
#private-bin bash,dbus-launch,dbus-send,env,firefox,sh,which
# Fedora uses shell scripts to launch firefox - add the next line to your firefox.local to enable private-bin.
#private-bin basename,bash,cat,dirname,expr,false,firefox,firefox-wayland,getenforce,ln,mkdir,pidof,restorecon,rm,rmdir,sed,sh,tclsh,true,uname
# Add the next line to your firefox.local to enable private-etc support - note that this must be enabled in your firefox-common.local too.
#private-etc firefox

dbus-user filter
dbus-user.own org.mozilla.Firefox.*
dbus-user.own org.mozilla.firefox.*
dbus-user.own org.mpris.MediaPlayer2.firefox.*
# Add the next line to your firefox.local to enable native notifications.
#dbus-user.talk org.freedesktop.Notifications
# Add the next line to your firefox.local to allow inhibiting screensavers.
#dbus-user.talk org.freedesktop.ScreenSaver
# Add the next lines to your firefox.local for plasma browser integration.
#dbus-user.own org.mpris.MediaPlayer2.plasma-browser-integration
#dbus-user.talk org.kde.JobViewServer
#dbus-user.talk org.kde.kuiserver
# Add the next two lines to your firefox.local to allow screen sharing under wayland.
#whitelist ${RUNUSER}/pipewire-0
#dbus-user.talk org.freedesktop.portal.*
# Add the next line to your firefox.local if screen sharing sharing still does not work
# with the above lines (might depend on the portal implementation).
#ignore noroot
ignore dbus-user none

# Redirect
include firefox-common.profile
