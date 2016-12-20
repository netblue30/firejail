# Vivaldi browser profile
noblacklist ~/.config/vivaldi
noblacklist ~/.cache/vivaldi
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config/vivaldi
whitelist ~/.config/vivaldi
mkdir ~/.cache/vivaldi
whitelist ~/.cache/vivaldi
include /etc/firejail/whitelist-common.inc

# lastpass, keepass
# for keepass we additionally need to whitelist our .kdbx password database
whitelist ~/.keepass
whitelist ~/.config/keepass
whitelist ~/.config/KeePass
whitelist ~/.lastpass
whitelist ~/.config/lastpass
