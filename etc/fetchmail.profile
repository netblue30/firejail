# Firejail profile for fetchmail
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/fetchmail.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /boot
blacklist /media
blacklist /mnt
blacklist /opt

# Location of your fetchmailrc - I decrypt it into /tmp/fetchmailrc
# whitelist ${HOME}/.fetchmailrc.gpg
whitelist ${HOME}/.procmailrc.brown
whitelist ${HOME}/.procmailrc.gmail
whitelist ${HOME}/Mail
whitelist ${HOME}/scripts/fetchmail-real.sh
whitelist /tmp/fetchmailrc
include /etc/firejail/whitelist-common.inc

caps.drop all
nogroups
noroot
nosound
seccomp
x11 none

# private-bin fetchmail,procmail,bash,chmod
private-dev
# private-etc passwd,hosts,resolv.conf
