# XChat profile
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc xchat hexchat
include /etc/firejail/disable-history.inc
caps.drop all
seccomp
noroot
