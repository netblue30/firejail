# Telegram profile
noblacklist ${HOME}/.TelegramDesktop
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc

caps.drop all
seccomp
protocol unix,inet,inet6
noroot

whitelist ~/Downloads/Telegram Desktop
whitelist ~/.TelegramDesktop
