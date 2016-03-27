# whitelist profile for Hedgewars (game)

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
noroot
private-dev
seccomp
tracelog

mkdir     ~/.hedgewars
whitelist ~/.hedgewars
