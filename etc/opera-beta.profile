# Opera-beta browser profile
noblacklist ~/.config/opera-beta
noblacklist ~/.cache/opera-beta
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config/opera-beta
whitelist ~/.config/opera-beta
mkdir ~/.cache/opera-beta
whitelist ~/.cache/opera-beta
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
