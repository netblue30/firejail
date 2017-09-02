# Chromium browser profile
noblacklist ~/.config/yandex-browser-beta
noblacklist ~/.cache/yandex-browser-beta
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

# chromium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
#

netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config/yandex-browser-beta
whitelist ~/.config/yandex-browser-beta
mkdir ~/.cache/yandex-browser-beta
whitelist ~/.cache/yandex-browser-beta
mkdir ~/.pki
whitelist ~/.pki

# lastpass, keepassx
whitelist ~/.keepassx
whitelist ~/.config/keepassx
whitelist ~/keepassx.kdbx
whitelist ~/.lastpass
whitelist ~/.config/lastpass

include /etc/firejail/whitelist-common.inc
