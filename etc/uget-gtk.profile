# uGet profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
noroot

whitelist ${DOWNLOADS}
mkdir ~/.config
mkdir ~/.config/uGet
whitelist ~/.config/uGet
include /etc/firejail/whitelist-common.inc
