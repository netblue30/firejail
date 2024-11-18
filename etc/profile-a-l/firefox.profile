# Firejail profile for firefox
# Description: Safe and easy web browser from Mozilla
# This file is overwritten after every install/update
# Persistent local customizations
include firefox.local
# Persistent global definitions
include globals.local

# Note: Sandboxing web browsers is as important as it is complex. Users might
# be interested in creating custom profiles depending on the use case (e.g. one
# for general browsing, another for banking, ...). Consult our FAQ/issue
# tracker for more information. Here are a few links to get you going:
# https://github.com/netblue30/firejail/wiki/Frequently-Asked-Questions#firefox-doesnt-open-in-a-new-sandbox-instead-it-opens-a-new-tab-in-an-existing-firefox-instance
# https://github.com/netblue30/firejail/wiki/Frequently-Asked-Questions#how-do-i-run-two-instances-of-firefox
# https://github.com/netblue30/firejail/issues/4206#issuecomment-824806968

# (Ignore entry from disable-common.inc)
ignore read-only ${HOME}/.mozilla/firefox/profiles.ini

noblacklist ${HOME}/.cache/mozilla
noblacklist ${HOME}/.mozilla
noblacklist ${RUNUSER}/*firefox*
noblacklist ${RUNUSER}/psd/*firefox*

blacklist /usr/libexec

mkdir ${HOME}/.cache/mozilla/firefox
mkdir ${HOME}/.mozilla
whitelist ${HOME}/.cache/mozilla/firefox
whitelist ${HOME}/.mozilla

whitelist /usr/share/firefox
whitelist /usr/share/gnome-shell/search-providers/firefox-search-provider.ini
whitelist ${RUNUSER}/*firefox*
whitelist ${RUNUSER}/psd/*firefox*

# Note: Firefox requires a shell to launch on Arch and Fedora.
# Add the next lines to firefox.local to enable private-bin.
#private-bin bash,dbus-launch,dbus-send,env,firefox,sh,which
#private-bin basename,bash,cat,dirname,expr,false,firefox,firefox-wayland,getenforce,ln,mkdir,pidof,restorecon,rm,rmdir,sed,sh,tclsh,true,uname
private-etc firefox

dbus-user filter
dbus-user.own org.mozilla.*
dbus-user.own org.mpris.MediaPlayer2.firefox.*
ignore dbus-user none

# Redirect
include firefox-common.profile
