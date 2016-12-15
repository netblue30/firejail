# Google Chrome browser profile
noblacklist ~/.config/google-chrome
noblacklist ~/.cache/google-chrome
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

# chromium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
#

netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config/google-chrome
whitelist ~/.config/google-chrome
mkdir ~/.cache/google-chrome
whitelist ~/.cache/google-chrome
mkdir ~/.pki
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

# lastpass, keepassx
whitelist ~/.keepassx
whitelist ~/.config/keepassx
whitelist ~/keepassx.kdbx
whitelist ~/.lastpass
whitelist ~/.config/lastpass

