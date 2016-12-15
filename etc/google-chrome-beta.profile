# Google Chrome beta browser profile
noblacklist ~/.config/google-chrome-beta
noblacklist ~/.cache/google-chrome-beta
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

# chromium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
#

netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config/google-chrome-beta
whitelist ~/.config/google-chrome-beta
mkdir ~/.cache/google-chrome-beta
whitelist ~/.cache/google-chrome-beta
mkdir ~/.pki
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

# lastpass, keepassx
whitelist ~/.keepassx
whitelist ~/.config/keepassx
whitelist ~/keepassx.kdbx
whitelist ~/.lastpass
whitelist ~/.config/lastpass
