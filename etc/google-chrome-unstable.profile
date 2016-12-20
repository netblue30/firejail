# Google Chrome unstable browser profile
noblacklist ~/.config/google-chrome-unstable
noblacklist ~/.cache/google-chrome-unstable
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

# chromium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
#

netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config/google-chrome-unstable
whitelist ~/.config/google-chrome-unstable
mkdir ~/.cache/google-chrome-unstable
whitelist ~/.cache/google-chrome-unstable
mkdir ~/.pki
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

# lastpass, keepass
# for keepass we additionally need to whitelist our .kdbx password database
whitelist ~/.keepass
whitelist ~/.config/keepass
whitelist ~/.config/KeePass
whitelist ~/.lastpass
whitelist ~/.config/lastpass
