# Firejail profile for thunderbird
# Description: Email, RSS and newsgroup client with integrated spam filter
# This file is overwritten after every install/update
# Persistent local customizations
include thunderbird.local
# Persistent global definitions
include globals.local

ignore include whitelist-runuser-common.inc

# TB stopped supporting enigmail in 2020 (v78) - let's harden D-Bus
# https://support.mozilla.org/en-US/kb/openpgp-thunderbird-howto-and-faq
ignore dbus-user none
dbus-user filter
dbus-user.own org.mozilla.thunderbird.*
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.freedesktop.Notifications
# allow D-Bus communication with firefox for opening links
dbus-user.talk org.mozilla.*
# e2ee email needs writable-run-user
# https://support.mozilla.org/en-US/kb/introduction-to-e2e-encryption
writable-run-user

# If you want to read local mail stored in /var/mail edit /etc/apparmor.d/firejail-default accordingly
# and add the following to thunderbird.local:
#noblacklist /var/mail
#noblacklist /var/spool/mail
#whitelist /var/mail
#whitelist /var/spool/mail
#writable-var

# These lines are needed to allow Firefox to load your profile when clicking a link in an email
noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini

noblacklist ${HOME}/.cache/thunderbird
noblacklist ${HOME}/.gnupg
#noblacklist ${HOME}/.icedove
noblacklist ${HOME}/.thunderbird

include disable-xdg.inc

# If you have setup Thunderbird to archive emails to a local folder,
# make sure you add the path to that folder to the mkdir and whitelist
# rules below. Otherwise they will be deleted when you close Thunderbird.
# See https://github.com/netblue30/firejail/issues/2357
mkdir ${HOME}/.cache/thunderbird
mkdir ${HOME}/.gnupg
#mkdir ${HOME}/.icedove
mkdir ${HOME}/.thunderbird
whitelist ${HOME}/.cache/thunderbird
whitelist ${HOME}/.gnupg
#whitelist ${HOME}/.icedove
whitelist ${HOME}/.thunderbird

whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
whitelist /usr/share/thunderbird

# machine-id breaks audio in browsers; enable or put it in your thunderbird.local when sound is not required
#machine-id
novideo

# We need the real /tmp for data exchange when xdg-open handles email attachments on KDE
ignore private-tmp

# Redirect
include firefox-common.profile
