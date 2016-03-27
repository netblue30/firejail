# Telegram IRC profile
noblacklist ${HOME}/.TelegramDesktop
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-terminals.inc

caps.drop all
seccomp
protocol unix,inet,inet6
noroot
netfilter

whitelist ~/Downloads/Telegram Desktop
mkdir ${HOME}/.TelegramDesktop
whitelist ~/.TelegramDesktop
