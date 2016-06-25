# Firejail profile for XZ decompressor
# xzdec.profile

include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc

caps.drop all
seccomp
tracelog
noroot
shell none
