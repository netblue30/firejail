# Google Chrome unstable browser profile
noblacklist ~/.config/google-chrome-unstable
noblacklist ~/.cache/google-chrome-unstable
noblacklist ~/keepassx.kdbx
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-terminals.inc

# chromium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
#

netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config
mkdir ~/.config/google-chrome-unstable
whitelist ~/.config/google-chrome-unstable
mkdir ~/.cache
mkdir ~/.cache/google-chrome-unstable
whitelist ~/.cache/google-chrome-unstable
mkdir ~/.pki
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

# lastpass, keepassx
whitelist ~/.keepassx
whitelist ~/.config/keepassx
whitelist ~/keepassx.kdbx
whitelist ~/.lastpass
whitelist ~/.config/lastpass
