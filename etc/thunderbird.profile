# Firejail profile for thunderbird
# Description: Email, RSS and newsgroup client with integrated spam filter
# This file is overwritten after every install/update
# Persistent local customizations
include thunderbird.local
# Persistent global definitions
include globals.local

# Allow enigmail by default
ignore nodbus
writable-run-user

# If you want to read local mail stored in /var/mail, add the following to thunderbird.local:
# noblacklist /var/mail
# noblacklist /var/spool/mail
# TODO: we have whitelist-var-common.inc sure that here is no whitelsit requiered
# writable-var

# Allow Firefox
#noblacklist ${HOME}/.cache/mozilla
#noblacklist ${HOME}/.mozilla
#whitelist ${HOME}/.cache/mozilla/firefox
#whitelist ${HOME}/.mozilla
#seccomp !chroot
#ignore tracelog

# TODO: allow chromium

noblacklist ${HOME}/.cache/thunderbird
noblacklist ${HOME}/.gnupg
# noblacklist ${HOME}/.icedove
noblacklist ${HOME}/.thunderbird

include disable-passwdmgr.inc
include disable-xdg.inc

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

# TODO: move wusc to firefox-common??
whitelist /usr/share/gnupg
whitelist /usr/share/mozilla
include whitelist-usr-share-common.inc

# machine-id breaks audio in browsers; enable or put it in your thunderbird.local when sound is not required
#machine-id
#TODO: novideo???

# private-bin
# private-etc
# We need the real /tmp for data exchange when xdg-open handles email attachments on KDE
ignore private-tmp

read-only ${HOME}/.config/mimeapps.list

# Redirect
include firefox-common.profile
