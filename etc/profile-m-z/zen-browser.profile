# Firejail profile for zen-browser
# Description: A beautifully designed, privacy-focused Firefox fork
# This file is overwritten after every install/update
# Persistent local customizations
include zen-browser.local
# Persistent global definitions
include globals.local

# (Ignore entry from disable-common.inc)
ignore read-only ${HOME}/.zen/profiles.ini

noblacklist ${HOME}/.cache/zen
noblacklist ${HOME}/.zen

# uses libgdk-pixbuf and/or glycin - see #6906
#blacklist /usr/libexec

mkdir ${HOME}/.cache/zen
mkdir ${HOME}/.zen
whitelist ${HOME}/.cache/zen
whitelist ${HOME}/.zen

# Add the following lines to allow access to the .mozilla directory,
# required by some extensions (like KeePassXC-Browser) to work properly
#noblacklist ${HOME}/.config/mozilla
#noblacklist ${HOME}/.mozilla
#mkdir ${HOME}/.config/mozilla
#mkdir ${HOME}/.mozilla
#whitelist ${HOME}/.config/mozilla
#whitelist ${HOME}/.mozilla

# Note: Zen Browser requires a shell to launch on Arch and Fedora.
# Add the next lines to zen-browser.local to enable private-bin.
#private-bin bash,dbus-launch,dbus-send,env,zen-browser,sh,which
#private-bin basename,bash,cat,dirname,expr,false,zen,zen-bin,zen-browser,getenforce,ln,mkdir,pidof,restorecon,rm,rmdir,sed,sh,tclsh,true,uname

dbus-user filter
dbus-user.own org.mozilla.zen.*
dbus-user.own org.mpris.MediaPlayer2.firefox.*
ignore dbus-user none

# Redirect
include firefox-common.profile
