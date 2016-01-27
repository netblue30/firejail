# uGet profile
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
noroot
whitelist ${DOWNLOADS}
whitelist ~/.config/uGet
include /etc/firejail/whitelist-common.inc
