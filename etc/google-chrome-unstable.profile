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

# lastpass, keepassx
whitelist ~/.keepassx
whitelist ~/.config/keepassx
whitelist ~/keepassx.kdbx
whitelist ~/.lastpass
whitelist ~/.config/lastpass
