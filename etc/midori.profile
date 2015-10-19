# Midori browser profile
noblacklist ${HOME}/.config/midori
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-history.inc
caps.drop all
seccomp
netfilter
shell none

