# Firejail profile for thunderbird
# Description: Email, RSS and newsgroup client with integrated spam filter
# This file is overwritten after every install/update
# Persistent local customizations
include thunderbird.local
# Persistent global definitions
include globals.local

# Users have thunderbird set to open a browser by clicking a link in an email
# We are not allowed to blacklist browser-specific directories

noblacklist ${HOME}/.cache/thunderbird
noblacklist ${HOME}/.gnupg
# noblacklist ${HOME}/.icedove
noblacklist ${HOME}/.thunderbird

# Uncomment the next 4 lines or put they in your thunderbird.local to
# allow Firefox to load your profile when clicking a link in an email
#noblacklist ${HOME}/.cache/mozilla
#noblacklist ${HOME}/.mozilla
#whitelist ${HOME}/.cache/mozilla/firefox
#whitelist ${HOME}/.mozilla

# If you have setup Thunderbird to archive emails to a local folder,
# make sure you add the path to that folder to the mkdir and whitelist
# rules below. Otherwise they will be deleted when you close Thunderbird.
# See https://github.com/netblue30/firejail/issues/2357
mkdir ${HOME}/.cache/thunderbird
mkdir ${HOME}/.gnupg
# mkdir ${HOME}/.icedove
mkdir ${HOME}/.thunderbird
whitelist ${HOME}/.cache/thunderbird
whitelist ${HOME}/.gnupg
# whitelist ${HOME}/.icedove
whitelist ${HOME}/.thunderbird

# We need the real /tmp for data exchange when xdg-open handles email attachments on KDE
ignore private-tmp
# machine-id breaks audio in browsers; enable it when sound is not required
# machine-id
read-only ${HOME}/.config/mimeapps.list
# writable-run-user and dbus are needed by enigmail
writable-run-user
ignore nodbus

# If you want to read local mail stored in /var/mail, add the following to thunderbird.local:
# noblacklist /var/mail
# noblacklist /var/spool/mail
# writable-var

# allow browsers
# Redirect
include firefox-common.profile
