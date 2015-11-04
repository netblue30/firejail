# Chromium browser profile
noblacklist ${HOME}/.config/chromium
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc

# chromium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
#

netfilter
whitelist ~/Downloads
whitelist ~/.config/chromium

# common
whitelist ~/.fonts
whitelist ~/.fonts.d
whitelist ~/.fontconfig
whitelist ~/.fonts.conf
whitelist ~/.fonts.conf.d
